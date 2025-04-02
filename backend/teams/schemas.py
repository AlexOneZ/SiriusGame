from pydantic import BaseModel

class STeamAdd(BaseModel):
    name: str

class STeam(STeamAdd):
    id: int
    score: int = 0
    
class STeamId(BaseModel):
    ok: bool = True
    team_id: int

class STeamEvent(BaseModel):
    id: int
    team_id: int
    event_id: int
    name: str
    description: str | None
    order: int
    state: str
    score: int