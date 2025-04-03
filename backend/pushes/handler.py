# backend/pushes/handler.py

import logging
import json
from typing import List, Dict, Tuple, Union, Optional  # Добавляем Optional

from .apn_handler import (
    APNsClient,
    Payload,
    TokenCredentials,
    Notification,
    NotificationPriority,
    NotificationType,
    APNsException,
    Unregistered,
    BadDeviceToken,
    exception_class_for_reason,
)
from .config import PushConfig
from .repository import DeviceRepository

logger = logging.getLogger(__name__)


class PushHandler:
    def __init__(self):
        self.token_credentials: TokenCredentials = PushConfig.get_token_credentials()
        self.use_sandbox: bool = True
        self.connection: APNsClient = APNsClient(
            credentials=self.token_credentials, use_sandbox=self.use_sandbox
        )
        self.topic: str = PushConfig.get_apns_app_bundle_id()

    async def send_multiple_push(
            self,
            to_device_tokens: List[str],
            title: str,
            body: str,
            destination: Optional[str] = None,  # Используем Optional
            sound: Optional[str] = "default",  # Используем Optional
            badge: Optional[int] = 1,  # Используем Optional
            priority: NotificationPriority = NotificationPriority.Immediate,
            push_type: NotificationType = NotificationType.Alert,
            custom_payload: Optional[Dict] = None,  # Используем Optional
    ) -> Dict[str, str]:

        if not to_device_tokens:
            logger.info("No device tokens provided for send_multiple_push.")
            return {}

        try:
            token_id_map = await DeviceRepository.get_device_id_map_by_tokens(to_device_tokens)
            valid_tokens = list(token_id_map.keys())
            if len(valid_tokens) < len(to_device_tokens):
                invalid_tokens = set(to_device_tokens) - set(valid_tokens)
                logger.warning(f"Some requested tokens not found in DB and will be skipped: {invalid_tokens}")
        except Exception as e:
            logger.exception("Failed to retrieve device IDs for tokens. Aborting push.")
            return {token: f"Failed to get device info: {e}" for token in to_device_tokens}

        if not valid_tokens:
            logger.warning("No valid device tokens found in DB for the push request.")
            return {}

        effective_custom_payload = custom_payload or {}
        if destination:
            effective_custom_payload["destination"] = destination

        alert_content = {"title": title, "body": body}
        payload = Payload(
            alert=alert_content,
            sound=sound,
            badge=badge,
            custom=effective_custom_payload if effective_custom_payload else None
        )

        notifications_to_send = [
            Notification(token=token, payload=payload) for token in valid_tokens
        ]

        apns_results: Dict[str, str] = {}
        try:
            apns_results = self.connection.send_notification_batch(
                notifications=notifications_to_send,
                topic=self.topic,
                priority=priority,
                # push_type=push_type - apn_handler сам определит
            )
            logger.info(f"APNs batch send results: {apns_results}")

        except Exception as e:
            error_reason = f"Batch send failed: {type(e).__name__} - {e}"
            logger.exception(error_reason)
            apns_results = {token: error_reason for token in valid_tokens}

        history_entries_to_add = []
        tokens_to_remove = []

        for token in valid_tokens:
            apns_status = apns_results.get(token, "SendAttemptFailed")

            device_id = token_id_map.get(token)
            if device_id:
                history_entries_to_add.append({
                    "device_id": device_id,
                    "title": title,
                    "body": body,
                    "apns_status": apns_status,
                    "destination": destination,
                    "sound": sound,
                    # sent_at - default in DB
                })
            else:
                logger.error(
                    f"Consistency error: device_id not found for valid token {token} during history recording.")

            if apns_status not in ["Success", None, "SendAttemptFailed"]:
                try:
                    exception_class = exception_class_for_reason(apns_status)

                    # Commented for DEBUG
                    # if exception_class in (Unregistered, BadDeviceToken):
                    #     tokens_to_remove.append(token)
                except KeyError:
                    logger.debug(f"APNs status '{apns_status}' for token {token} is not a reason for removal.")
                except Exception as e_check:
                    logger.exception(f"Error checking APNs status '{apns_status}' for removal: {e_check}")

        if history_entries_to_add:
            try:
                await DeviceRepository.add_notification_history_batch(history_entries_to_add)
                logger.info(f"Added {len(history_entries_to_add)} entries to notification history.")
            except Exception as e_hist:
                logger.exception(f"Failed to add notification history batch: {e_hist}")

        if tokens_to_remove:
            logger.info(f"Removing invalid tokens based on APNs feedback: {tokens_to_remove}")
            removed_count = 0
            for token in set(tokens_to_remove):
                try:
                    if await DeviceRepository.delete_device_by_token(token):
                        removed_count += 1
                except Exception as e_delete:
                    logger.exception(f"Failed to delete token {token} from repository: {e_delete}")
            logger.info(f"Successfully removed {removed_count} invalid tokens.")

        final_api_results = {token: "TokenNotFoundInDB" for token in set(to_device_tokens) - set(valid_tokens)}
        final_api_results.update(apns_results)

        return final_api_results
