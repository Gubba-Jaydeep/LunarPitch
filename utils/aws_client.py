import boto3
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def get_bedrock_client():
    """Create a boto3 client for Amazon Bedrock."""
    access_key = os.getenv("AWS_ACCESS_KEY_ID")
    secret_key = os.getenv("AWS_SECRET_ACCESS_KEY")
    region = os.getenv("AWS_DEFAULT_REGION")
    session_token = os.getenv("AWS_SESSION_TOKEN")

    if not (access_key and secret_key and region):
        raise ValueError("AWS credentials or region not set in .env file")

    return boto3.client(
        "bedrock-runtime",
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        region_name=region,
        aws_session_token=session_token
    )
