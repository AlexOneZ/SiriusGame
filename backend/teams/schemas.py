from typing import Union
from pydantic import BaseModel

class STeamAdd(BaseModel):
    name: str

class STeam(STeamAdd):
    id: int
    
class STeamId(BaseModel):
    ok: bool = True
    team_id: int
