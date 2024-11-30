from pydantic import BaseModel
from typing import List

# Request Models
class UserRequest(BaseModel):
    usernames: List[str]

# Response Models
class TweetResponse(BaseModel):
    tweet_id: str
    name: str
    handle: str
    timestamp: str
    verified: int
    content: str
    comments: str
    retweets: str
    likes: str
    analytics: str
    tags: str
    mentions: str
    emojis: str
    profile_image: str
    tweet_link: str
