from sqlalchemy import select

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
    
    @staticmethod
    async def if_exists(name: str) -> bool:
        async with new_session() as session:
            query = select(TeamOrm).where(TeamOrm.name == name)
            result = await session.execute(query)
            return result.scalar_one_or_none() is not None

    @classmethod
    async def add_one(cls, data: STeamAdd) -> int:
        async with new_session() as session:
            if await cls.if_exists(data.name):
                raise Exception("Team already exists")
        
            new_team = TeamOrm(**data.model_dump())
            session.add(new_team)
            await session.flush()
            await session.commit()

            return new_team.id
