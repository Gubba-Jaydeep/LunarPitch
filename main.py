from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes.users import router as user_router
from routes.tweets import router as tweet_router

# import boto3
app = FastAPI()
origins = [
    '*',
    "http://localhost:3000",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Register routers
app.include_router(user_router, prefix="/users", tags=["Users"])
app.include_router(tweet_router, prefix="/tweets", tags=["Tweets"])

@app.get("/")
async def root():
    return {"message": "Welcome to the Tweet API!"}