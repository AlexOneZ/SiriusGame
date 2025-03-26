from fastapi import FastAPI
from contextlib import asynccontextmanager

from database import create_tables, delete_tables

from events.router import router as events_router
from teams.router import router as teams_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    await delete_tables()
    print("Tables deleted")
    await create_tables()
    print("Tables created")
    yield

app = FastAPI(lifespan=lifespan)

app.include_router(events_router)
app.include_router(teams_router)