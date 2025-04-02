import ssl
import time
from typing import Optional, Tuple

import jwt

DEFAULT_TOKEN_LIFETIME = 2700
DEFAULT_TOKEN_ENCRYPTION_ALGORITHM = "ES256"


class Credentials:
    def __init__(self, ssl_context: Optional[ssl.SSLContext] = None) -> None:
        self.ssl_context = ssl_context

    def get_authorization_header(self, topic: Optional[str]) -> Optional[str]:
        return None


class CertificateCredentials(Credentials):
    def __init__(
            self,
            cert_file: Optional[str] = None,
            password: Optional[str] = None
    ) -> None:
        ssl_context = ssl.create_default_context()
        ssl_context.load_cert_chain(cert_file, password=password)
        super().__init__(ssl_context)


class TokenCredentials(Credentials):
    def __init__(
            self,
            auth_key_path: str,
            auth_key_id: str,
            team_id: str,
            encryption_algorithm: str = DEFAULT_TOKEN_ENCRYPTION_ALGORITHM,
            token_lifetime: int = DEFAULT_TOKEN_LIFETIME,
    ) -> None:
        self.__auth_key = self._load_signing_key(auth_key_path)
        self.__auth_key_id = auth_key_id
        self.__team_id = team_id
        self.__encryption_algorithm = encryption_algorithm
        self.__token_lifetime = token_lifetime
        self.__jwt_token: Optional[Tuple[float, str]] = None

        super().__init__()

    def get_authorization_header(self, topic: Optional[str]) -> str:
        return f"Bearer {self._get_or_create_token()}"

    def _is_token_expired(self, issue_date: float) -> bool:
        return time.time() > issue_date + self.__token_lifetime

    @staticmethod
    def _load_signing_key(key_path: str) -> str:
        if not key_path:
            raise ValueError("APNs auth key path is required")

        try:
            with open(key_path, 'r') as key_file:
                secret = key_file.read().strip()
        except FileNotFoundError:
            raise ValueError(f"Auth key file not found: {key_path}")
        except IOError as e:
            raise ValueError(f"Error reading auth key: {str(e)}")

        if not secret:
            raise ValueError(f"Empty auth key in file: {key_path}")

        return secret

    def _get_or_create_token(self) -> str:
        if self.__jwt_token and not self._is_token_expired(self.__jwt_token[0]):
            return self.__jwt_token[1]

        issued_at = time.time()
        token_payload = {
            "iss": self.__team_id,
            "iat": issued_at
        }
        token_headers = {
            "alg": self.__encryption_algorithm,
            "kid": self.__auth_key_id
        }

        jwt_token = jwt.encode(
            token_payload,
            self.__auth_key,
            algorithm=self.__encryption_algorithm,
            headers=token_headers
        )

        if isinstance(jwt_token, bytes):
            jwt_token = jwt_token.decode('utf-8')

        self.__jwt_token = (issued_at, jwt_token)
        return jwt_token
