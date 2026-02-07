#!/bin/bash

# Robot Framework Demo Test Runner for AdBros
# This script builds and runs the complete test suite in Docker

set -e

echo "========================================"
echo "  Robot Framework Demo for AdBros"
echo "========================================"
echo ""
echo "Building Docker image and running tests..."
echo ""

# Build and run with Docker Compose
docker-compose up --build

echo ""
echo "========================================"
echo "Tests completed!"
echo "Find results in 'reports' folder."
echo "========================================"
echo ""
echo "To view results:"
echo "  - Open reports/report.html in your browser"
echo "  - Or open reports/log.html for detailed logs"
echo ""
