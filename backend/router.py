from fastapi import APIRouter, Depends
from schemas import SEventAdd, SEvent, SEventId
from repository import EventRepository
from typing import Annotated

router = APIRouter(prefix="/events", tags=["events"])

@router.post("")
async def add_event(event: Annotated[SEventAdd, Depends()]) -> SEventId:
    event_id = await EventRepository.add_one(event)
    return {"ok": True, "event_id": event_id}

@router.get("")
async def get_events() -> list[SEvent]:
    events = await EventRepository.get_all()
    return events