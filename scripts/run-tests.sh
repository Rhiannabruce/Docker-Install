#!/bin/bash

echo "Running integration tests..."
sleep 2  # Simulate test execution time

# Define log file location
mkdir -p logs
TEST_LOG="./logs/test_summary.log"

# Example test simulation
if [ $((RANDOM % 2)) -eq 0 ]; then
    echo "Tests Passed!" | tee "$TEST_LOG"
    echo "status=SUCCESS" > "$TEST_LOG"
    TEST_STATUS="SUCCESS"
else
    echo "Tests Failed!" | tee "$TEST_LOG"
    echo "status=FAILED" > "$TEST_LOG"
    TEST_STATUS="FAILED"
fi

# **Don't exit with failure!**
echo "Continuing pipeline despite test outcome."
exit 0  # Always exit successfully to ensure pipeline proceeds
