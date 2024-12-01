# SQL Queries for modularity

# User-related queries
CREATE_USER_QUERY = "INSERT INTO users (username) VALUES (?)"
READ_USERS_QUERY = "SELECT * FROM users"

# Tweet-related queries
INSERT_TWEET_QUERY = """
INSERT INTO tweets (
    tweet_id, name, handle, timestamp, verified, content, comments, retweets, likes,
    analytics, tags, mentions, emojis, profile_image, tweet_link
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""

READ_TWEETS_QUERY = """
SELECT * FROM tweets WHERE handle = ? ORDER BY timestamp DESC LIMIT ?
"""

GET_PROFILE_IMAGE = """
SELECT profile_image FROM tweets WHERE handle = ? ORDER BY timestamp DESC LIMIT 1
"""