from sqlalchemy import select, update, delete
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
    async def get_by_id(cls, team_id: int) -> Optional[STeam]:
        async with new_session() as session:
            query = select(TeamOrm).where(TeamOrm.id == team_id)
            result = await session.execute(query)
            team_model = result.scalars().first()
            return STeam.model_validate(team_model.__dict__) if team_model else None
    
    @classmethod
    async def add_one(cls, data: STeamAdd) -> int:
        async with new_session() as session:
            new_team = TeamOrm(**data.model_dump())
            session.add(new_team)
            await session.flush()
            await session.commit()
            return new_team.id

    @classmethod
    async def update(cls, name: str, new_name: str) -> Optional[STeam]:
        team_id = await cls.get_id_by_name(name)
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return None

        async with new_session() as session:
            query = update(TeamOrm).where(TeamOrm.id == team_id).values(name=new_name)
            team_model.name = new_name
            await session.execute(query)
            await session.flush()
            await session.commit()
            return STeam.model_validate(team_model.__dict__)

    @classmethod
    async def delete(cls, name: str) -> bool:
        team_id = await cls.get_id_by_name(name)
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return False

        async with new_session() as session:
            query = delete(TeamOrm).where(TeamOrm.id == team_id)
            await session.execute(query)
            await session.commit()
            return True
