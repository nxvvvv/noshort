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
  image = Image.open(input_file)
  
  if input_file.endswith('.ico'):
    new_width, new_height = 32, 32
    image = image.resize((new_width, new_height))
    output_file = output_file.replace('.png', '.ico')
    image.save(output_file)
  else:
    new_height = 32
    aspect_ratio = image.size[0] / image.size[1]
    new_width = int(aspect_ratio * new_height)
    image = image.resize((new_width, new_height))
    output_file = output_file.replace('.png', '.ico')
    image.save(output_file, format='ICO')

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Convert an image to ICO format.')
  parser.add_argument('input', type=str, help='The input image file to be converted.')
  parser.add_argument('output', type=str, help='The output file.')
  args = parser.parse_args()
  convert(args.input, args.output)
