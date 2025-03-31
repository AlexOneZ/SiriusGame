from fastapi import APIRouter, Depends
from .schemas import Device, Message
from .repository import DeviceRepository
from .services import PushService

router = APIRouter(
    prefix="/pushes",
    tags=["pushes"],
    responses={404: {"description": "Not found"}},
)


@router.post("/send")
def send_push(message: Message, pushService: PushService = Depends()):
    """
    Sends a push notification using the specified push service.

    Args:
        message (Message): The message to send.
        pushService (PushService): The push service to use. Injected by FastAPI.

    Returns:
        The result of sending the push notification.
    """
    return pushService.send_push(message)


@router.post("/register", response_model=Device)
def register_device(device: Device, deviceService: DeviceRepository = Depends()):
    """
    Registers a new device with the push notification framework.

    Args:
        device (Device): The device to register.
        deviceService (DeviceRepository): An instance of the DeviceService class. Injected by FastAPI.

    Returns:
        Device: The registered device.
    """
    return deviceService.register_device(device)


@router.get("/all", response_model=list[Device])
def get_registered_devices(
        deviceService: DeviceRepository = Depends(),
):
    """
    Retrieve a list of all registered devices.

    Args:
        deviceService (DeviceRepository): An instance of the DeviceService class. Injected by FastAPI.

    Returns:
        list[Device]: A list of Device objects representing all registered devices.
    """
    return deviceService.get_registered_devices()


# FOR TESTING PURPOSES ONLY
@router.get("/clear", response_model=None)
def clear_registered_devices(
        deviceService: DeviceRepository = Depends(),
):
    """
    Clears all registered devices from the device service.
    """
    return deviceService.clear_registered_devices()
