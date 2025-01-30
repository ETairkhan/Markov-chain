#!/bin/bash

test_failed=false

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"
MAGENTA="\033[35m"

print_pass() {
    echo -e "[${GREEN}PASS${RESET}] $1"
}

print_fail() {
    echo -e "[${RED}FAIL${RESET}] $1"
}

check_panic() {
    local output=$1
    local test_case=$2

    if [[ "$output" == *"panic"* ]]; then
        echo -e "[${MAGENTA}CRIT FAIL${RESET}] Test case $test_case: Program panicked."
        echo -e "${YELLOW}Actual output:${RESET} $output"
        test_failed=true
        return 1
    fi
    return 0
}

verify_error_output() {
    local output=$1
    local test_case=$2

    # Check if the output contains the word "Error" (generic error check)
    if [[ "$output" == *"Error"* ]]; then
        print_pass "Test case $test_case: Error message detected in output."
    else
        print_fail "Test case $test_case: No error message found in output."
        echo -e "${YELLOW}Actual output:${RESET} $output"
        test_failed=true
    fi
}

# Test case 1
test_no_input_text() {
    result=$(./markovchain 2>&1 || true)
    verify_error_output "$result" "1"
}

# Test case 2
test_random_output() {
    result=$(cat the_great_gatsby.txt | ./markovchain 2>&1 || true)
    check_panic "$result"
    if [[ "$result" == *"Chapter 1 In my"* ]]; then
        print_pass "Test case 2: Random output contains expected pattern."
    else
        print_fail "Test case 2: Output did not contain expected random text."
        test_failed=true
    fi
}

# Test case 3
test_wc_word_count() {
    result=$(cat the_great_gatsby.txt | ./markovchain -w 10000 | wc -w)
    if [[ "$result" -eq 10000 ]]; then
        print_pass "Test case 3: Word count matches the expected 10000."
    else
        print_fail "Test case 3: Word count is $result, expected 10000."
        test_failed=true
    fi
}

# Test case 4
test_zero_words() {
    result=$(cat the_great_gatsby.txt | ./markovchain -w 0 2>&1 || true)
    verify_error_output "$result" "4"
}

# Test case 5
test_too_many_words() {
    result=$(cat the_great_gatsby.txt | ./markovchain -w 10001 2>&1 || true)
    verify_error_output "$result" "5"
}

# Test case 6
test_prefix_length_zero() {
    result=$(cat the_great_gatsby.txt | ./markovchain -l 0 2>&1 || true)
    verify_error_output "$result" "6"
}

# Test case 7
test_prefix_length_six() {
    result=$(cat the_great_gatsby.txt | ./markovchain -l 6 2>&1 || true)
    verify_error_output "$result" "7"
}

# Test case 8
test_prefix_length_one() {
    result=$(cat the_great_gatsby.txt | ./markovchain -l 1 2>&1 || true)
    check_panic "$result"
    if [[ "$result" =~ "Chapter" ]]; then
        print_pass "Test case 8: Output contains expected chapters."
    else
        print_fail "Test case 8: Output did not contain chapters."
        test_failed=true
    fi
}

# Test case 9
test_not_found_prefix() {
    result=$(cat the_great_gatsby.txt | ./markovchain -p "NOT FOUND PREFIX" 2>&1 || true)
    verify_error_output "$result" "9"
}

# Test case 10
test_specific_prefix() {
    result=$(cat the_great_gatsby.txt | ./markovchain -p "Chapter 3" 2>&1 || true)
    check_panic "$result"
    if [[ "$result" == *"Chapter 3"* ]]; then
        print_pass "Test case 10: Output starts with Chapter 3."
    else
        print_fail "Test case 10: Output did not start with Chapter 3."
        test_failed=true
    fi
}

# Test case 11
test_invalid_prefix_length() {
    result=$(cat the_great_gatsby.txt | ./markovchain -p "Chapter" 2>&1 || true)
    verify_error_output "$result" "11"
}

# Test case 12
test_error_suffix_not_found() {
    result=$(echo "Ha ha he he" | ./markovchain 2>&1 || true)
    verify_error_output "$result" "12"
}

# Test case 13
test_word_count_four() {
    result=$(echo "Ha ha he he" | ./markovchain -w 4)
    check_panic "$result"
    if [[ "$result" == "Ha ha he he" ]]; then
        print_pass "Test case 13: Output contains the expected 4 words."
    else
        print_fail "Test case 13: Output did not match expected 4 words."
        test_failed=true
    fi
}

