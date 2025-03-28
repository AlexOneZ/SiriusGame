from sqlalchemy import select
from typing import Optional

from database import new_session, TeamOrm
from teams.schemas import STeam, STeamAdd

class TeamRepository:
    @classmethod
    async def get_all(cls) -> list[STeam]:
        async with new_session() as session:
            query = select(TeamOrm)
            result = await session.execute(query)
            team_models = result.scalars().all()
            team_schemas = [STeam.model_validate(team_model.__dict__) for team_model in team_models]
            
            return team_schemas
    
    @classmethod
    async def get_id_by_name(cls, name: str) -> Optional[int]:
        async with new_session() as session:
            query = select(TeamOrm).where(TeamOrm.name == name)
            result = await session.execute(query)
            team_model = result.scalars().first()
            if team_model is None:
                return None
                
            team_schema = STeam.model_validate(team_model.__dict__)

            return team_schema.id

    @classmethod
    async def add_one(cls, data: STeamAdd) -> int:
        async with new_session() as session:
            new_team = TeamOrm(**data.model_dump())
            session.add(new_team)
            await session.flush()
            await session.commit()

            return new_team.id
