from fastapi import APIRouter, Depends, HTTPException
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

@router.delete("/{event_id}")
async def delete_event(event_id: int):
    success = await EventRepository.delete(event_id)
    if not success:
        raise HTTPException(status_code=404, detail="Event not found")
    return {"ok": True}