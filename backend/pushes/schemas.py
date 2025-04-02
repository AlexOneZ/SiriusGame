from pydantic import BaseModel
from datetime import datetime


class Device(BaseModel):
    """
    Represents a device that can receive push notifications.

    Attributes:
        id (int | None): The unique identifier for the device.
        token (str): The device token used for push notifications. Required.
        name (str): The name of the device.
        systemName (str): The name of the operating system running on the device.
        systemVersion (str): The version of the operating system running on the device.
        model (str): The model of the device.
        localizedModel (str): The localized model of the device.
        created_at (datetime | None): The date and time the device was created.
        updated_at (datetime | None): The date and time the device was last updated.
    """

    id: int | None = None
    token: str
    name: str | None = None
    systemName: str | None = None
    systemVersion: str | None = None
    model: str | None = None
    localizedModel: str | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class Message(BaseModel):
    """
    Represents a message to be sent to one or more recipients.

    Attributes:
        recipients (list[str]): List of recipient tokens.
        title (str): Title of the notification.
        body (str): Message body to send.
        destination (str | None): Destination for the notification.
        sound (str | None): Sound to play with notification.
    """

    recipients: list[str]
    title: str
    body: str
    destination: str | None = None
    sound: str | None = "default"
