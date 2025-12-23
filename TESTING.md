# Local Testing Guide for ckanext-scheming

This guide explains how to run tests locally without Docker/act.

## Overview

There are two ways to run tests for this extension:

1. **Local pytest** - Fast, runs unit tests that don't require full CKAN
2. **Docker/act** - Full CI environment with CKAN (see `run_tests.sh`)

## Quick Start - Using Makefile (Recommended)

```bash
# Show all available commands
make help

# Run standalone tests locally (fast)
make test

# Run specific test file
make test-local-unaids-helpers-standalone

# Run full tests with Docker
make test-full

# List all test files
make list-tests
```

See [MAKEFILE.md](MAKEFILE.md) for complete Makefile reference.

## Quick Start - Manual Commands

```bash
# Run all standalone tests
./run_tests_local.sh

# Run specific test file
./run_tests_local.sh ckanext/scheming/tests/test_unaids_helpers_standalone.py

# Run with pytest directly
source .venv/bin/activate
pytest -c pytest-standalone.ini ckanext/scheming/tests/test_unaids_helpers_standalone.py -v
```

## Setup Details

### 1. Virtual Environment

The `run_tests_local.sh` script automatically creates and manages a virtual environment in `.venv/`:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
pip install pytest pytest-cov jinja2
```

### 2. Test Configuration

- **pytest-standalone.ini** - Pytest config for local testing (disables pytest-ckan)
- **test.ini** - CKAN test configuration (requires full CKAN installation)

### 3. Test Types

#### Standalone Tests (No CKAN Required)
These tests can run locally without CKAN:

- `test_unaids_helpers_standalone.py` - Unit tests for helper functions

#### Integration Tests (CKAN Required)
These tests need full CKAN installation:

- `test_unaids_validators.py` - Tests validators with LocalCKAN
- `test_unaids_helpers.py` - Tests helpers that import CKAN modules
- `test_form.py`, `test_validation.py`, etc. - Full scheming tests

## Running Different Test Scenarios

### Run only standalone tests:
```bash
pytest -c pytest-standalone.ini ckanext/scheming/tests/test_unaids_helpers_standalone.py -v
```

### Run with coverage:
```bash
pytest -c pytest-standalone.ini --cov=ckanext.scheming ckanext/scheming/tests/test_unaids_helpers_standalone.py
```

### Run all tests (requires CKAN):
```bash
# Use Docker/act for full integration tests
./run_tests.sh
```

## Test Structure

```
ckanext/scheming/tests/
├── test_unaids_helpers_standalone.py  # ✅ Runs locally (no CKAN)
├── test_unaids_helpers.py             # ❌ Requires CKAN
├── test_unaids_validators.py          # ❌ Requires CKAN (uses LocalCKAN)
├── test_form.py                       # ❌ Requires CKAN
└── schemas/                           # Test schema files
    ├── auto_unique_validator.json
    └── autofill_validator.json
```

## Adding New Standalone Tests

To create tests that run without CKAN:

1. Import only pure Python functions (no CKAN imports)
2. Use pytest's standard features (parametrize, fixtures, etc.)
3. Place in a `*_standalone.py` file

Example:
```python
import pytest

def my_pure_function(input):
    return input.upper()

def test_my_function():
    assert my_pure_function("hello") == "HELLO"
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'ckan'"

This means the test requires full CKAN installation. Either:
- Use `./run_tests.sh` for Docker-based testing
- Create a standalone version of the test

### "ModuleNotFoundError: No module named 'jinja2'"

Install missing dependencies:
```bash
source .venv/bin/activate
pip install jinja2
```

### Tests are skipped

Check if you're using the correct config:
```bash
pytest -c pytest-standalone.ini  # For local tests
```

## CI/CD Testing

For full integration testing as done in CI:

```bash
# Runs tests in Docker container with full CKAN
./run_tests.sh
```

This uses GitHub Actions workflow with act to simulate the CI environment.

## Dependencies

### Local Testing (Minimal)
- Python 3.7+
- pytest
- pytest-cov
- Extension dependencies (pyyaml, ckanapi, pycountry, etc.)

### Full Testing (act/Docker)
- Docker
- act (GitHub Actions runner)
- Full CKAN environment

## Further Reading

- [pytest documentation](https://docs.pytest.org/)
- [CKAN extension testing](https://docs.ckan.org/en/latest/extensions/testing-extensions.html)
- [act - GitHub Actions locally](https://github.com/nektos/act)
