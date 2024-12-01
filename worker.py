import threading
from datetime import datetime

import schedule
import time
import os

from dotenv import load_dotenv

from database.manager import *
import glob
from database.manager import DatabaseManager
from services.text_generation import generate_text_reply
from services.image_generation import generate_meme_reply
# from services.gif_generation import generate_gif_reply

from scraper.twitter_scraper import Twitter_Scraper
import pandas as pd

load_dotenv()




def scrape_tweets():
    print('starting scrape_tweets')
    global scraper
    database_manager = DatabaseManager()
    users_to_scrape = database_manager.read_users()
    print('getting tweets for users:', users_to_scrape)
    df = pd.DataFrame()
    for user in users_to_scrape:
        try:
            scraper.scrape_tweets(
                max_tweets=5,
                no_tweets_limit=False,
                scrape_username=user,
                scrape_hashtag=None,
                scrape_query=None,
                scrape_latest=False,
                scrape_top=False,
                scrape_poster_details=False,
            )
        except Exception as e:
            print('Will attempt relogin')
            scraper = Twitter_Scraper(
                mail=None,
                username=os.getenv("TWITTER_USERNAME"),
                password=os.getenv("TWITTER_PASSWORD"),
            )
            scraper.login()
        df = df._append(scraper.get_data_as_dataframe())
    cur = datetime.now().timestamp()
    df.to_csv(f'./tweets/data_{cur}.csv', index=False, encoding="utf-8")
    db_manager = DatabaseManager()
    cleaned_df = db_manager.clean_data(df)
    db_manager.insert_tweets(cleaned_df)
    # os.system(f'python3 scraper --tweets=50 --username={users_to_scrape}')


def process_scheduled_posts():
    print('starting process_scheduled_posts')
    db_manager = DatabaseManager()
    try:
        # Get the current time
        current_time = datetime.now().isoformat()

        # Fetch posts that are due
        due_posts = db_manager.get_due_posts(current_time)
        for post_id, tweet_id, content_to_post in due_posts:
            try:
                # Post the tweet
                post_tweet(content_to_post)
                print(f"Tweet posted for tweet_id: {tweet_id}")

                # Delete the entry from the database
                db_manager.delete_post(post_id)
            except Exception as e:
                print(f"Error posting tweet for tweet_id {tweet_id}: {e}")

        # Sleep for a short duration before checking again
        time.sleep(10)  # Adjust as needed
    except Exception as e:
        print(f"Error processing scheduled posts: {e}")
def post_tweet(tweet_id: str, tweet_content: str):
    global scraper
    try:
        scraper.post_tweet(tweet_id, tweet_content)
    except Exception as e:
        print('Will attempt relogin')
        # global scraper
        scraper = Twitter_Scraper(
            mail=None,
            username=os.getenv("TWITTER_USERNAME"),
            password=os.getenv("TWITTER_PASSWORD"),
        )
        scraper.login()
    return "Success"


def precompute_replies():
    print('starting precompute_replies')
    # Fetch all tweet IDs without cached replies
    query = """
    SELECT t.tweet_id, t.content, t.name, t.handle
    FROM tweets t
    LEFT JOIN cached_replies c ON t.tweet_id = c.tweet_id
    WHERE c.tweet_id IS NULL
    """
    db_manager = DatabaseManager()
    tweets = db_manager.execute_query(query, fetch_all=True)

    for tweet_id, content, name, handle in tweets:
        try:
            # Generate replies
            text_reply = generate_text_reply(content)
            meme_reply_url = generate_meme_reply(content, name, handle)
            gif_reply_path = ""

            # Cache replies
            if text_reply:
                db_manager.cache_reply(tweet_id, text_reply, meme_reply_url, gif_reply_path)
            print(f"Replies cached for tweet_id {tweet_id}")
        except Exception as e:
            print(f"Error processing tweet_id {tweet_id}: {e}")


def run_in_thread(task, *args, **kwargs):
    thread = threading.Thread(target=task, args=args, kwargs=kwargs)
    thread.start()


scraper = Twitter_Scraper(
        mail=None,
        username=os.getenv("TWITTER_USERNAME"),
        password=os.getenv("TWITTER_PASSWORD"),
    )

scraper.login()


schedule.every(2).minutes.do(run_in_thread, scrape_tweets)
schedule.every(5).seconds.do(run_in_thread, process_scheduled_posts)
schedule.every(2).minutes.do(run_in_thread, precompute_replies)


while True:
    schedule.run_pending()
    time.sleep(1)

# precompute_replies()



