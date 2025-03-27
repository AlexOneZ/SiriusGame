from sqlalchemy import select

from database import new_session, EventOrm
from events.schemas import SEventAdd, SEvent

class EventRepository:
    @classmethod
    async def get_all(cls) -> list[SEvent]:
        async with new_session() as session:
            query = select(EventOrm)
            result = await session.execute(query)
            event_models = result.scalars().all()
            event_schemas = [SEvent.model_validate(event_model.__dict__) for event_model in event_models]
            
            return event_schemas

    @classmethod
    async def add_one(cls, data: SEventAdd) -> int:
        async with new_session() as session:
            event = EventOrm(**data.model_dump())
            session.add(event)
            await session.flush()
            await session.commit()

            return event.id