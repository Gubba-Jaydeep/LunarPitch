import sys
sys.path.append('/Users/jaydeepgubba/Documents/Projects/PythonProjects/RocketiumHackathon/LunarPitch/')
from fastapi import APIRouter, Query, HTTPException
from typing import List, Optional
from database.manager import DatabaseManager
from database.models import TweetResponse
from database.queries import READ_TWEETS_QUERY

router = APIRouter()
db_manager = DatabaseManager()

@router.get("/get_tweets/", response_model=List[TweetResponse])
async def get_tweets(
    count: int = Query(10, ge=1),
    handles: Optional[List[str]] = Query(None)
):
    """Fetch tweets for specific handles and count."""
    if not handles:
        handles = db_manager.read_users()
        if not handles:
            raise HTTPException(status_code=404, detail="No users found in the database.")
        # handles = [handle[0] for handle in handles]

    result = []
    for handle in handles:
        tweets = db_manager.execute_query(READ_TWEETS_QUERY, (handle, count), fetch_all=True)
        result.extend(tweets)

    if not result:
        raise HTTPException(status_code=404, detail="No tweets found for the given handles.")

    return [
        TweetResponse(
            tweet_id=row[0],
            name=row[1],
            handle=row[2],
            timestamp=row[3],
            verified=row[4],
            content=row[5],
            comments=row[6],
            retweets=row[7],
            likes=row[8],
            analytics=row[9],
            tags=row[10],
            mentions=row[11],
            emojis=row[12],
            profile_image=row[13],
            tweet_link=row[14],
        )
        for row in result
    ]
