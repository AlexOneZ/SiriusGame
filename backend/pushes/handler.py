import logging
import json
from typing import List, Dict, Tuple, Union

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

    async def send_push(
            self, to_device_token: str, title: str, body: str,
            destination: str | None = None, sound: str = "default",
            badge: int | None = 1,
            priority: NotificationPriority = NotificationPriority.Immediate,
            push_type: NotificationType = NotificationType.Alert,
            custom_payload: dict | None = None,
    ) -> bool:
        # Initialize custom payload dictionary if not provided
        if custom_payload is None:
            custom_payload = {}

        # Add destination to custom payload if provided
        if destination:
            custom_payload["destination"] = destination

        payload = Payload(alert={"title": title, "body": body}, sound=sound, badge=badge, custom=custom_payload)

        try:
            self.connection.send_notification(
                token_hex=to_device_token, notification=payload,
                topic=self.topic, priority=priority,
            )
            logger.info(f"Successfully sent push to {to_device_token}")
            return True
        except (Unregistered, BadDeviceToken) as e:
            logger.warning(f"Device token {to_device_token} is invalid ({e.__class__.__name__}). Removing.")
            await DeviceRepository.delete_device_by_token(to_device_token)
            return False
        except APNsException as e:
            reason = getattr(e, 'reason', str(e))
            logger.error(f"Failed to send push to {to_device_token}: {e.__class__.__name__} - {reason}")
            if reason and reason in ("Unregistered", "BadDeviceToken"):
                logger.info(f"Marking token {to_device_token} for removal due to single send error: {reason}")
                await DeviceRepository.delete_device_by_token(to_device_token)
            return False
        except Exception as e:
            logger.exception(f"An unexpected error occurred while sending push to {to_device_token}: {e}")
            return False

    async def send_multiple_push(
            self, to_device_tokens: List[str], title: str, body: str,
            destination: str | None = None, sound: str = "default",
            badge: int | None = 1,
            priority: NotificationPriority = NotificationPriority.Immediate,
            push_type: NotificationType = NotificationType.Alert,
            custom_payload: dict | None = None,
    ) -> Dict[str, Union[str, Tuple[str, str]]]:
        # Initialize custom payload dictionary if not provided
        if custom_payload is None:
            custom_payload = {}

        # Add destination to custom payload if provided
        if destination:
            custom_payload["destination"] = destination

        payload = Payload(alert={"title": title, "body": body}, sound=sound, badge=badge, custom=custom_payload)

        notifications = [
            Notification(token=token, payload=payload) for token in to_device_tokens
        ]

        if not notifications:
            logger.info("No device tokens provided for send_multiple_push.")
            return {}

        results = {}
        try:
            raw_results = self.connection.send_notification_batch(
                notifications=notifications, topic=self.topic, priority=priority,
            )

            tokens_to_remove = []
            processed_results = {}

            for token, result_data_str in raw_results.items():
                reason = None
                is_success = result_data_str == "Success"

                if is_success:
                    processed_results[token] = "Success"
                    continue

                try:
                    error_info = json.loads(result_data_str)
                    if isinstance(error_info, dict) and 'reason' in error_info:
                        reason = error_info['reason']
                        processed_results[token] = reason
                    else:
                        logger.warning(f"Unexpected error JSON format for token {token}: {result_data_str}")
                        processed_results[token] = f"Unknown format: {result_data_str}"
                        continue
                except json.JSONDecodeError:
                    logger.warning(f"Non-JSON error response for token {token}: {result_data_str}")
                    processed_results[token] = f"Non-JSON error: {result_data_str}"
                    continue
                except Exception as e_parse:
                    logger.exception(f"Error parsing APNs response '{result_data_str}' for token {token}: {e_parse}")
                    processed_results[token] = f"Parse error: {result_data_str}"
                    continue

                logger.warning(f"Failed to send to {token}: {reason}")

                try:
                    if reason:
                        exception_class = exception_class_for_reason(reason)
                        if exception_class in (Unregistered, BadDeviceToken):
                            logger.info(f"Marking token {token} for removal due to: {reason}")
                            tokens_to_remove.append(token)
                except KeyError:
                    logger.warning(f"Unknown APNs error reason code encountered: {reason}")
                except Exception as e_inner:
                    logger.exception(f"Error processing APNs reason '{reason}' for token {token}: {e_inner}")

            if tokens_to_remove:
                logger.info(f"Removing invalid tokens: {tokens_to_remove}")
                for token in tokens_to_remove:
                    try:
                        await DeviceRepository.delete_device_by_token(token)
                    except Exception as e_delete:
                        logger.exception(f"Failed to delete token {token} from repository: {e_delete}")

            return processed_results

        except APNsException as e:
            error_reason = getattr(e, 'reason', str(e))
            logger.error(f"APNs batch send error: {e.__class__.__name__} - {error_reason}")
            return {token: f"Batch send error: {error_reason}" for token in to_device_tokens}
        except Exception as e:
            logger.exception(f"An unexpected error occurred during batch send: {e}")
            return {token: f"Unexpected batch error: {type(e).__name__}" for token in to_device_tokens}