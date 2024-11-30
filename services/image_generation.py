from utils.aws_client import get_bedrock_client

# bedrock_client = get_bedrock_client()

# def generate_meme_reply(tweet_content: str) -> str:
#     """Generate a meme reply (image) based on the tweet content."""
#     response = bedrock_client.invoke_model(
#         modelId="Titan-Image-Generator-G1-v2",
#         body={
#             "input": f"Create a funny meme image for this tweet: '{tweet_content}'"
#         },
#         contentType="application/json",
#     )
#     image_url = response["body"]["image_url"]  # Assume the response contains a URL
#     return image_url

import base64
import json
import io
from PIL import Image
import time
from botocore.exceptions import ClientError

MODEL_ID = "amazon.titan-image-generator-v2:0"


class ImageError(Exception):
    pass


def generate_image_from_prompt(prompt, seed=10000):
    bedrock_runtime = get_bedrock_client()

    try:
        response = bedrock_runtime.invoke_model(
            body=json.dumps({
                "taskType": "TEXT_IMAGE",
                "textToImageParams": {
                    "text": prompt
                },
                "imageGenerationConfig": {
                    "numberOfImages": 1,
                    "quality": "premium",
                    "seed": seed
                }
            }),
            modelId=MODEL_ID,
            accept="application/json",
            contentType="application/json"
        )

        response_body = json.loads(response.get("body").read())

        # Decode the base64-encoded images
        images = [
            Image.open(io.BytesIO(base64.b64decode(base64_image)))
            for base64_image in response_body.get("images")
        ]

        print("Successfully generated image from prompt: %s", prompt)
        return images

    except ClientError as err:
        print(f"A client error occurred: {err.response['Error']['Message']}")
        raise ImageError(f"A client error occurred: {err.response['Error']['Message']}")
    except ImageError as err:
        print(f"Image generation failed: {err}")
        raise


def generate_meme_reply(tweet_text, tweeter_name, tweeter_handle):
    """
    Generate a meme reply based on the tweet's text by creating an image.

    Args:
        tweet_text (str): The tweet content or meme description.

    Returns:
        meme_image_path (str): The path to the saved meme image.
    """

    # Create a meme prompt based on the tweet content
    meme_prompt = f"Generate a funny meme image based on the following tweet: '''{tweet_text}''' posted by {tweeter_name} having twitter handle as {tweeter_handle}; Make sure the meme is funny."

    # Optionally, you can use a specific seed value for consistency in results
    seed = int(time.time())  # Use current time as a seed for variation

    try:
        # Generate the meme image from the prompt
        meme_images = generate_image_from_prompt(meme_prompt, seed)

        # Save the generated meme image
        meme_image = meme_images[0]
        meme_image_path = f"output/meme_{seed}.jpg"
        meme_image.save(meme_image_path)

        print("Generated meme saved to: %s", meme_image_path)
        return meme_image_path

    except Exception as e:
        print(f"An error occurred while generating meme: {e}")
        return ""


