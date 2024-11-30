import sys
sys.path.append('/Users/jaydeepgubba/Documents/Projects/PythonProjects/RocketiumHackathon/LunarPitch/')
from fastapi import APIRouter, HTTPException
from database.manager import DatabaseManager
from database.models import UserRequest
from database.queries import CREATE_USER_QUERY, READ_USERS_QUERY

router = APIRouter()
db_manager = DatabaseManager()

@router.post("/add_users/")
async def add_users(user_request: UserRequest):
    """Add a list of users."""
    usernames = user_request.usernames
    for username in usernames:
        db_manager.execute_query(CREATE_USER_QUERY, [username])
    return {"message": f"{len(usernames)} users added successfully."}

@router.get("/get_users/")
async def get_users():
    """Fetch all users."""
    users = db_manager.execute_query(READ_USERS_QUERY, fetch_all=True)
    if not users:
        raise HTTPException(status_code=404, detail="No users found.")
    return [user[1] for user in users]  # Return only usernames
