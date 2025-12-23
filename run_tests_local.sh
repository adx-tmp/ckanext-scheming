#!/bin/bash
# Local test runner for ckanext-scheming
# This script sets up a virtual environment and runs tests locally with pytest
# 
# Note: Full integration tests require CKAN installation.
# Use 'run_tests.sh' for full CI-like testing with Docker/act.

set -e

VENV_DIR=".venv"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "CKAN Scheming - Local Test Runner"
echo "=========================================="
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Install/upgrade dependencies
echo "📥 Installing dependencies..."
pip install -q --upgrade pip setuptools wheel
pip install -q -e .
pip install -q pytest pytest-cov beautifulsoup4 factory-boy jinja2

echo ""
echo "=========================================="
echo "Running Tests"
echo "=========================================="
echo ""

# Run pytest with standalone config
# Note: Tests requiring CKAN (LocalCKAN, clean_db fixtures) will be skipped
if [ "$#" -eq 0 ]; then
    # Run all tests
    pytest -c pytest-standalone.ini ckanext/scheming/tests/ -v --tb=short
else
    # Run specific tests passed as arguments
    pytest -c pytest-standalone.ini "$@" -v --tb=short
fi

TEST_EXIT_CODE=$?

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ Tests completed successfully!"
else
    echo "⚠️  Some tests failed or were skipped"
    echo ""
    echo "NOTE: Tests requiring CKAN (like test_unaids_validators.py)"
    echo "need full CKAN installation. Use 'run_tests.sh' for full"
    echo "integration testing with Docker."
fi

exit $TEST_EXIT_CODE
