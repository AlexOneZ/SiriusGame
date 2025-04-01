import logging
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
)
from .config import PushConfig
from .repository import DeviceRepository

logger = logging.getLogger(__name__)

class PushHandler:
    """
    A wrapper class for sending push notifications using APNs.
    Handles batch sending and potential token removal.
    """

    def __init__(self):
        self.token_credentials: TokenCredentials = PushConfig.get_token_credentials()
        self.use_sandbox: bool = True # DEBUG
        self.connection: APNsClient = APNsClient(
            credentials=self.token_credentials, use_sandbox=self.use_sandbox
        )
        self.topic: str = PushConfig.get_apns_app_bundle_id()

    async def send_push(
        self,
        to_device_token: str,
        body: str,
        title: str | None = None,
        sound: str = "default",
        badge: int | None = 1,
        priority: NotificationPriority = NotificationPriority.Immediate,
        push_type: NotificationType = NotificationType.Alert,
        custom_payload: dict | None = None,
    ) -> bool:
        """
        Sends a push notification to a single device token.

        Returns:
            bool: True if successful, False otherwise.
        """
        payload = Payload(alert=body, sound=sound, badge=badge, custom=custom_payload)
        if title:
             payload.alert = {"title": title, "body": body}

        try:
            self.connection.send_notification(
                token_hex=to_device_token,
                notification=payload,
                topic=self.topic,
                priority=priority,
            )
            logger.info(f"Successfully sent push to {to_device_token}")
            return True
        except (Unregistered, BadDeviceToken) as e:
            logger.warning(f"Device token {to_device_token} is invalid ({e.__class__.__name__}). Removing.")
            await DeviceRepository.delete_device_by_token(to_device_token)
            return False
        except APNsException as e:
            logger.error(f"Failed to send push to {to_device_token}: {e.__class__.__name__} - {e}")
            return False
        except Exception as e:
            logger.exception(f"An unexpected error occurred while sending push to {to_device_token}: {e}")
            return False


    async def send_multiple_push(
        self,
        to_device_tokens: List[str],
        body: str,
        title: str | None = None,
        sound: str = "default",
        badge: int | None = 1,
        priority: NotificationPriority = NotificationPriority.Immediate,
        push_type: NotificationType = NotificationType.Alert,
        custom_payload: dict | None = None,
    ) -> Dict[str, Union[str, Tuple[str, str]]]:
        """
        Sends a push notification to multiple device tokens using batch mode.
        Removes invalid tokens from the database.

        Returns:
            Dict[str, Union[str, Tuple[str, str]]]: A dictionary mapping tokens to their results ('Success' or error reason).
        """
        payload = Payload(alert=body, sound=sound, badge=badge, custom=custom_payload)
        if title:
             payload.alert = {"title": title, "body": body}

        notifications = [
            Notification(token=token, payload=payload) for token in to_device_tokens
        ]

        if not notifications:
            return {}

        try:
            results = self.connection.send_notification_batch(
                notifications=notifications,
                topic=self.topic,
                priority=priority,
            )

            tokens_to_remove = []
            for token, result in results.items():
                if result != "Success":
                    logger.warning(f"Failed to send to {token}: {result}")
                    try:
                        if isinstance(result, str):
                             exception_class = self.connection.exception_class_for_reason(result)
                             if exception_class in (Unregistered, BadDeviceToken):
                                 tokens_to_remove.append(token)
                    except (KeyError, TypeError):
                         logger.warning(f"Unknown error reason for token {token}: {result}")


            if tokens_to_remove:
                logger.info(f"Removing invalid tokens: {tokens_to_remove}")
                for token in tokens_to_remove:
                    await DeviceRepository.delete_device_by_token(token)

            return results

        except APNsException as e:
            logger.error(f"APNs batch send error: {e.__class__.__name__} - {e}")
            return {token: f"Batch send error: {e.__class__.__name__}" for token in to_device_tokens}
        except Exception as e:
            logger.exception(f"An unexpected error occurred during batch send: {e}")
            return {token: f"Unexpected batch error: {e}" for token in to_device_tokens}