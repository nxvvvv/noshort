import argparse
from PIL import Image
import io

def convert(input_file, output_file):
    """
    Converts an image file to ICO format with a specified height of 32 pixels.
    
    Args:
        input_file (str): The path to the input image file.
        output_file (str): The path to save the converted ICO file.
    """
    # Open the input image file using PIL
    image = Image.open(input_file)
  
    # Check if the input file is already in ICO format
    if input_file.endswith('.ico'):
        # If ICO, resize the image to 32x32 pixels
        new_width, new_height = 32, 32
        image = image.resize((new_width, new_height))
        # Adjust the output file path to replace '.png' with '.ico'
        output_file = output_file.replace('.png', '.ico')
        # Save the resized image as ICO
        image.save(output_file)
    else:
        # If not ICO, calculate the new width based on aspect ratio and resize to 32 pixels height
        new_height = 32
        aspect_ratio = image.size[0] / image.size[1]
        new_width = int(aspect_ratio * new_height)
        image = image.resize((new_width, new_height))
        # Adjust the output file path to replace '.png' with '.ico'
        output_file = output_file.replace('.png', '.ico')
        # Save the resized image as ICO with specified format
        image.save(output_file, format='ICO')

if __name__ == '__main__':
    # Set up command-line argument parser
    parser = argparse.ArgumentParser(description='Convert an image to ICO format.')
    parser.add_argument('input', type=str, help='The input image file to be converted.')
    parser.add_argument('output', type=str, help='The output file.')
    args = parser.parse_args()

    # Call the convert function with the provided input and output file paths
    convert(args.input, args.output)
