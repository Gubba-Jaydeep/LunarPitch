import sqlite3

name = 'DatabaseManager'

class DatabaseManager:
    def __init__(self, db_path="data.db"):
        self.db_path = db_path
        self._initialize_tables()

    def _connect(self):
        return sqlite3.connect(self.db_path)

    def _initialize_tables(self):
        """Create `users` and `tweets` tables if they don't exist."""
        conn = self._connect()
        cursor = conn.cursor()

        # Users table
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL
        )
        """)

        # Tweets table
        cursor.execute("""
                CREATE TABLE IF NOT EXISTS tweets (
                    tweet_id TEXT PRIMARY KEY,
                    name TEXT,
                    handle TEXT,
                    timestamp TEXT,
                    verified INTEGER,
                    content TEXT,
                    comments TEXT,
                    retweets TEXT,
                    likes TEXT,
                    analytics TEXT,
                    tags TEXT,
                    mentions TEXT,
                    emojis TEXT,
                    profile_image TEXT,
                    tweet_link TEXT
                )
                """)

        conn.commit()
        conn.close()

    # CRUD Operations for Users
    # def create_user(self, username, full_name=None):
    #     conn = self._connect()
    #     cursor = conn.cursor()
    #     try:
    #         cursor.execute("INSERT INTO users (username) VALUES (?)", [username])
    #         conn.commit()
    #         print(f"User '{username}' created successfully.")
    #     except sqlite3.IntegrityError:
    #         print(f"User '{username}' already exists.")
    #     finally:
    #         conn.close()

    def read_users(self):
        conn = self._connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
        conn.close()
        return list(map(lambda a: a[1], users))

    # def delete_user(self, user_name):
    #     conn = self._connect()
    #     cursor = conn.cursor()
    #     cursor.execute("DELETE FROM users WHERE username = ?", (user_name,))
    #     conn.commit()
    #     conn.close()
    #     print(f"User with ID {user_name} deleted successfully.")

    # CRUD Operations for Tweets
    def clean_data(self, df):
        """Cleans the data in the pandas DataFrame before insertion."""
        # Convert boolean 'Verified' to 1 (True) or 0 (False)
        df["Verified"] = df["Verified"].astype(int)

        # Normalize numerical columns (e.g., likes, comments, retweets) to integers
        df["Likes"] = df["Likes"].apply(lambda x: str(x))
        df["Comments"] = df["Comments"].apply(lambda x: str(x))
        df["Retweets"] = df["Retweets"].apply(lambda x: str(x))

        # Ensure tweet_id is clean
        df["Tweet ID"] = df["Tweet ID"].apply(lambda a: str(a).replace("tweet_id:", "").strip())

        # Convert lists in Tags, Mentions, and Emojis columns to JSON-like strings
        df["Tags"] = df["Tags"].apply(lambda x: str(x))
        df["Mentions"] = df["Mentions"].apply(lambda x: str(x))
        df["Emojis"] = df["Emojis"].apply(lambda x: str(x))

        return df

    def insert_tweets(self, df):
        """Inserts tweets into the database, skipping duplicates."""
        conn = self._connect()
        cursor = conn.cursor()

        for _, row in df.iterrows():
            try:
                cursor.execute("""
                INSERT INTO tweets (
                    tweet_id, name, handle, timestamp, verified, content, comments, retweets, likes,
                    analytics, tags, mentions, emojis, profile_image, tweet_link
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    row["Tweet ID"], row["Name"], row["Handle"], row["Timestamp"], row["Verified"],
                    row["Content"], row["Comments"], row["Retweets"], row["Likes"], row["Analytics"],
                    row["Tags"], row["Mentions"], row["Emojis"], row["Profile Image"], row["Tweet Link"]
                ))
            except sqlite3.IntegrityError:
                print(f"Tweet with ID {row['Tweet ID']} already exists. Skipping.")
        conn.commit()
        conn.close()

    # def read_tweets(self):
    #     """Fetches all tweets from the database."""
    #     conn = self._connect()
    #     cursor = conn.cursor()
    #     cursor.execute("SELECT * FROM tweets")
    #     tweets = cursor.fetchall()
    #     conn.close()
    #     return tweets

    # def delete_tweet(self, tweet_id):
    #     """Deletes a tweet from the database using the tweet_id."""
    #     conn = self._connect()
    #     cursor = conn.cursor()
    #     cursor.execute("DELETE FROM tweets WHERE tweet_id = ?", (tweet_id,))
    #     conn.commit()
    #     conn.close()
    #     print(f"Tweet with ID {tweet_id} deleted successfully.")

    # def update_tweet(self, tweet_id, **kwargs):
    #     """Updates specific fields of a tweet."""
    #     conn = self._connect()
    #     cursor = conn.cursor()
    #
    #     updates = ", ".join(f"{key} = ?" for key in kwargs.keys())
    #     values = list(kwargs.values())
    #     values.append(tweet_id)
    #
    #     cursor.execute(f"UPDATE tweets SET {updates} WHERE tweet_id = ?", values)
    #     conn.commit()
    #     conn.close()
    #     print(f"Tweet with ID {tweet_id} updated successfully.")

    def execute_query(self, query, params=(), fetch_one=False, fetch_all=False):
        """Generalized query executor."""
        conn = self._connect()
        cursor = conn.cursor()
        result = None
        try:
            cursor.execute(query, params)
            if fetch_one:
                result = cursor.fetchone()
            elif fetch_all:
                result = cursor.fetchall()
            conn.commit()
        except sqlite3.IntegrityError as e:
            print(f"Database error: {e}")
        finally:
            conn.close()
        return result