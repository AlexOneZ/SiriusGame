from sqlalchemy import select, delete, func
from typing import List

from database import new_session, EventOrm, TeamOrm, TeamEventOrm
from events.schemas import SEventAdd, SEvent

class EventRepository:
    @classmethod
    async def get_all(cls) -> List[SEvent]:
        async with new_session() as session:
            result = await session.execute(select(EventOrm))
            event_models = result.scalars().all()
            return [SEvent.model_validate(event_model.__dict__) for event_model in event_models]

    @classmethod
    async def add_one(cls, data: SEventAdd) -> int:
        async with new_session() as session:
            teams_result = await session.execute(select(TeamOrm))
            teams = teams_result.scalars().all()
            if len(teams) > 0:
                raise RuntimeError("Cannot edit events: there are teams")

            event = EventOrm(**data.model_dump())
            session.add(event)
            
            await session.commit()
            return event.id

    @classmethod
    async def delete(cls, event_id: int) -> bool:
        async with new_session() as session:
            teams_result = await session.execute(select(TeamOrm))
            teams = teams_result.scalars().all()
            if len(teams) > 0:
                raise RuntimeError("Cannot edit events: there are teams")
                
            result = await session.execute(select(EventOrm).where(EventOrm.id == event_id))
            event_model = result.scalars().first()
            if not event_model:
                return False
            
            query = delete(EventOrm).where(EventOrm.id == event_id)
            await session.execute(query)
            await session.commit()
            return True