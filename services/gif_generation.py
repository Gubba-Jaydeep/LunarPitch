import boto3
import base64
import json
import io
from PIL import Image
from .logger import logger

MODEL_ID = "amazon.titan-image-generator-v2:0"


class GIFError(Exception):
    pass


def generate_gif_from_prompts(prompts, seed=10000):
    """
    Generate a GIF using multiple images based on text prompts.

    Args:
        prompts (list): A list of text prompts to generate images.
        seed (int): The random seed to use for generation (default is 10000).

    Returns:
        gif_path (str): The path to the generated GIF.
    """
    try:
        images = []
        for prompt in prompts:
            image = generate_image_from_prompt(prompt, seed)[0]  # Generate each image
            images.append(image)

        gif_path = f"output/generated_gif_{seed}.gif"
        images[0].save(
            gif_path,
            save_all=True,
            append_images=images[1:],
            loop=0,
            duration=500  # Time between frames (in ms)
        )

        logger.info("Generated GIF saved to: %s", gif_path)
        return gif_path
    except Exception as e:
        logger.error(f"An error occurred while generating GIF: {e}")
        raise


def generate_image_from_prompt(prompt, seed):
    """
    Generate a single image based on a prompt using Amazon's Titan Image Generator.

    Args:
        prompt (str): The text prompt to generate the image.
        seed (int): The random seed.

    Returns:
        images (list): List of generated images.
    """
    bedrock_runtime = boto3.client(service_name="bedrock-runtime", region_name="us-east-1")

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
    base64_images = response_body.get("images")
    images = [Image.open(io.BytesIO(base64.b64decode(base64_image))) for base64_image in base64_images]

    return images
