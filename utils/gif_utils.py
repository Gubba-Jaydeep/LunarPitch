from PIL import Image
import requests
from io import BytesIO

def download_images(image_urls):
    """Download images from URLs."""
    images = []
    for url in image_urls:
        response = requests.get(url)
        img = Image.open(BytesIO(response.content))
        images.append(img)
    return images

def create_gif_from_images(image_urls, output_path, duration=500):
    """Create a GIF from a list of image URLs."""
    images = download_images(image_urls)
    images[0].save(
        output_path,
        save_all=True,
        append_images=images[1:],
        duration=duration,
        loop=0,
        format="GIF"
    )
    return output_path
