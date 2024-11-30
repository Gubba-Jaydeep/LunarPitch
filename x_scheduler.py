import schedule
import time
import os
from database.manager import *
import glob

def x_scraper():
    database_manager = DatabaseManager()
    users = database_manager.read_users()
    users = ",".join(users)
    print('getting tweets for users:', users)
    os.system(f'python3 scraper --tweets=50 --username={users}')

def perform_analytics():
    pass

x_scraper()


