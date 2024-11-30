import sys, os

from dotenv import load_dotenv

sys.path.append('/Users/jaydeepgubba/Documents/Projects/PythonProjects/RocketiumHackathon/LunarPitch/')
from fastapi import APIRouter, Query, HTTPException
from typing import List, Optional
from database.manager import DatabaseManager
from database.models import TweetResponse
from database.queries import READ_TWEETS_QUERY

from services.text_generation import generate_text_reply
from services.image_generation import generate_meme_reply
# from services.gif_generation import generate_gif_reply
from scraper.twitter_scraper import Twitter_Scraper

load_dotenv()
router = APIRouter()
db_manager = DatabaseManager()

scraper = Twitter_Scraper(
        mail=None,
        username=os.getenv("TWITTER_USERNAME"),
        password=os.getenv("TWITTER_PASSWORD"),
    )
scraper.login()


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


@router.get("/generate_replies/{tweet_id}")
async def generate_replies(tweet_id: str):
    """Fetch precomputed replies from the cache or compute and cache them."""
    # Check if the reply is cached
    cached_reply = db_manager.get_cached_reply(tweet_id)
    if cached_reply:
        return {
            "text_reply": cached_reply[0],
            "meme_reply_url": cached_reply[1],
            "gif_reply_path": cached_reply[2]
        }

    # Fetch the tweet content
    tweet = db_manager.execute_query(
        "SELECT content, name, handle FROM tweets WHERE tweet_id = ?",
        (tweet_id,),
        fetch_one=True
    )
    if not tweet:
        raise HTTPException(status_code=404, detail="Tweet not found.")

    tweet_content, tweeter_name, tweeter_handle = tweet

    # Compute the replies
    text_reply = generate_text_reply(tweet_content)
    meme_reply_url = generate_meme_reply(tweet_content, tweeter_name, tweeter_handle)
    # gif_reply_path = generate_gif_reply(tweet_content)
    gif_reply_path = "generate_gif_reply(tweet_content)"

    # Cache the replies
    db_manager.cache_reply(tweet_id, text_reply, meme_reply_url, gif_reply_path)

    return {
        "text_reply": text_reply,
        "meme_reply_url": meme_reply_url,
        "gif_reply_path": gif_reply_path
    }


@router.post("/post_tweet")
async def generate_replies(tweet_id: str, tweet_content: str):
    scraper.post_tweet(tweet_id, tweet_content)
    return "Success"
