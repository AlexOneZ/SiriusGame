# backend/pushes/apn_handler/client.py

import collections
import json
import traceback  # Уже импортирован
from enum import Enum
from typing import Dict, Iterable, Optional, Tuple, Union

import httpx

# Убедимся, что все нужные импорты на месте
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
        print(f"DEBUG: APNsClient.__init__ called")  # DEBUG
        print(f"DEBUG:   use_sandbox={use_sandbox}")  # DEBUG
        print(f"DEBUG:   use_alternative_port={use_alternative_port}")  # DEBUG
        print(f"DEBUG:   credentials type={type(credentials).__name__}")  # DEBUG

        if isinstance(credentials, str):
            print("DEBUG:   Credentials are provided as certificate path string.")  # DEBUG
            self.__credentials = CertificateCredentials(credentials, password)
        elif isinstance(credentials, Credentials):
            print("DEBUG:   Credentials are provided as Credentials object.")  # DEBUG
            self.__credentials = credentials
        else:
            # Эта ошибка должна остановить выполнение
            raise TypeError("Credentials must be a Credentials instance or certificate path string")

        self._init_connection(use_sandbox, use_alternative_port, proto, proxy_host, proxy_port)
        self.__json_encoder = json_encoder

        if heartbeat_period:
            # Это тоже ошибка
            raise NotImplementedError("Heartbeat period is not supported in HTTPX-based client")
        print("DEBUG: APNsClient.__init__ finished")  # DEBUG

    def _init_connection(
            self,
            use_sandbox: bool,
            use_alternative_port: bool,
            proto: Optional[str],
            proxy_host: Optional[str],
            proxy_port: Optional[int],
    ) -> None:
        print("DEBUG: APNsClient._init_connection called")  # DEBUG
        self.__server = self.SANDBOX_SERVER if use_sandbox else self.LIVE_SERVER
        self.__port = self.ALTERNATIVE_PORT if use_alternative_port else self.DEFAULT_PORT
        print(f"INFO: APNsClient configured for server: {self.__server}:{self.__port}")  # INFO (уже было)

    def send_notification(
            self,
            token_hex: str,
            notification: Payload,
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
    ) -> None:
        print(f"\nDEBUG: APNsClient.send_notification called for token: {token_hex[:10]}...")  # DEBUG
        try:
            verify_context = None
            if isinstance(self.__credentials, CertificateCredentials):
                print("DEBUG:   Using certificate SSL context for HTTPX client.")  # DEBUG
                verify_context = self.__credentials.ssl_context
            else:
                print("DEBUG:   Using default SSL context for HTTPX client (Token or unknown credentials).")  # DEBUG

            # Создаем клиент прямо здесь
            print("DEBUG:   Creating httpx.Client...")  # DEBUG
            with httpx.Client(http2=True, verify=verify_context) as client:
                print("DEBUG:   httpx.Client created.")  # DEBUG
                print(f"DEBUG:   Calling send_notification_sync for token {token_hex[:10]}...")  # DEBUG
                status, reason = self.send_notification_sync(
                    token_hex, notification, client, topic, priority, expiration, collapse_id
                )
                print(f"DEBUG:   send_notification_sync returned: status={status}, reason='{reason}'")  # DEBUG

            # Обработка результата
            if status != 200:
                print(f"DEBUG:   Handling error response (status={status}, reason='{reason}')")  # DEBUG
                self._handle_error_response(token_hex, status, reason)  # Этот метод вызовет исключение
            else:
                # Это сообщение уже было, оставим его
                print(f"INFO: Successfully sent notification to {token_hex}")

        except httpx.RequestError as e:
            print(f"EXCEPTION: HTTPX Request Error in send_notification: {e}")  # EXCEPTION
            error_msg = f"Connection failed: {e}"
            traceback.print_exc()  # Печатаем traceback
            print(f"RAISING: ConnectionFailed: {error_msg}")  # RAISING
            raise ConnectionFailed(error_msg) from e
        except APNsException as e:
            # Перехватываем исключения, брошенные из _handle_error_response
            print(f"EXCEPTION: APNsException caught in send_notification: {type(e).__name__} - {e}")  # EXCEPTION
            print(f"RAISING: Re-raising APNsException {type(e).__name__}")  # RAISING
            raise  # Просто перебрасываем дальше
        except Exception as e:
            print(f"EXCEPTION: Unexpected Error in send_notification: {e}")  # EXCEPTION
            error_msg = f"Unexpected error: {e}"
            traceback.print_exc()  # Печатаем traceback
            print(f"RAISING: APNsException: {error_msg}")  # RAISING
            raise APNsException(error_msg) from e
        print(f"DEBUG: APNsClient.send_notification finished for token: {token_hex[:10]}...")  # DEBUG

    def send_notification_sync(
            self,
            token_hex: str,
            notification: Payload,
            client: httpx.Client,
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
            push_type: Optional[NotificationType] = None,  # Добавим этот параметр снова
    ) -> Tuple[int, str]:
        print(f"DEBUG:   APNsClient.send_notification_sync called for token {token_hex[:10]}...")  # DEBUG
        try:
            print("DEBUG:     Encoding payload...")  # DEBUG
            json_payload = self._encode_payload(notification)
            print(f"DEBUG:     Payload encoded ({len(json_payload)} bytes).")  # DEBUG

            print("DEBUG:     Building headers...")  # DEBUG
            headers = self._build_headers(topic, priority, expiration, collapse_id, push_type, notification)
            print(f"DEBUG:     Headers built: {headers}")  # DEBUG (выводим заголовки)

            url = f"https://{self.__server}:{self.__port}/3/device/{token_hex}"
            print(f"INFO:      --> Sending APNs Request to: {url}")  # INFO (уже было, сместим отступ)
            # Добавим вывод тела запроса перед отправкой
            try:
                payload_dict_for_log = json.loads(json_payload.decode('utf-8'))
                print(
                    f"DEBUG:     --> APNs Request Payload: {json.dumps(payload_dict_for_log, indent=2, ensure_ascii=False)}")
            except Exception as log_e:
                print(f"ERROR: Error formatting payload for logging: {log_e}")

            print(f"DEBUG:     Making POST request using httpx client...")  # DEBUG
            response = client.post(url, headers=headers, content=json_payload)
            print(f"DEBUG:     POST request completed.")  # DEBUG

            print("DEBUG:     Processing response...")  # DEBUG
            status, reason = self._process_response(response)
            print(f"DEBUG:     Response processed: status={status}, reason='{reason}'")  # DEBUG
            return status, reason

        except httpx.RequestError as e:
            # Ошибки сети обрабатываются здесь
            print(f"EXCEPTION: HTTPX Request Error in send_notification_sync: {e}")  # EXCEPTION
            traceback.print_exc()
            return 503, f"HTTPX Request Error: {type(e).__name__}"
        except Exception as e:
            # Другие неожиданные ошибки (например, в _encode_payload, _build_headers)
            print(f"EXCEPTION: Unexpected Error in send_notification_sync: {e}")  # EXCEPTION
            traceback.print_exc()
            return 500, f"Unexpected Error: {type(e).__name__}"

    def _encode_payload(self, notification: Payload) -> bytes:
        print("DEBUG:       APNsClient._encode_payload called")  # DEBUG
        try:
            payload_dict = notification.dict()
            print(f"DEBUG:         Payload dictionary: {payload_dict}")  # DEBUG
            encoded_payload = json.dumps(
                payload_dict,
                cls=self.__json_encoder,
                ensure_ascii=False,
                separators=(",", ":"),
            ).encode("utf-8")
            print("DEBUG:       Payload encoded successfully.")  # DEBUG
            return encoded_payload
        except Exception as e:
            # Эта ошибка должна быть перехвачена выше, но лог полезен
            print(f"EXCEPTION: Error during payload encoding: {e}")  # EXCEPTION
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
        print("DEBUG:       APNsClient._build_headers called")  # DEBUG
        headers = {}
        if topic:
            print(f"DEBUG:         Adding header apns-topic: {topic}")  # DEBUG
            headers["apns-topic"] = topic
            determined_push_type = self._determine_push_type(topic, notification, push_type)
            print(f"DEBUG:         Adding header apns-push-type: {determined_push_type}")  # DEBUG
            headers["apns-push-type"] = determined_push_type
        else:
            print("DEBUG:         Topic not provided, skipping apns-topic and apns-push-type headers.")  # DEBUG

        if priority != DEFAULT_APNS_PRIORITY:
            print(f"DEBUG:         Adding header apns-priority: {priority.value}")  # DEBUG
            headers["apns-priority"] = priority.value
        else:
            print(f"DEBUG:         Using default priority, skipping apns-priority header.")  # DEBUG

        if expiration is not None:
            exp_str = str(expiration)
            print(f"DEBUG:         Adding header apns-expiration: {exp_str}")  # DEBUG
            headers["apns-expiration"] = exp_str

        if collapse_id is not None:
            print(f"DEBUG:         Adding header apns-collapse-id: {collapse_id}")  # DEBUG
            headers["apns-collapse-id"] = collapse_id

        # Добавление заголовка аутентификации
        if isinstance(self.__credentials, TokenCredentials):
            print("DEBUG:         Credentials are TokenCredentials, getting authorization header...")  # DEBUG
            try:
                # Вызов get_authorization_header из credentials.py (там должен быть свой debug print)
                auth_header = self.__credentials.get_authorization_header(topic)
                if auth_header:
                    print(
                        f"DEBUG:         Adding header authorization: Bearer {auth_header[:15]}...{auth_header[-5:]}")  # DEBUG
                    headers["authorization"] = auth_header
                else:
                    # Это серьезная проблема, если токен не сгенерировался
                    print("ERROR:         Failed to get authorization header (returned None or empty).")  # ERROR
                    # Возможно, стоит бросить исключение здесь? Зависит от логики credentials.
            except Exception as e:
                print(f"EXCEPTION: Error getting authorization header in _build_headers: {e}")  # EXCEPTION
                traceback.print_exc()
                # Решаем, что делать - бросать исключение или возвращать заголовки без auth?
                # Пока просто выводим ошибку и продолжаем без auth заголовка.
                # raise APNsException(f"Failed to generate auth token: {e}") from e
        else:
            print("DEBUG:         Credentials are not TokenCredentials, skipping authorization header.")  # DEBUG

        print("DEBUG:       Headers building finished.")  # DEBUG
        return headers

    @staticmethod
    def _determine_push_type(
            topic: str,
            notification: Payload,
            push_type: Optional[NotificationType]
    ) -> str:
        # Здесь нет смысла добавлять print, т.к. логика простая и результат виден в _build_headers
        if push_type:
            return push_type.value

        payload_aps = notification.dict().get("aps", {})
        if topic.endswith(".voip"): return NotificationType.VoIP.value
        if topic.endswith(".complication"): return NotificationType.Complication.value
        if topic.endswith(".pushkit.fileprovider"): return NotificationType.FileProvider.value
        # Проверяем на background только если есть content-available
        if "content-available" in payload_aps and not any(k in payload_aps for k in ["alert", "badge", "sound"]):
            return NotificationType.Background.value
        # Во всех остальных случаях считаем Alert (даже если пустой aps)
        return NotificationType.Alert.value

    @staticmethod
    def _process_response(response: httpx.Response) -> Tuple[int, str]:
        print("DEBUG:         APNsClient._process_response called")  # DEBUG
        response_text = ""
        try:
            response_text = response.text
            # Эти print уже были, оставим их
            print(f"INFO: <-- APNs Response Status: {response.status_code}")
            print(f"DEBUG: <-- APNs Response Body: {response_text}")

            # Пытаемся распарсить JSON только если есть тело ответа
            if response_text:
                response_data = response.json()
                reason = response_data.get("reason",
                                           "Success" if response.status_code == 200 else response_text)  # Используем текст как fallback если reason нет
                print(f"DEBUG:         Parsed JSON reason: '{reason}'")  # DEBUG
                return response.status_code, reason
            else:
                # Нет тела ответа
                reason = "Success" if response.status_code == 200 else "Empty response body"
                print(f"DEBUG:         Empty response body. Reason: '{reason}'")  # DEBUG
                return response.status_code, reason

        except json.JSONDecodeError:
            # Тело ответа не JSON
            print("DEBUG:         Response body is not valid JSON.")  # DEBUG
            reason = response_text if response_text else f"Non-JSON empty body (Status: {response.status_code})"
            print(f"DEBUG:         Using raw text as reason: '{reason}'")  # DEBUG
            return response.status_code, reason
        except Exception as e:
            print(f"EXCEPTION: Unexpected error processing response: {e}")  # EXCEPTION
            traceback.print_exc()
            # Возвращаем статус и текст ошибки как reason
            return response.status_code, f"Response processing error: {type(e).__name__}"

    @staticmethod
    def _handle_error_response(token_hex: str, status: int, reason: str) -> None:
        print(f"DEBUG:     APNsClient._handle_error_response called for token {token_hex[:10]}...")  # DEBUG
        print(f"DEBUG:       Status: {status}, Reason: '{reason}'")  # DEBUG
        try:
            print("DEBUG:       Looking up exception class for reason...")  # DEBUG
            exception_class = exception_class_for_reason(reason)
            print(f"DEBUG:       Found exception class: {exception_class.__name__}")  # DEBUG
            # Создаем и выбрасываем исключение
            if exception_class is Unregistered:
                print(f"RAISING:   Raising {exception_class.__name__}()")  # RAISING
                raise exception_class()
            else:
                print(f"RAISING:   Raising {exception_class.__name__}('{reason}')")  # RAISING
                raise exception_class(reason)  # Передаем reason в конструктор
        except (KeyError, TypeError):
            # Если причина не найдена в словаре errors.py
            print(f"DEBUG:       Reason '{reason}' not found in known APNs errors.")  # DEBUG
            final_reason = f"APNs error: {reason} (Status: {status})"
            print(f"RAISING:   Raising generic APNsException('{final_reason}')")  # RAISING
            raise APNsException(final_reason)

    def send_notification_batch(
            self,
            notifications: Iterable[Notification],
            topic: Optional[str] = None,
            priority: NotificationPriority = NotificationPriority.Immediate,
            expiration: Optional[int] = None,
            collapse_id: Optional[str] = None,
            push_type: Optional[NotificationType] = None,
    ) -> Dict[str, str]:
        print(
            f"\nDEBUG: APNsClient.send_notification_batch called for {len(list(notifications))} notifications")  # DEBUG
        results = {}
        verify_context = None
        if isinstance(self.__credentials, CertificateCredentials):
            print("DEBUG:   Using certificate SSL context for batch HTTPX client.")  # DEBUG
            verify_context = self.__credentials.ssl_context
        else:
            print("DEBUG:   Using default SSL context for batch HTTPX client.")  # DEBUG

        try:
            print("DEBUG:   Creating httpx.Client for batch...")  # DEBUG
            with httpx.Client(http2=True, verify=verify_context) as client:
                print("DEBUG:   httpx.Client created. Starting batch processing loop...")  # DEBUG
                # Преобразуем Iterable в список, чтобы можно было вывести количество
                notification_list = list(notifications)
                total_count = len(notification_list)
                for i, notification in enumerate(notification_list):
                    token_short = notification.token[:10]
                    print(f"\nDEBUG:   Processing batch item {i + 1}/{total_count} for token {token_short}...")  # DEBUG
                    # Вызовы sync и обработка ответа будут выводить свои DEBUG сообщения
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
                    # send_notification_sync возвращает 'Success' или причину ошибки
                    results[notification.token] = reason
                    print(
                        f"DEBUG:   Batch item {i + 1}/{total_count} processed for {token_short}. Result: '{reason}'")  # DEBUG

        except Exception as e:
            # Ловим ЛЮБЫЕ ошибки на уровне всего батча (например, ошибка создания клиента)
            print(f"EXCEPTION: Error during batch processing (outside individual send): {e}")  # EXCEPTION
            traceback.print_exc()
            error_msg = f"Batch processing error: {type(e).__name__}"
            print(f"DEBUG:   Filling remaining results with error: {error_msg}")  # DEBUG
            # Заполняем ошибкой только те токены, для которых еще нет результата
            original_tokens = [n.token for n in notification_list]
            results.update({token: error_msg for token in original_tokens if token not in results})

        print(f"\nINFO: Batch send processing finished. Final Results: {results}")  # INFO
        print("DEBUG: APNsClient.send_notification_batch finished")  # DEBUG
        return results

    def connect(self) -> None:
        # Не используется с HTTPX, просто оставим pass
        print("DEBUG: APNsClient.connect called (no-op)")  # DEBUG
        pass
