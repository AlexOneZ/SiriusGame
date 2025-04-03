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
            await session.flush()
            team_id = new_team.id

            result = await session.execute(select(EventOrm).order_by(EventOrm.id))
            events = result.scalars().all()
            total_events = len(events)
            
            if total_events > 0:
                # Calculate the order for each event based on the team_id
                # Pattern: team_id, team_id + 1, ..., n, 1, 2, ..., team_id - 1
                
                for i, event in enumerate(events):
                    order_index = (team_id - 1 + i) % total_events
                    
                    team_event = TeamEventOrm(
                        team_id=team_id,
                        event_id=event.id,
                        order=order_index + 1,
                        state="now" if order_index == 0 else "next",
                        score=0
                    )
                    session.add(team_event)

            await session.commit()
            return team_id

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
            return True if result.scalar_one_or_none() else False

    @classmethod
    async def delete_all(cls) -> bool:
        async with new_session() as session:
            await session.execute(delete(TeamEventOrm))
            await session.execute(delete(TeamOrm))
            await session.commit()
            return True 

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
                    description=event_orm.description,
                    latidude=event_orm.latidude,
                    longitude=event_orm.longitude,
                    location=event_orm.location
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

            await session.execute(
                update(TeamOrm)
                .where(TeamOrm.id == team_id)
                .values(score=TeamOrm.score + score)
            )

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