from typing import Optional, Union
from pydantic import BaseModel

class STeamAdd(BaseModel):
    name: str

class STeam(STeamAdd):
    id: int
    
class STeamIdSuccess(BaseModel):
    ok: bool = True
    team_id: int

class STeamIdError(BaseModel):
    ok: bool = False
    error: str

STeamId = Union[STeamIdSuccess, STeamIdError]