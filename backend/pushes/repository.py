from sqlalchemy import select, delete
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from database import new_session, DeviceEntity
from .schemas import Device


class DeviceRepository:
    @classmethod
    async def register_device(cls, device: Device) -> Device:
        async with new_session() as session:
            query = select(DeviceEntity).where(DeviceEntity.token == device.token)
            result = await session.execute(query)
            existing_device = result.scalars().first()

            if existing_device:
                existing_device.name = device.name
                existing_device.systemName = device.systemName
                existing_device.systemVersion = device.systemVersion
                existing_device.model = device.model
                existing_device.localizedModel = device.localizedModel
                await session.commit()
                await session.refresh(existing_device)
                return existing_device.to_model()
            else:
                device_data = device.model_dump(exclude={'id', 'created_at', 'updated_at'}, exclude_none=True)
                device_entity = DeviceEntity(**device_data)
                session.add(device_entity)
                try:
                    await session.commit()
                    await session.refresh(device_entity)
                    return device_entity.to_model()
                except IntegrityError:
                    await session.rollback()
                    query = select(DeviceEntity).where(DeviceEntity.token == device.token)
                    result = await session.execute(query)
                    existing_device = result.scalars().first()
                    if existing_device:
                        return existing_device.to_model()
                    else:
                        raise HTTPException(
                            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail="Could not register device after integrity error."
                        )

    @classmethod
    async def get_registered_devices(cls) -> list[Device]:
        async with new_session() as session:
            query = select(DeviceEntity)
            result = await session.execute(query)
            devices = result.scalars().all()
            return [db_device.to_model() for db_device in devices]

    @classmethod
    async def get_device_tokens(cls) -> list[str]:
        async with new_session() as session:
            query = select(DeviceEntity.token)
            result = await session.execute(query)
            tokens = result.scalars().all()
            return tokens

    @classmethod
    async def delete_device_by_token(cls, token: str) -> bool:
        async with new_session() as session:
            query = delete(DeviceEntity).where(DeviceEntity.token == token)
            result = await session.execute(query)
            await session.commit()
            return result.rowcount > 0

    @classmethod
    async def clear_registered_devices(cls) -> int:
        """
        Удаляет все устройства и возвращает количество удаленных записей.
        """
        async with new_session() as session:
            query = delete(DeviceEntity)
            result = await session.execute(query)
            await session.commit()
            return result.rowcount
