import ssl
import time
import traceback
from typing import Optional, Tuple

import jwt

DEFAULT_TOKEN_LIFETIME = 2700
DEFAULT_TOKEN_ENCRYPTION_ALGORITHM = "ES256"


class Credentials(object):
    def __init__(self, ssl_context: Optional[ssl.SSLContext] = None) -> None:
        super().__init__()
        self.ssl_context = ssl_context

    def get_authorization_header(self, topic: Optional[str]) -> Optional[str]:
        return None


class CertificateCredentials(Credentials):
    def __init__(
            self, cert_file: Optional[str] = None, password: Optional[str] = None
    ) -> None:
        ssl_context = ssl.create_default_context()
        ssl_context.load_cert_chain(cert_file, password=password)
        super(CertificateCredentials, self).__init__(ssl_context)


class TokenCredentials(Credentials):
    def __init__(
            self,
            auth_key_path: str,
            auth_key_id: str,
            team_id: str,
            encryption_algorithm: str = DEFAULT_TOKEN_ENCRYPTION_ALGORITHM,
            token_lifetime: int = DEFAULT_TOKEN_LIFETIME,
    ) -> None:
        self.__auth_key = self._get_signing_key(auth_key_path)
        self.__auth_key_id = auth_key_id
        self.__team_id = team_id
        self.__encryption_algorithm = encryption_algorithm
        self.__token_lifetime = token_lifetime

        self.__jwt_token = None  # type: Optional[Tuple[float, str]]

        super(TokenCredentials, self).__init__()

    def get_authorization_header(self, topic: Optional[str]) -> str:
        token = self._get_or_create_topic_token()
        return f"Bearer {token}"

    def _is_expired_token(self, issue_date: float) -> bool:
        return time.time() > issue_date + self.__token_lifetime

    @staticmethod
    def _get_signing_key(key_path: str) -> str:
        secret = ""
        if key_path:
            try:
                with open(key_path, 'r') as f:
                    secret = f.read()
            except FileNotFoundError:
                print(f"ERROR: APNs Auth Key file not found at path: {key_path}")
                raise
            except Exception as e:
                print(f"ERROR: Failed to read APNs Auth Key file: {e}")
                traceback.print_exc()
                raise
        else:
            print("ERROR: APNs Auth Key path is not configured (key_path is empty).")
            raise ValueError("APNs Auth Key path cannot be empty for TokenCredentials")

        if not secret:
            print(f"ERROR: APNs Auth Key file at {key_path} seems to be empty.")
            raise ValueError("APNs Auth Key content is empty")

        return secret

    def _get_or_create_topic_token(self) -> str:
        token_pair = self.__jwt_token
        if token_pair is None or self._is_expired_token(token_pair[0]):
            issued_at = time.time()
            token_dict = {
                "iss": self.__team_id,
                "iat": issued_at,
            }
            headers = {
                "alg": self.__encryption_algorithm,
                "kid": self.__auth_key_id,
            }

            jwt_bytes = jwt.encode(
                token_dict,
                self.__auth_key,
                algorithm=self.__encryption_algorithm,
                headers=headers,
            )

            if isinstance(jwt_bytes, bytes):
                jwt_string = jwt_bytes.decode('utf-8')
            else:
                jwt_string = jwt_bytes

            print(f"DEBUG: Generated new APNs JWT token (expiring in {self.__token_lifetime}s).")
            self.__jwt_token = (issued_at, jwt_string)
            return jwt_string
        else:
            print("DEBUG: Using cached APNs JWT token.")
            return token_pair[1]
