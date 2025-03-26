from database import new_session, EventOrm
from schemas import SEventAdd, SEvent
from sqlalchemy import select

class EventRepository:
    def __init__(self):
        pass

    @classmethod
    async def add_one(cls, data: SEventAdd) -> int:
        async with new_session() as session:
            event_dict = data.model_dump()
        
            event = EventOrm(**event_dict)
            session.add(event)
            await session.flush()
            await session.commit()

            return event.id

    @classmethod
    async def get_all(cls) -> list[SEvent]:
        async with new_session() as session:
            query = select(EventOrm)
            result = await session.execute(query)
            event_models = result.scalars().all()
            event_schemas = [SEvent.model_validate(event_model.__dict__) for event_model in event_models]
            
            return event_schemas