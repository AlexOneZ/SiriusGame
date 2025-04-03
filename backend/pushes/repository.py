from typing import List, Dict, Optional

from sqlalchemy import select, delete, insert
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from database import new_session, DeviceEntity, NotificationHistoryOrm
from .schemas import Device, NotificationHistory


class DeviceRepository:
    @classmethod
    async def register_device(cls, device: Device) -> Device:
        """
        Регистрирует устройство в базе данных по токену устройства.
        """
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
    async def get_registered_devices(cls) -> List[Device]:
        """
        Выдает список всех зарегистрированных устройств из базы данных.
        """
        async with new_session() as session:
            query = select(DeviceEntity)
            result = await session.execute(query)
            devices = result.scalars().all()
            return [db_device.to_model() for db_device in devices]

    @classmethod
    async def get_device_tokens(cls) -> List[str]:
        """
        Выдает список токенов зарегистрированных устройств.
        """
        async with new_session() as session:
            query = select(DeviceEntity.token)
            result = await session.execute(query)
            tokens = result.scalars().all()
            return list(tokens)

    @classmethod
    async def delete_device_by_token(cls, token: str) -> bool:
        """
        Удаляет зарегистрированное устройство по токену.
        """
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
            device_ids_query = select(DeviceEntity.id)
            device_ids_result = await session.execute(device_ids_query)
            device_ids = device_ids_result.scalars().all()
            if device_ids:
                delete_history_query = delete(NotificationHistoryOrm).where(
                    NotificationHistoryOrm.device_id.in_(device_ids))
                await session.execute(delete_history_query)
            query = delete(DeviceEntity)
            result = await session.execute(query)
            await session.commit()
            return result.rowcount

    @classmethod
    async def get_device_id_map_by_tokens(cls, tokens: List[str]) -> Dict[str, int]:
        """Возвращает словарь {token: device_id} для существующих токенов."""
        if not tokens:
            return {}
        async with new_session() as session:
            query = select(DeviceEntity.token, DeviceEntity.id).where(DeviceEntity.token.in_(tokens))
            result = await session.execute(query)
            # Преобразуем результат (список кортежей) в словарь
            token_id_map = {token: id for token, id in result.all()}
            return token_id_map

    @classmethod
    async def add_notification_history_batch(cls, history_entries: List[Dict]):
        """Пакетно добавляет записи в историю уведомлений."""
        if not history_entries:
            return
        async with new_session() as session:
            # Используем insert для эффективности, если не нужны ORM объекты после вставки
            stmt = insert(NotificationHistoryOrm).values(history_entries)
            await session.execute(stmt)
            await session.commit()
            # Для ORM подхода (менее эффективно для большого батча):
            # history_orms = [NotificationHistoryOrm(**entry) for entry in history_entries]
            # session.add_all(history_orms)
            # await session.commit()

    @classmethod
    async def get_history_for_device(cls, device_id: int, limit: int = 100, offset: int = 0) -> List[
        NotificationHistory]:
        """Получает историю уведомлений для устройства с пагинацией."""
        async with new_session() as session:
            query = (
                select(NotificationHistoryOrm)
                .where(NotificationHistoryOrm.device_id == device_id)
                .order_by(NotificationHistoryOrm.sent_at.desc())  # Новые сверху
                .limit(limit)
                .offset(offset)
            )
            result = await session.execute(query)
            history_orms = result.scalars().all()
            return [history.to_model() for history in history_orms]

    @classmethod
    async def get_history_by_id(cls, history_id: int) -> Optional[NotificationHistory]:
        """Получает одну запись истории по её ID."""
        async with new_session() as session:
            query = select(NotificationHistoryOrm).where(NotificationHistoryOrm.id == history_id)
            result = await session.execute(query)
            history_orm = result.scalars().first()
            return history_orm.to_model() if history_orm else None

    @classmethod
    async def delete_notification_history(cls, history_id: int) -> bool:
        """Удаляет запись из истории по её ID."""
        async with new_session() as session:
            query = delete(NotificationHistoryOrm).where(NotificationHistoryOrm.id == history_id)
            result = await session.execute(query)
            await session.commit()
            return result.rowcount > 0

    @classmethod
    async def get_device_by_token(cls, token: str) -> Optional[Device]:
        """Получает информацию об устройстве по его токену."""
        async with new_session() as session:
            query = select(DeviceEntity).where(DeviceEntity.token == token)
            result = await session.execute(query)
            device_orm = result.scalars().first()
            return device_orm.to_model() if device_orm else None
