from fastapi import APIRouter, Depends, HTTPException, status
from typing import List

from .schemas import Device, Message
from .repository import DeviceRepository
from .handler import PushHandler

router = APIRouter(
    prefix="/pushes",
    tags=["pushes"],
    responses={404: {"description": "Not found"}},
)


@router.post("/send")
async def send_push(message: Message, handler: PushHandler = Depends()):  # Используем async def и Depends для handler
    """
    Sends a push notification to specified recipients.
    """
    if not message.recipients:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Recipient list cannot be empty")

    results = await handler.send_multiple_push(
        to_device_tokens=message.recipients,
        title=message.title,
        body=message.body,
        destination=message.destination,
        sound=message.sound
    )
    return {"results": results}


@router.post("/register", response_model=Device)
async def register_device(device: Device):
    """
    Registers a new device or updates existing one based on the token.
    """
    registered_device = await DeviceRepository.register_device(device)
    return registered_device


@router.get("/all", response_model=List[Device])
async def get_registered_devices():
    """
    Retrieve a list of all registered devices.
    """
    devices = await DeviceRepository.get_registered_devices()
    return devices


# FOR TESTING PURPOSES ONLY
@router.delete("/clear", status_code=status.HTTP_200_OK)
async def clear_registered_devices():
    """
    Clears all registered devices from the database.
    """
    deleted_count = await DeviceRepository.clear_registered_devices()
    return {"ok": True, "deleted_count": deleted_count}


@router.delete("/token/{token}", status_code=status.HTTP_200_OK)
async def delete_device(token: str):
    """
    Deletes a specific device by its token.
    """
    success = await DeviceRepository.delete_device_by_token(token)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Device token not found")
    return {"ok": True, "detail": f"Device with token {token} deleted."}


@router.post("/send_to_all")
async def send_push_to_all(message: Message, handler: PushHandler = Depends()):
    """
    Sends a push notification to ALL registered devices.
    Ignores recipients in the message body, uses the message body/title.
    """
    all_tokens = await DeviceRepository.get_device_tokens()
    if not all_tokens:
        return {"message": "No registered devices to send to."}

    results = await handler.send_multiple_push(
        to_device_tokens=all_tokens,
        title=message.title,
        body=message.body,
        destination=message.destination,
        sound=message.sound
    )
    return {"results": results}
