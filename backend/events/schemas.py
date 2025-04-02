from pydantic import BaseModel

class SEventAdd(BaseModel):
    name: str
    description: str | None = None

class SEvent(SEventAdd):
    id: int

class SEventId(BaseModel):
    ok: bool = True
    event_id: int