# Test case 14
test_word_count_three() {
    result=$(echo "Ha ha he he" | ./markovchain -w 3)
    check_panic "$result"
    if [[ "$result" == "Ha ha he" ]]; then
        print_pass "Test case 14: Output contains the expected 3 words."
    else
        print_fail "Test case 14: Output did not match expected 3 words."
        test_failed=true
    fi
}

# Test case 15
test_word_count_one() {
    result=$(echo "Ha ha he he" | ./markovchain -w 1)
    check_panic "$result"
    if [[ "$result" == "Ha" ]]; then
        print_pass "Test case 15: Output contains the expected 1 word."
    else
        print_fail "Test case 15: Output did not match expected 1 word."
        test_failed=true
    fi
}

# Test case 16
test_prefix_three_words() {
    result=$(echo "Ha ha he he" | ./markovchain -l 3 2>&1 || true)
    verify_error_output "$result" "16"
}

# Test case 17
test_prefix_four_words() {
    result=$(echo "Ha ha he he" | ./markovchain -l 4 2>&1 || true)
    verify_error_output "$result" "17"
}

# Test case 18
test_prefix_one_word() {
    result=$(echo "Ha ha he he" | ./markovchain -l 1)
    check_panic "$result"
    if [[ "$result" =~ "he" ]]; then
        print_pass "Test case 18: Output contains expected repeated words."
    else
        print_fail "Test case 18: Output did not contain expected repeated words."
        test_failed=true
    fi
}

# Test case 19
test_not_enough_words_for_prefix() {
    result=$(echo "Ha" | ./markovchain 2>&1 || true)
    verify_error_output "$result" "19"
}

# Test case 20
test_empty_input() {
    result=$(echo "" | ./markovchain 2>&1 || true)
    verify_error_output "$result" "20"
}

# Test case 21
test_invalid_prefix_length_in_input() {
    result=$(echo "Ha ha he he" | ./markovchain -p "he he" 2>&1 || true)
    verify_error_output "$result" "21"
}

# Test case 22
test_valid_prefix_length_input() {
    result=$(echo "Ha ha he he" | ./markovchain -p "ha he")
    check_panic "$result"
    if [[ "$result" == "ha he he" ]]; then
        print_pass "Test case 22: Output starts with 'ha he'."
    else
        print_fail "Test case 22: Output did not start with 'ha he'."
        test_failed=true
    fi
}

# Test case 23
test_prefix_length_one_input() {
    result=$(echo "Ha ha he he" | ./markovchain -p "ha he" -l 1)
    check_panic "$result"
    if [[ "$result" == *"he he"* ]]; then
        print_pass "Test case 23: Output contains expected repeated words."
    else
        print_fail "Test case 23: Output did not contain expected repeated words."
        test_failed=true
    fi
}

# Test case 24
test_prefix_length_one_input_two() {
    result=$(echo "Ha ha he he" | ./markovchain -p "he" -l 1)
    check_panic "$result"
    if [[ "$result" == *"he he"* ]]; then
        print_pass "Test case 24: Output contains expected repeated words."
    else
        print_fail "Test case 24: Output did not contain expected repeated words."
        test_failed=true
    fi
}

# Run all tests
echo "Running test cases for markovchain..."
echo

test_no_input_text
test_random_output
test_wc_word_count
test_zero_words
test_too_many_words
test_prefix_length_zero
test_prefix_length_six
test_prefix_length_one
test_not_found_prefix
test_specific_prefix
test_invalid_prefix_length
test_error_suffix_not_found
test_word_count_four
test_word_count_three
test_word_count_one
test_prefix_three_words
test_prefix_four_words
test_prefix_one_word
test_not_enough_words_for_prefix
test_empty_input
test_invalid_prefix_length_in_input
test_valid_prefix_length_input
test_prefix_length_one_input
test_prefix_length_one_input_two

if [ "$test_failed" = true ]; then
    print_fail "Some tests failed"
else
    print_pass "All test cases completed successfully"
fi
echo -e "\n\e[1m\e[34m+---------------------------------------------------------------------------+\e[0m"
echo -e "\e[1m\e[34m|       The tool was made by dialtaibe, prod by aykuanysh ft.mromanul.      |\e[0m"
echo -e "\e[1m\e[34m+---------------------------------------------------------------------------+\e[0m\n"
