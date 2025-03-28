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
async def enter_or_create_team(team: Annotated[STeamAdd, Depends()]) -> STeamId:
    team_id = await TeamRepository.get_id_by_name(team.name)
    if team_id is None:
        team_id = await TeamRepository.add_one(team)
    return {"ok": True, "team_id": team_id}
