import json
from utils.aws_client import get_bedrock_client

def generate_message(
    bedrock_client,
    model_id,
    messages,
    max_tokens=512,
    top_p=1,
    temperature=0.5,
    system=""
):
    body = json.dumps(
        {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": max_tokens,
            "messages": messages,
            "temperature": temperature,
            "top_p": top_p,
            "system": system
        }
    )
    response = bedrock_client.invoke_model(body=body, modelId=model_id)
    response_body = json.loads(response.get("body").read())
    return response_body


def generate_text_reply(tweet_content: str, tweeter_name=None, tweeter_handle=None) -> str:

    # Initialize the Bedrock client
    bedrock_client = get_bedrock_client()

    # Define the model ID (adjust as per the model you're using)
    model_id = "anthropic.claude-3-sonnet-20240229-v1:0"
    system = "You reply to tweets give to you. You reply in a funky and engaging way to the tweets given to you. Give short replies, and include hashtags in the tweet if required. Do not include any extra description or intro to message. The message provided by you will directly be used as a reply to the tweet."
    tweet_content = f"tweet: '{tweet_content}'"
    if tweeter_name:
        tweet_content +=f"; name_of_poster: {tweeter_name}"
    if tweeter_handle:
        tweet_content +=f"; handle: {tweeter_handle}"
    # Construct the message
    message_list = [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": tweet_content}
            ]
        }
    ]

    try:

        # Generate the message
        response = generate_message(
            bedrock_client=bedrock_client,
            model_id=model_id,
            messages=message_list,
            max_tokens=512,
            temperature=0.5,
            top_p=0.9,
            system=system
        )
        print(response)
    except Exception as e:
        print(e)
        return ""

    # Extract the reply from the response body
    return response['content'][0]['text']

def generate_summarisation(tweet_content: str, tweeter_name=None, tweeter_handle=None) -> str:

    # Initialize the Bedrock client
    bedrock_client = get_bedrock_client()

    # Define the model ID (adjust as per the model you're using)
    model_id = "anthropic.claude-3-sonnet-20240229-v1:0"
    system = "You create exceptionally good prompts for generating funny and cool memes. You will be provided with tweet. You need to understand and create a prompt for generating a meme reply for this tweet. Make sure to mention in the prompt to not have any text \nIMPORTANT NOTE: return only the prompt and nothing else. It should start with '''Create a meme'''"
    tweet_content = f"tweet: '{tweet_content}'"
    if tweeter_name:
        tweet_content += f"; name_of_poster: {tweeter_name}"
    if tweeter_handle:
        tweet_content += f"; handle: {tweeter_handle}"
    # Construct the message
    message_list = [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": tweet_content}
            ]
        }
    ]

    try:

        # Generate the message
        response = generate_message(
            bedrock_client=bedrock_client,
            model_id=model_id,
            messages=message_list,
            max_tokens=512,
            temperature=0.5,
            top_p=0.9,
            system=system
        )
        print(response)
    except Exception as e:
        print(e)
        return ""

    # Extract the reply from the response body
    return response['content'][0]['text']