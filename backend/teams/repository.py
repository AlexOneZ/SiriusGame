from sqlalchemy import select, update, delete
from sqlalchemy.exc import NoResultFound
from typing import Optional, List

from database import new_session, TeamOrm, TeamEventOrm, EventOrm
from teams.schemas import STeam, STeamAdd, STeamEvent

class TeamRepository:
    @classmethod
    async def get_all(cls) -> List[STeam]:
        async with new_session() as session:
            result = await session.execute(select(TeamOrm))
            team_models = result.scalars().all()
            return [STeam.model_validate(team_model.__dict__) for team_model in team_models]
    
    @classmethod
    async def get_by_name(cls, name: str) -> Optional[STeam]:
        async with new_session() as session:
            result = await session.execute(select(TeamOrm).where(TeamOrm.name == name))
            team_model = result.scalar_one_or_none()
            return STeam.model_validate(team_model.__dict__) if team_model else None

    @classmethod
    async def get_by_id(cls, team_id: int) -> Optional[STeam]:
        async with new_session() as session:
            result = await session.execute(select(TeamOrm).where(TeamOrm.id == team_id))
            team_model = result.scalar_one_or_none()
            return STeam.model_validate(team_model.__dict__) if team_model else None
    
    @classmethod
    async def add_one(cls, data: STeamAdd) -> int:
        async with new_session() as session:
            new_team = TeamOrm(**data.model_dump())
            session.add(new_team)
            await session.commit()
            return new_team.id

    @classmethod
    async def update(cls, team_id: int, new_name: str) -> Optional[STeam]:
        async with new_session() as session:
            result = await session.execute(
                update(TeamOrm)
                .where(TeamOrm.id == team_id)
                .values(name=new_name)
                .returning(TeamOrm)
            )
            await session.commit()
            team_model = result.scalar_one_or_none()
            return STeam.model_validate(team_model.__dict__) if team_model else None

    @classmethod
    async def delete(cls, team_id: int) -> bool:
        async with new_session() as session:
            await session.execute(delete(TeamEventOrm).where(TeamEventOrm.team_id == team_id))

            result = await session.execute(delete(TeamOrm).where(TeamOrm.id == team_id).returning(TeamOrm))
            
            await session.commit()
            return True if result.rowcount else False

    @classmethod
    async def get_team_events(cls, team_id: int) -> Optional[List[STeamEvent]]:
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return None

        async with new_session() as session:
            result = await session.execute(
                select(TeamEventOrm, EventOrm)
                .join(EventOrm, TeamEventOrm.event_id == EventOrm.id)
                .where(TeamEventOrm.team_id == team_id)
                .order_by(TeamEventOrm.order)
            )

            return [
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

    @classmethod
    async def set_team_event_score(cls, team_id: int, score: int):
        team_model = await cls.get_by_id(team_id)
        if not team_model:
            return False

        async with new_session() as session:
            result = await session.execute(
                update(TeamEventOrm)
                .where(TeamEventOrm.team_id == team_id, TeamEventOrm.state == "now")
                .values(score=score, state="done")
            )
            if not result.rowcount:
                raise NoResultFound("No current event")

            new_event_query = (
                select(TeamEventOrm.id)
                .where(TeamEventOrm.team_id == team_id, TeamEventOrm.state == "next")
                .order_by(TeamEventOrm.order)
                .limit(1)
                .scalar_subquery()
            )
            await session.execute(
                update(TeamEventOrm)
                .where(TeamEventOrm.id == new_event_query)
                .values(state="now")
            )

            await session.commit()
            return True