#!/bin/bash

# Robot Framework Demo Test Runner for AdBros
# This script runs the complete test suite in Docker
# Use --build flag to force rebuild: ./run_tests.sh --build

set -e

echo "========================================"
echo "  Robot Framework Demo for AdBros"
echo "========================================"
echo ""

# Parse arguments
BUILD_FLAG=""
if [ "$1" = "--build" ]; then
    BUILD_FLAG="--build"
    echo "Building Docker image and running tests..."
else
    echo "Running tests with existing Docker image..."
    echo "Use --build flag to force rebuild: ./run_tests.sh --build"
fi
echo ""

# Run with Docker Compose
docker compose up ${BUILD_FLAG}

echo ""
echo "========================================"
echo "  TEST EXECUTION COMPLETED"
echo "========================================"
echo ""
echo "━━━ RESULTS & LOGS ━━━"
echo "  📊 Summary:  reports/report.html"
echo "  📝 Detailed: reports/log.html"
echo "  📦 Raw data: reports/output.xml"
echo ""
echo "━━━ NEXT STEPS ━━━"
echo "  🔁 Run again:       ./run_tests.sh"
echo "  🔨 Force rebuild:   ./run_tests.sh --build"
echo "  🧹 Clean containers: docker compose down -v"
echo ""
echo "━━━ RUN STATISTICS ━━━"
echo "  Check reports/report.html for:"
echo "    • Total tests passed/failed"
echo "    • Execution time"
echo "    • Critical errors"
echo ""
echo "========================================"
