from sqlalchemy import select, update, delete
from typing import Optional

from database import new_session, TeamOrm, TeamEventOrm, EventOrm
from teams.schemas import STeam, STeamAdd, STeamEvent

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
    async def update(cls, team_id: int, new_name: str) -> Optional[STeam]:
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
    async def delete(cls, team_id: int) -> bool:
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return False

        async with new_session() as session:
            query = delete(TeamOrm).where(TeamOrm.id == team_id)
            await session.execute(query)
            await session.commit()
            return True

    @classmethod
    async def get_team_events(cls, team_id: int) -> Optional[list[STeamEvent]]:
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return None

        async with new_session() as session:
            query = (
                select(TeamEventOrm, EventOrm)
                .join(EventOrm, TeamEventOrm.event_id == EventOrm.id)
                .where(TeamEventOrm.team_id == team_id)
                .order_by(TeamEventOrm.order)
            )
            result = await session.execute(query)
            team_events = [
                STeamEvent(
                    id=team_event_orm.id,
                    team_id=team_event_orm.team_id,
                    event_id=team_event_orm.event_id,
                    order=team_event_orm.order,
                    state=team_event_orm.state,
                    score=team_event_orm.score,
                    name=event_orm.name,
                    description=event_orm.description
                )
                for team_event_orm, event_orm in result
            ]
            return team_events

    @classmethod
    async def set_team_event_score(cls, team_id: int, score: int):
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return None

        async with new_session() as session:
            query = (
                update(TeamEventOrm)
                .where(TeamEventOrm.team_id == team_id, TeamEventOrm.state == "now")
                .values(score=score, state="done")
            )
            result = await session.execute(query)
            if not result.rowcount:
                raise RuntimeError("No row updated")
            await session.flush()
            await session.commit()

            subquery = (
                select(TeamEventOrm.id)
                .where(TeamEventOrm.team_id == team_id, TeamEventOrm.state == "next")
                .order_by(TeamEventOrm.order)
                .limit(1)
                .scalar_subquery()
            )
            query = (
                update(TeamEventOrm)
                .where(TeamEventOrm.id == subquery)
                .values(state="now")
            )
            await session.execute(query)
            await session.flush()
            await session.commit()
            
            return True