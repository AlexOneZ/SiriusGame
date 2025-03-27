from fastapi import APIRouter, Depends
from typing import Annotated

from events.repository import EventRepository
from events.schemas import SEventAdd, SEvent, SEventId

router = APIRouter(prefix="/events", tags=["events"])

@router.get("")
async def get_events() -> list[SEvent]:
    events = await EventRepository.get_all()
    return events
    
@router.post("")
async def add_event(event: Annotated[SEventAdd, Depends()]) -> SEventId:
    event_id = await EventRepository.add_one(event)
    return {"ok": True, "event_id": event_id}
