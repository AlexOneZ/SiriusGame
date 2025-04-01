# backend/pushes/apn_handler/client.py

import collections
import httpx
import json
import traceback # Импортируем traceback для вывода стектрейса
from enum import Enum
from typing import Dict, Iterable, Optional, Tuple, Union
import ssl

# Убираем импорт logging
# import logging

from .credentials import Credentials, CertificateCredentials, TokenCredentials
from .errors import exception_class_for_reason, APNsException, Unregistered, BadDeviceToken, ConnectionFailed
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

# Убираем получение логгера
# logger = logging.getLogger(__name__)


class APNsClient(object):
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
            print("WARNING: Initializing APNsClient with certificate path (string) - Ensure this is intended.")
            self.__credentials = CertificateCredentials(credentials, password)
        elif isinstance(credentials, Credentials):
             self.__credentials = credentials
        else:
            raise TypeError("credentials must be a Credentials instance or a certificate path string")

        self._init_connection(
            use_sandbox, use_alternative_port, proto, proxy_host, proxy_port
        )

        if heartbeat_period:
            raise NotImplementedError("heartbeat_period is not supported in this HTTPX-based client")

        self.__json_encoder = json_encoder

    def _init_connection(
            self,
            use_sandbox: bool,
            use_alternative_port: bool,
            proto: Optional[str],
            proxy_host: Optional[str],
            proxy_port: Optional[int],
    ) -> None:
        self.__server = self.SANDBOX_SERVER if use_sandbox else self.LIVE_SERVER
        self.__port = (
            self.ALTERNATIVE_PORT if use_alternative_port else self.DEFAULT_PORT
        )
        print(f"INFO: APNsClient initialized for server: {self.__server}:{self.__port}")

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
                print("DEBUG: Using certificate SSL context for HTTPX client.")
            elif isinstance(self.__credentials, TokenCredentials):
                 print("DEBUG: Using default SSL context for HTTPX client (TokenCredentials).")
                 # verify_context = ssl.create_default_context()
            else:
                 print("WARNING: Unknown credentials type, using default SSL context.")


            with httpx.Client(http2=True, verify=verify_context) as client:
                status, reason = self.send_notification_sync(
                    token_hex,
                    notification,
                    client,
                    topic,
                    priority,
                    expiration,
                    collapse_id,
                )

            if status != 200:
                print(f"WARNING: APNs send failed for {token_hex}. Status: {status}, Reason: {reason}")
                try:
                    exception_class = exception_class_for_reason(reason)
                    # Handle Unregistered needing no args
                    if exception_class is Unregistered:
                         # Print before raising
                         print(f"RAISING: {exception_class.__name__}")
                         raise exception_class()
                    else:
                         # Print before raising
                         print(f"RAISING: {exception_class.__name__} with reason: {reason}")
                         raise exception_class(reason)
                except (KeyError, TypeError):
                    print(f"ERROR: Unknown APNs error reason: {reason}")
                    # Print before raising
                    final_reason = f"APNs error: {reason} (Status: {status})"
                    print(f"RAISING: APNsException with reason: {final_reason}")
                    raise APNsException(final_reason)
            else:
                # При УСПЕШНОЙ отправке тоже выводим
                print(f"INFO: APNs notification sent successfully to {token_hex}")

        except httpx.RequestError as e:
             print(f"EXCEPTION: HTTPX Request Error during single APNs send: {e}")
             traceback.print_exc()
             # Print before raising
             final_reason = f"HTTPX Request Error: {e}"
             print(f"RAISING: ConnectionFailed with reason: {final_reason}")
             raise ConnectionFailed(final_reason) from e
        except APNsException:
             # Just re-raise known APNs exceptions after they've been printed above
             raise
        except Exception as e:
             print(f"EXCEPTION: Unexpected Error during single APNs send: {e}")
             traceback.print_exc()
             # Print before raising
             final_reason = f"Unexpected error: {e}"
             print(f"RAISING: APNsException with reason: {final_reason}")
             raise APNsException(final_reason) from e


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
            json_payload_dict = notification.dict()
            json_str = json.dumps(
                json_payload_dict,
                cls=self.__json_encoder,
                ensure_ascii=False,
                separators=(",", ":"),
            )
            json_payload_bytes = json_str.encode("utf-8")
        except Exception as e:
             print("EXCEPTION: Error encoding APNs payload!")
             traceback.print_exc()
             return 400, f"Payload Encoding Error: {e}"

        headers = {}
        inferred_push_type = None

        if topic is not None:
            headers["apns-topic"] = topic
            if push_type is None:
                if topic.endswith(".voip"): inferred_push_type = NotificationType.VoIP.value
                elif topic.endswith(".complication"): inferred_push_type = NotificationType.Complication.value
                elif topic.endswith(".pushkit.fileprovider"): inferred_push_type = NotificationType.FileProvider.value
                elif any(key in json_payload_dict.get("aps", {}) for key in ["alert", "badge", "sound"]): inferred_push_type = NotificationType.Alert.value
                elif "content-available" in json_payload_dict.get("aps", {}): inferred_push_type = NotificationType.Background.value
                else:
                     # Simplified default logic
                     inferred_push_type = NotificationType.Alert.value if "aps" in json_payload_dict else NotificationType.Background.value
                     print(f"DEBUG: Could not strongly infer push type for topic {topic}, defaulting to {inferred_push_type}")
        elif isinstance(self.__credentials, CertificateCredentials):
             print("WARNING: APNs topic not provided for CertificateCredentials. APNs might return MissingTopic error.")

        final_push_type = push_type.value if push_type else inferred_push_type
        if final_push_type:
            headers["apns-push-type"] = final_push_type
        else:
            # Don't add the header if we couldn't determine it
            print("WARNING: Could not determine apns-push-type. Header will not be added.")


        if priority != DEFAULT_APNS_PRIORITY: headers["apns-priority"] = priority.value
        if expiration is not None: headers["apns-expiration"] = "%d" % expiration

        # --- ВЫВОД ЗАГОЛОВКОВ ДО АУТЕНТИФИКАЦИИ ---
        print(f"DEBUG: APNs Headers (pre-auth): {headers}")
        # -------------------------------------------------

        if isinstance(self.__credentials, TokenCredentials):
            try:
                auth_header = self.__credentials.get_authorization_header(topic)
                if auth_header is not None:
                    headers["authorization"] = auth_header
                    # --- ВЫВОД ТОКЕНА (частично) ---
                    log_auth_header = auth_header[:15] + "..." + auth_header[-5:]
                    print(f"DEBUG: APNs Authorization Header added: Bearer {log_auth_header}")
                    # --------------------------------------
                else:
                    print("ERROR: Failed to get APNs authorization header (returned None).")
                    return 403, "MissingProviderToken" # Return error directly
            except Exception as e:
                print("EXCEPTION: Error getting APNs authorization header!")
                traceback.print_exc()
                return 403, f"ProviderTokenGenerationError: {e}" # Return error directly

        if collapse_id is not None: headers["apns-collapse-id"] = collapse_id

        url = f"https://{self.__server}:{self.__port}/3/device/{token_hex}"

        # =========================================================
        # === ВЫВОД ТОГО, ЧТО ОТПРАВЛЯЕТСЯ, ПРЯМО ПЕРЕД ЗАПРОСОМ ===
        # =========================================================
        print(f"INFO: --> Sending APNs Request to: {url}")
        try:
            print(f"DEBUG: --> APNs Request Headers: {json.dumps(headers, indent=2)}")
            # Using json_payload_dict which is already a dictionary
            print(f"DEBUG: --> APNs Request Payload: {json.dumps(json_payload_dict, indent=2, ensure_ascii=False)}")
        except Exception as log_e:
             print(f"ERROR: Error formatting request data for printing: {log_e}")
        # =========================================================

        try:
            response = client.post(url, headers=headers, content=json_payload_bytes) # Use content= for bytes

            # =========================================================
            # === ВЫВОД ТОГО, ЧТО ПОЛУЧЕНО В ОТВЕТ ===
            # =========================================================
            response_text = response.text # Get text first
            print(f"INFO: <-- APNs Response Status: {response.status_code}")
            print(f"DEBUG: <-- APNs Response Body: {response_text}")
            # =========================================================

            reason = ""
            if response.status_code != 200:
                try:
                    # Attempt to parse JSON only if there's text
                    if response_text:
                         response_json = response.json()
                         reason = response_json.get("reason", response_text) # Use text as fallback
                    else:
                         reason = f"Empty response body (Status: {response.status_code})"
                except json.JSONDecodeError:
                    # If JSON parsing fails, use the raw text as the reason
                    reason = response_text
            else:
                # Status is 200, mark as Success
                 reason = "Success"


            return response.status_code, reason

        except httpx.RequestError as e:
            print(f"EXCEPTION: HTTPX Request Error sending APNs notification: {e}")
            traceback.print_exc()
            return 503, f"HTTPX Request Error: {type(e).__name__}" # Service Unavailable suggested
        except Exception as e:
            print(f"EXCEPTION: Unexpected Error sending APNs notification: {e}")
            traceback.print_exc()
            return 500, f"Unexpected Error: {type(e).__name__}"


    def get_notification_result(
            self, status: int, reason: str
    ) -> str: # Simplified return type to string
        if status == 200:
            return "Success"
        else:
            # Return the reason string directly (it's already 'Success' or error reason)
            return reason

    def send_notification_batch(
            self,
            notifications: Iterable[Notification],
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
            push_type: Optional[NotificationType] = None,
    ) -> Dict[str, str]: # Return dict mapping token to result string
        results = {}

        verify_context = None
        if isinstance(self.__credentials, CertificateCredentials):
            verify_context = self.__credentials.ssl_context
            print("DEBUG: Using certificate SSL context for batch HTTPX client.")
        else:
             print("DEBUG: Using default SSL context for batch HTTPX client.")

        try:
            # Use a single client for the whole batch
            with httpx.Client(http2=True, verify=verify_context) as client:
                for next_notification in notifications:
                    token = next_notification.token
                    payload = next_notification.payload
                    # Вывод перед отправкой будет внутри send_notification_sync
                    print(f"INFO: Processing batch notification for token {token[:10]}...")
                    status, reason = self.send_notification_sync(
                        token,
                        payload,
                        client,
                        topic,
                        priority,
                        expiration,
                        collapse_id,
                        push_type,
                    )
                    # send_notification_sync now returns 'Success' or the error reason string
                    results[token] = reason
                    # Вывод после получения ответа будет внутри send_notification_sync

        except httpx.RequestError as e:
             print(f"EXCEPTION: HTTPX Request Error during batch APNs send: {e}")
             traceback.print_exc()
             error_msg = f"HTTPX Request Error: {type(e).__name__}"
             # Fill results with error for all originally intended tokens
             results = {n.token: error_msg for n in notifications if n.token not in results}
        except Exception as e:
             print(f"EXCEPTION: Unexpected Error during batch APNs send: {e}")
             traceback.print_exc()
             error_msg = f"Unexpected Batch Error: {type(e).__name__}"
             # Fill results with error for all originally intended tokens
             results = {n.token: error_msg for n in notifications if n.token not in results}

        print(f"INFO: Batch send processed. Results: {results}")
        return results

    def connect(self) -> None:
        print("DEBUG: APNsClient.connect called (no-op for HTTPX client)")
        pass