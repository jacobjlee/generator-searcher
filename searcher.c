#include <stdio.h>
#include <stdbool.h>
#include <math.h>

// Define the maximum number of points
#define MAX_POINTS 1000

// Define the X and Y ranges
#define X_MIN -50
#define X_MAX 50
#define Y_MIN -50
#define Y_MAX 50

// Define the structure to store a point
typedef struct
{
    double x;
    double y;
} Point;

// Function to calculate the distance between two points
double distance(Point p1, Point p2)
{
    // Using the distance formula: sqrt((x2 - x1)^2 + (y2 - y1)^2)
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

// Function to calculate the area of a triangle formed by three points
double triangle_area(Point p1, Point p2, Point p3)
{
    // Using the formula for calculating the area of a triangle given its vertices
    return fabs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)) / 2.0);
}

// Main function to read points and find the closest triangle
int main()
{
    Point points[MAX_POINTS];
    int num_points = 0;
    char buffer[100];
    int i, j, k;                   // Loop variables
    int closest[3] = {-1, -1, -1}; // Array to store indices of closest points
    double min_distance = 1e9;     // Initialize minimum distance with a large value
    double x;
    double y;

    // Read only the first valid MAX_POINTS points(1000)
    while (num_points < MAX_POINTS && fgets(buffer, sizeof(buffer), stdin) != NULL)
    {
        // Assume the input is in the format "x, y" and read the coordinates
        if (sscanf(buffer, "%lf, %lf", &x, &y) == 2)
        {
            // Check if coordinates are within expected range (e.g., -50 to 50)
            if (x >= X_MIN && x <= X_MAX && y >= Y_MIN && y <= Y_MAX)
            {
                // Store the point if it meets expectations
                points[num_points].x = x;
                points[num_points].y = y;
                num_points++;
            }
            else
            {
                // Skip the input line if coordinates are out of range
                continue;
            }
        }
        else
        {
            // Skip the input line if it does not match the expected format
            continue;
        }
    }

    // Print the number of points read
    printf("read %d points\n", num_points);

    // Check if less than three points are provided
    if (num_points < 3)
    {
        for (i = 0; i < num_points; i++)
        {
            printf("%.2lf, %.2lf\n", points[i].x, points[i].y);
        }
        printf("This is not a triangle\n");
        
        return 0;
    }

    // Iterate through all combinations of three points to find the closest triangle
    for (i = 0; i < num_points; i++)
    {
        for (j = i + 1; j < num_points; j++)
        {
            for (k = j + 1; k < num_points; k++)
            {
                // Calculate the perimeter of the triangle formed by current points
                double d = distance(points[i], points[j]) + distance(points[j], points[k]) + distance(points[k], points[i]);
                // Check if the current triangle has the minimum perimeter
                if (d < min_distance)
                {
                    // Update minimum distance and closest points
                    min_distance = d;
                    closest[0] = i;
                    closest[1] = j;
                    closest[2] = k;
                }
            }
        }
    }

    // Check if valid closest points were found
    if (closest[0] != -1 && closest[1] != -1 && closest[2] != -1)
    {
        // Print the coordinates of the closest points
        printf("%.2lf, %.2lf\n", points[closest[0]].x, points[closest[0]].y);
        printf("%.2lf, %.2lf\n", points[closest[1]].x, points[closest[1]].y);
        printf("%.2lf, %.2lf\n", points[closest[2]].x, points[closest[2]].y);

        // Calculate the area of the triangle formed by closest points
        double area = triangle_area(points[closest[0]], points[closest[1]], points[closest[2]]);
        // Check if the area is greater than a threshold to determine if it's a triangle
        if (area > 0.001)
        {
            printf("This is a triangle\n");
        }
        else
        {
            printf("This is not a triangle\n");
        }
    }

    return 0;
}
