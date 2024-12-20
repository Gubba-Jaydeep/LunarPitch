from pydantic import BaseModel
from typing import List

# Request Models
class UserRequest(BaseModel):
    usernames: List[str]

class PostTweetRequest(BaseModel):
    tweet_id: str
    tweet_content: str

class ScheduledPostTweetRequest(BaseModel):
    tweet_id: str
    tweet_content: str
    time_to_post: str

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
