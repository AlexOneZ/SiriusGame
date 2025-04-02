import collections
import json
import traceback
from enum import Enum
from typing import Dict, Iterable, Optional, Tuple, Union

import httpx

from .credentials import Credentials, CertificateCredentials, TokenCredentials
from .errors import exception_class_for_reason, APNsException, Unregistered, ConnectionFailed
from .payload import Payload


class NotificationPriority(Enum):
    Immediate = "10"
    Delayed = "5"


class NotificationType(Enum):
    Alert = "alert"
    Background = "background"
    VoIP = "voip"
    Complication = "complication"
    FileProvider = "fileprovider"
    MDM = "mdm"


RequestStream = collections.namedtuple("RequestStream", ["token", "status", "reason"])
Notification = collections.namedtuple("Notification", ["token", "payload"])

DEFAULT_APNS_PRIORITY = NotificationPriority.Immediate
CONCURRENT_STREAMS_SAFETY_MAXIMUM = 1000
MAX_CONNECTION_RETRIES = 3


class APNsClient:
    SANDBOX_SERVER = "api.development.push.apple.com"
    LIVE_SERVER = "api.push.apple.com"
    DEFAULT_PORT = 443
    ALTERNATIVE_PORT = 2197

    def __init__(
            self,
            credentials: Union[Credentials, str],
            use_sandbox: bool = False,
            use_alternative_port: bool = False,
            proto: Optional[str] = None,
            json_encoder: Optional[type] = None,
            password: Optional[str] = None,
            proxy_host: Optional[str] = None,
            proxy_port: Optional[int] = None,
            heartbeat_period: Optional[float] = None,
    ) -> None:
        if isinstance(credentials, str):
            self.__credentials = CertificateCredentials(credentials, password)
        elif isinstance(credentials, Credentials):
            self.__credentials = credentials
        else:
            raise TypeError("Credentials must be a Credentials instance or certificate path string")

        self._init_connection(use_sandbox, use_alternative_port, proto, proxy_host, proxy_port)
        self.__json_encoder = json_encoder

        if heartbeat_period:
            raise NotImplementedError("Heartbeat period is not supported in HTTPX-based client")

    def _init_connection(
            self,
            use_sandbox: bool,
            use_alternative_port: bool,
            proto: Optional[str],
            proxy_host: Optional[str],
            proxy_port: Optional[int],
    ) -> None:
        self.__server = self.SANDBOX_SERVER if use_sandbox else self.LIVE_SERVER
        self.__port = self.ALTERNATIVE_PORT if use_alternative_port else self.DEFAULT_PORT

    def send_notification(
            self,
            token_hex: str,
            notification: Payload,
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
    ) -> None:
        try:
            verify_context = None
            if isinstance(self.__credentials, CertificateCredentials):
                verify_context = self.__credentials.ssl_context

            with httpx.Client(http2=True, verify=verify_context) as client:
                status, reason = self.send_notification_sync(
                    token_hex, notification, client, topic, priority, expiration, collapse_id
                )

            if status != 200:
                self._handle_error_response(token_hex, status, reason)
            else:
                print(f"INFO: Successfully sent notification to {token_hex}")

        except httpx.RequestError as e:
            error_msg = f"Connection failed: {e}"
            traceback.print_exc()
            raise ConnectionFailed(error_msg) from e
        except APNsException:
            raise
        except Exception as e:
            error_msg = f"Unexpected error: {e}"
            traceback.print_exc()
            raise APNsException(error_msg) from e

    def send_notification_sync(
            self,
            token_hex: str,
            notification: Payload,
            client: httpx.Client,
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
            push_type: Optional[NotificationType] = None,
    ) -> Tuple[int, str]:
        try:
            json_payload = self._encode_payload(notification)
            headers = self._build_headers(topic, priority, expiration, collapse_id, push_type, notification)
            url = f"https://{self.__server}:{self.__port}/3/device/{token_hex}"

            response = client.post(url, headers=headers, content=json_payload)
            return self._process_response(response)

        except httpx.RequestError as e:
            return 503, f"HTTPX Request Error: {type(e).__name__}"
        except Exception as e:
            return 500, f"Unexpected Error: {type(e).__name__}"

    def _encode_payload(self, notification: Payload) -> bytes:
        try:
            payload_dict = notification.dict()
            return json.dumps(
                payload_dict,
                cls=self.__json_encoder,
                ensure_ascii=False,
                separators=(",", ":"),
            ).encode("utf-8")
        except Exception as e:
            traceback.print_exc()
            raise ValueError(f"Payload encoding error: {e}") from e

    def _build_headers(
            self,
            topic: Optional[str],
            priority: NotificationPriority,
            expiration: Optional[int],
            collapse_id: Optional[str],
            push_type: Optional[NotificationType],
            notification: Payload,
    ) -> Dict:
        headers = {}
        if topic:
            headers["apns-topic"] = topic
            headers["apns-push-type"] = self._determine_push_type(topic, notification, push_type)

        if priority != DEFAULT_APNS_PRIORITY:
            headers["apns-priority"] = priority.value

        if expiration is not None:
            headers["apns-expiration"] = str(expiration)

        if collapse_id is not None:
            headers["apns-collapse-id"] = collapse_id

        if isinstance(self.__credentials, TokenCredentials):
            auth_header = self.__credentials.get_authorization_header(topic)
            if auth_header:
                headers["authorization"] = auth_header

        return headers

    @staticmethod
    def _determine_push_type(
            topic: str,
            notification: Payload,
            push_type: Optional[NotificationType]
    ) -> str:
        if push_type:
            return push_type.value

        payload_aps = notification.dict().get("aps", {})
        if topic.endswith(".voip"):
            return NotificationType.VoIP.value
        if topic.endswith(".complication"):
            return NotificationType.Complication.value
        if topic.endswith(".pushkit.fileprovider"):
            return NotificationType.FileProvider.value
        if "content-available" in payload_aps:
            return NotificationType.Background.value
        return NotificationType.Alert.value

    @staticmethod
    def _process_response(response: httpx.Response) -> Tuple[int, str]:
        try:
            response_data = response.json() if response.text else {}
            return response.status_code, response_data.get("reason", "Success")
        except json.JSONDecodeError:
            return response.status_code, response.text

    @staticmethod
    def _handle_error_response(token_hex: str, status: int, reason: str) -> None:
        try:
            exception_class = exception_class_for_reason(reason)
            if exception_class is Unregistered:
                raise exception_class()
            raise exception_class(reason)
        except (KeyError, TypeError):
            raise APNsException(f"APNs error: {reason} (Status: {status})")

    def send_notification_batch(
            self,
            notifications: Iterable[Notification],
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
            push_type: Optional[NotificationType] = None,
    ) -> Dict[str, str]:
        results = {}
        verify_context = self.__credentials.ssl_context if isinstance(self.__credentials,
                                                                      CertificateCredentials) else None

        try:
            with httpx.Client(http2=True, verify=verify_context) as client:
                for notification in notifications:
                    status, reason = self.send_notification_sync(
                        notification.token,
                        notification.payload,
                        client,
                        topic,
                        priority,
                        expiration,
                        collapse_id,
                        push_type,
                    )
                    results[notification.token] = reason
        except Exception as e:
            error_msg = f"Batch processing error: {type(e).__name__}"
            results = {n.token: error_msg for n in notifications if n.token not in results}

        return results

    def connect(self) -> None:
        pass
