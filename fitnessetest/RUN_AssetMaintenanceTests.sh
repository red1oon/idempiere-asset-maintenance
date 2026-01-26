#!/bin/sh
#
# RUN_AssetMaintenanceTests.sh - Run all Asset Maintenance FitNesse tests
#
# Usage:
#   ./RUN_AssetMaintenanceTests.sh [xml]
#
# Prerequisites:
#   - iDempiere running with FitNesse plugins
#   - Asset Maintenance 2Pack installed
#   - Sample Data 2Pack installed
#   - RUN_FitNesseTest.sh available (from red1-ninja-roundtrip)
#

# Find the generic FitNesse runner
if [ -f "../../../red1-ninja-roundtrip/RUN_FitNesseTest.sh" ]; then
    RUNNER="../../../red1-ninja-roundtrip/RUN_FitNesseTest.sh"
elif [ -f "$ROUNDTRIP_HOME/RUN_FitNesseTest.sh" ]; then
    RUNNER="$ROUNDTRIP_HOME/RUN_FitNesseTest.sh"
else
    echo "ERROR: RUN_FitNesseTest.sh not found"
    echo "Set ROUNDTRIP_HOME or ensure red1-ninja-roundtrip is sibling folder"
    exit 1
fi

FORMAT=${1:-text}

echo "=============================================="
echo "Asset Maintenance FitNesse Test Suite"
echo "=============================================="
echo "Runner: $RUNNER"
echo "Format: $FORMAT"
echo "=============================================="
echo ""

FAILED=0
PASSED=0

# Run tests in order
TESTS="Test01_MP_Meter Test02_MP_AssetMeter Test03_MP_AssetMeter_Log Test04_MP_JobStandar Test05_MP_JobStandar_Task Test06_MP_Maintain Test07_MP_OT Test08_MP_OT_Task Test09_MP_OT_Resource Test10_MP_OT_Request Test11_CreateWorkOrder"

for TEST in $TESTS; do
    echo "--- Running $TEST ---"
    "$RUNNER" "$TEST" test "$FORMAT"
    if [ $? -eq 0 ]; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
    echo ""
done

echo "=============================================="
echo "SUMMARY"
echo "=============================================="
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total:  $((PASSED + FAILED))"
echo "=============================================="

if [ $FAILED -eq 0 ]; then
    echo "Result: ALL TESTS PASSED"
else
    echo "Result: $FAILED TEST(S) FAILED"
fi
echo "=============================================="

exit $FAILED
