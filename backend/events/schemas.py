from pydantic import BaseModel, validator

class SEventAdd(BaseModel):
    name: str
    description: str | None = None
    latidude: float
    longitude: float
    location: str

class SEvent(SEventAdd):
    id: int

class SEventId(BaseModel):
    ok: bool = True
    event_id: int