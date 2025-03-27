from fastapi import APIRouter, Depends
from typing import Annotated

from teams.repository import TeamRepository
from teams.schemas import STeam, STeamAdd, STeamId

router = APIRouter(prefix="/teams", tags=["teams"])

@router.get("")
async def get_teams() -> list[STeam]:
    events = await TeamRepository.get_all()
    return events

@router.post("")
async def add_team(team: Annotated[STeamAdd, Depends()]) -> STeamId:
    try:
        team_id = await TeamRepository.add_one(team)
        return {"ok": True, "team_id": team_id}
    except Exception as e:
        return {"ok": False, "error": str(e)}
