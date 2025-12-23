# Makefile Quick Reference

## Overview
The Makefile provides convenient commands for running tests locally (pytest) or with Docker (act).

## Quick Start

```bash
# Show all available commands
make help

# Run standalone tests locally (fast)
make test

# Run all tests with Docker (full CKAN environment)
make test-full

# List all test files
make list-tests
```

## Common Commands

### Setup and Cleanup
```bash
make setup          # Setup virtual environment
make clean          # Clean up venv and cache files
make docker-cleanup # Clean up Docker containers
```

### Local Testing (Fast - No Docker)
```bash
make test-local                           # Run standalone tests
make test-local-cov                       # Run with coverage
make test-local-unaids-helpers-standalone # Run specific test
```

### Docker Testing (Full CKAN Environment)
```bash
make test-act                  # Run all tests with Docker
make test-act-quick            # Run without cleanup (faster)
make test-act-unaids-validators # Run specific test
```

## Individual Test Files

### Standalone Tests (Run Locally Without CKAN)
- `make test-local-unaids-helpers-standalone` ✅

### Integration Tests (Require CKAN via Docker)
- `make test-act-unaids-helpers`
- `make test-act-unaids-validators`
- `make test-act-helpers`
- `make test-act-validation`
- `make test-act-form`
- `make test-act-dataset-display`
- `make test-act-dataset-logic`
- `make test-act-group-display`
- `make test-act-group-logic`
- `make test-act-load`
- `make test-act-form-snippets`

## Examples

### Development Workflow

```bash
# 1. Quick iteration with standalone tests
make test-local-unaids-helpers-standalone

# 2. Run with coverage to check test completeness
make test-local-cov

# 3. Before committing, run full test suite
make test-full
```

### CI/CD Integration

```bash
# In CI pipeline, use Docker tests
make test-act
```

### Debugging Failed Tests

```bash
# Run specific test file locally
make test-local-validation

# If it requires CKAN, run with Docker
make test-act-validation

# Keep Docker containers for inspection
make test-act-quick
```

## Tips

1. **Fast Iteration**: Use `make test` for quick local tests
2. **Full Testing**: Use `make test-full` before pushing
3. **Specific Tests**: Use `make test-local-<test-name>` or `make test-act-<test-name>`
4. **List Options**: Run `make help` to see all commands
5. **Color Output**: Commands use color coding for better readability

## Troubleshooting

### "No rule to make target"
Make sure you're in the project root directory.

### "Docker not found"
Install Docker for act-based tests, or use local tests only.

### "Test requires CKAN"
Use the corresponding `test-act-*` command instead of `test-local-*`.

## File Structure

```
.
├── Makefile                  # Test commands
├── run_tests_local.sh        # Local test script (used by make)
├── run_tests.sh              # Docker test script (used by make)
├── pytest-standalone.ini     # Pytest config for local tests
└── TESTING.md               # Detailed testing guide
```
