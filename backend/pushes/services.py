from fastapi import Depends
from .handler import PushHandler
from database import DeviceEntity
from .schemas import Device, Message
from sqlalchemy import select
from database import new_session
from sqlalchemy.orm import Session


class PushService:
    """
    A service for sending push notifications.

    Attributes:
        handler (PushHandler): The handler used to send push notifications. Injected by FastAPI.

    Methods:
        send_push(message: Message) -> None: Sends a push notification.
    """

    def __init__(self, handler: PushHandler = Depends()):
        """
        Initialize the PushService.

        Args:
            handler (PushHandler): The push notification handler to use. Injected by FastAPI.
        """
        self.handler = handler

    def send_push(self, message: Message) -> None:
        """
        Send a push notification.

        Args:
            message (Message): The message to send.

        Returns:
            None
        """
        self.handler.send_multiple_push(
            to_device_tokens=message.recipients, body=message.body
        )


class DeviceService:
    """
    A service for registering and managing devices.

    Attributes:
        session (Session): The database session to use. Injected by FastAPI.

    Methods:
        register_device(device: Device) -> Device: Register a device.
        get_registered_devices() -> list[Device]: Get all registered devices.
        clear_registered_devices() -> None: Clear all registered devices.
    """

    def __init__(self, session: Session = Depends(new_session)):
        """
        Initialize the DeviceService.

        Args:
            session (Session): The database session to use. Injected by FastAPI.
        """
        self._session = session

    def register_device(self, device: Device) -> Device:
        """
        Register a device.

        Args:
            device (Device): The device to register.

        Returns:
            Device: The registered device.
        """
        device_entity = DeviceEntity.from_model(device)
        self._session.add(device_entity)
        self._session.commit()
        return device_entity.to_model()

    def get_registered_devices(self) -> list[Device]:
        """
        Get all registered devices.

        Returns:
            list[Device]: A list of Device objects representing all registered devices.
        """
        devices = self._session.execute(select(DeviceEntity)).scalars().all()
        return [device.to_model() for device in devices]

    def clear_registered_devices(self) -> None:
        """
        Clear all registered devices.

        This method deletes all registered devices from the database.
        """
        self._session.execute(select(DeviceEntity)).delete()
        self._session.commit()
