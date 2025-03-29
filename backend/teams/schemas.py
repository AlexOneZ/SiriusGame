from typing import Union
from pydantic import BaseModel

class STeamAdd(BaseModel):
    name: str

class STeam(STeamAdd):
    id: int
    
class STeamId(BaseModel):
    ok: bool = True
    team_id: int

class STeamEvent(BaseModel):
    id: int
    team_id: int
    event_id: int
    order: int
    state: str
    score: int