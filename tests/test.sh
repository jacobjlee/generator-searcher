#!/bin/bash

# Function to run a generator test case
run_generator_test_case() {
    input_file=$1
    expected_output_file=$2

    test_case_name=$(basename "$input_file" .in)
    echo "Running test case: $test_case_name" | sed 's/\.\/tests\///'

    # Read input parameters from the text file
    read -r N mindist rseed < "$input_file"

    # Run the Python script with the input parameters and redirect output to diff command
    python3 gen_points.py -N "$N" -mindist "$mindist" -rseed "$rseed" 2>&1 | diff -u "$expected_output_file" -

    if [ ! $? -eq 0 ]; then
        echo "Test case failed"
        exit 1
    fi
}

# Function to run a searcher test case
run_searcher_test_case() {
    input_file=$1
    expected_output_file=$2

    test_case_name=$(basename "$input_file" .in)
    echo "Running test case: $test_case_name" | sed 's/\.\/tests\///'

    # Run the C program with input redirected from the input file and redirect output to diff command
    ./smallest_triangle < "$input_file" | diff -u "$expected_output_file" -

    if [ ! $? -eq 0 ]; then
        echo "Test case failed"
        exit 1
    fi
}

# Function to run an end-to-end test case
run_generator_searcher_test_case() {
    input_file=$1
    expected_output_file=$2

    test_case_name=$(basename "$input_file" .in)
    echo "Running test case: $test_case_name" | sed 's/\.\/tests\///'

    # Read input parameters from the text file
    read -r N mindist rseed < "$input_file"

    # Run the Python script with the input parameters, redirect output to the C program and diff the output
    python3 gen_points.py -N "$N" -mindist "$mindist" -rseed "$rseed" 2>/dev/null | ./smallest_triangle | diff -u "$expected_output_file" -

    if [ ! $? -eq 0 ]; then
        echo "Test case failed"
        exit 1
    fi
}

# Generator test cases
# Test case 1: Test fails with invalid input n less than 0
run_generator_test_case "./tests/generator_fails_invalid_input_n_less_than_zero.in" "./tests/generator_fails_invalid_input_n_less_than_zero.out"
# Test case 2: Test fails with invalid input mindist outside range
run_generator_test_case "./tests/generator_fails_invalid_input_mindist_outside_range.in" "./tests/generator_fails_invalid_input_mindist_outside_range.out"
# Test case 3: Test fails with invalid input point saturation
run_generator_test_case "./tests/generator_fails_invalid_input_point_saturation.in" "./tests/generator_fails_invalid_input_point_saturation.out"
# Test case 4: Test succeeds with valid input including random seed
run_generator_test_case "./tests/generator_succeeds_generate_points_with_rseed.in" "./tests/generator_succeeds_generate_points_with_rseed.out"
# Test case 5: Test succeeds with edge case n equals 0
run_generator_test_case "./tests/generator_succeeds_edge_case_input_zero.in" "./tests/generator_succeeds_edge_case_input_zero.out"

# Searcher test cases
# Test case 1: Test fails with exactly three points
run_searcher_test_case "./tests/searcher_fails_not_a_triangle_three_points.in" "./tests/searcher_fails_not_a_triangle_three_points.out"
# Test case 2: Test fails with more than three points
run_searcher_test_case "./tests/searcher_fails_not_a_triangle_more_than_three_points.in" "./tests/searcher_fails_not_a_triangle_more_than_three_points.out"
# test case 3: Test fails with single point
run_searcher_test_case "./tests/searcher_fails_not_a_triangle_single_point.in" "./tests/searcher_fails_not_a_triangle_single_point.out"
# Test case 4: Test fails with invalid input format
run_searcher_test_case "./tests/searcher_fails_not_a_triangle_invalid_input_format.in" "./tests/searcher_fails_not_a_triangle_invalid_input_format.out"
# Test case 5: Test fails with no input
run_searcher_test_case "./tests/searcher_fails_not_a_triangle_no_input.in" "./tests/searcher_fails_not_a_triangle_no_input.out"
# Test case 6: Test succeeds with valid input
run_searcher_test_case "./tests/searcher_succeeds_calculate_a_triangle.in" "./tests/searcher_succeeds_calculate_a_triangle.out"

# End-to-end test cases
# Test case 1: Test fails with invalid input n less than 0
run_generator_searcher_test_case "./tests/e2e_generator_searcher_fails_invalid_input_n_less_than_zero.in" "./tests/e2e_generator_searcher_fails_invalid_input_n_less_than_zero.out"
# Test case 2: Test fails with invalid input mindist outside range
run_generator_searcher_test_case "./tests/e2e_generator_searcher_fails_invalid_input_mindist_outside_range.in" "./tests/e2e_generator_searcher_fails_invalid_input_mindist_outside_range.out"
# Test case 3: Ttest fails with invalid input point saturation
run_generator_searcher_test_case "./tests/e2e_generator_searcher_fails_invalid_input_point_saturation.in" "./tests/e2e_generator_searcher_fails_invalid_input_point_saturation.out"
# Test case 4: Test succeeds with valid input including rseed
run_generator_searcher_test_case "./tests/e2e_generator_searcher_succeeds_generate_points_search_triangle.in" "./tests/e2e_generator_searcher_succeeds_generate_points_search_triangle.out"
# Test case 5: Test succeeds with edge case n equals 0
run_generator_searcher_test_case "./tests/e2e_generator_searcher_succeeds_edge_case_input_zero.in" "./tests/e2e_generator_searcher_succeeds_edge_case_input_zero.out"
