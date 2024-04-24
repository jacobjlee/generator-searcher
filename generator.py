import argparse
import math
import sys
import random


def generate_points(mindist: float, N: int, rseed: int=None) -> None:
    """
    Generate random 2D points with a minimum distance constraint.

    Args:
        mindist (float): The minimum distance between points.
        N (int): The number of points to generate.
        rseed (int, optional): Seed for the random number generator. Defaults to None.
    """
    # Check for invalid input values
    # If N is less than 0, print an error message and exit with status -1
    if N < 0:
        sys.stderr.write("N less than zero\n")
        sys.exit(-1)
    # if mindist is less than 0 or greater than 10, print an error message and exit with status -2
    if mindist < 0 or mindist > 10:
        sys.stderr.write("mindist outside range\n")
        sys.exit(-2)
    # if N is greater than 10000 / (pi * mindist * mindist), print an error message and exit with status -3
    if N > 10000 / (math.pi * mindist * mindist):
        sys.stderr.write("point saturation\n")
        sys.exit(-3)
    
    # Set random seed if provided
    if rseed is not None:
        random.seed(rseed)

    # Generate points until desired count is reached
    points = []
    while len(points) < min(N, 3):
        x = random.uniform(-50, 50)
        y = random.uniform(-50, 50)

        # Check if the generated point violates minimum distance constraint
        valid = True
        for px, py in points:
            distance = math.sqrt((x - px) ** 2 + (y - py) ** 2)
            if distance < mindist:
                valid = False
                break
        if valid:
            points.append((x, y))

    # Print the generated points
    for point in points:
        sys.stdout.write("{:.2f}, {:.2f}\n".format(point[0], point[1]))

def main() -> None:
    """
    Parse command-line arguments and call the generate_points function.
    """
    parser = argparse.ArgumentParser(description='Generate random 2D points with minimum distance constraint')
    parser.add_argument('-N', type=int, help='number of points to generate', required=True)
    parser.add_argument('-mindist', type=float, help='minimum distance between points', required=True)
    parser.add_argument('-rseed', type=int, help='seed for random number generator', default=None)
    args = parser.parse_args()

    # Call the function to generate points
    generate_points(args.mindist, args.N, args.rseed)

if __name__ == "__main__":
    main()
