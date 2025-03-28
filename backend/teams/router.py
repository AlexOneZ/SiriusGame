from fastapi import APIRouter, Depends, HTTPException
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

@router.get("/{team_id}")
async def get_team_by_id(team_id: int) -> STeam:
    team = await TeamRepository.get_by_id(team_id)
    if team is None:
        raise HTTPException(status_code=404, detail="Team not found")
    return team

@router.put("/{team_name}")
async def update_team_name(name: str, new_name: str) -> STeam:
    updated_team = await TeamRepository.update(name, new_name)
    if updated_team is None:
        raise HTTPException(status_code=404, detail="Team not found")
    return updated_team

@router.delete("/{team_name}")
async def delete_team(team_name: str):
    success = await TeamRepository.delete(team_name)
    if not success:
        raise HTTPException(status_code=404, detail="Team not found")
    return {"ok": True}