from fastapi import APIRouter, Depends, HTTPException
from typing import Annotated

from teams.repository import TeamRepository
from teams.schemas import STeam, STeamAdd, STeamId, STeamEvent

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

@router.put("/{team_id}")
async def update_team_name(team_id: int, new_name: str) -> STeam:
    updated_team = await TeamRepository.update(team_id, new_name)
    if updated_team is None:
        raise HTTPException(status_code=404, detail="Team not found")
    return updated_team

@router.delete("/{team_id}")
async def delete_team(team_id: int):
    success = await TeamRepository.delete(team_id)
    if not success:
        raise HTTPException(status_code=404, detail="Team not found")
    return {"ok": True}

@router.get("/{team_id}/events")
async def get_team_events(team_id: int) -> list[STeamEvent]:
    events = await TeamRepository.get_team_events(team_id)
    if events is None:
        raise HTTPException(status_code=404, detail="Team not found")
    return events

@router.put("/{team_id}/events")
async def set_team_event_score(team_id: int, score: int):
    try:
        success = await TeamRepository.set_team_event_score(team_id, score)
    except RuntimeError as e:
        if str(e) == "No row updated":
            raise HTTPException(status_code=409, detail="Current event does not exist")
        raise
    if not success:
        raise HTTPException(status_code=404, detail="Team not found")
    return {"ok": True}