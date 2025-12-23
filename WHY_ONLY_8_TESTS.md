# Why `make test-local` Only Runs 8 Tests

## The Situation

When you run `make test-local`, you see only **8 tests** pass, even though there are **12 test files** in `ckanext/scheming/tests/`.

## The Reason

**Most tests require CKAN to be installed**, which is not available in the local venv.

### Test Breakdown:

| Category | Count | Can Run Locally? |
|----------|-------|------------------|
| **Standalone test file** | 1 file (8 tests) | ✅ Yes |
| **Integration test files** | 11 files (~100+ tests) | ❌ No - Need CKAN |

### Standalone Tests (Run Locally)
- `test_unaids_helpers_standalone.py` - 8 tests ✅
  - Tests pure Python functions
  - No CKAN dependencies

### Integration Tests (Require CKAN)
- `test_unaids_helpers.py` - Imports CKAN modules
- `test_unaids_validators.py` - Uses LocalCKAN
- `test_helpers.py` - Imports ckan.plugins
- `test_validation.py` - Uses CKAN validators
- `test_form.py` - Imports ckan.lib
- `test_dataset_display.py` - Uses CKAN templates
- `test_dataset_logic.py` - Uses CKAN actions
- `test_group_display.py` - Uses CKAN views
- `test_group_logic.py` - Uses CKAN models
- `test_load.py` - Uses CKAN config
- `test_form_snippets.py` - Uses CKAN templating

## How to Run All Tests

### Option 1: Docker with act (Recommended)
```bash
make test-act        # Runs ALL tests in Docker with CKAN
make test-full       # Same as above
```

This runs all ~100+ tests in a proper CKAN environment.

### Option 2: Install CKAN Locally (Complex)
You would need to:
1. Install CKAN (complex setup)
2. Configure CKAN database
3. Install all CKAN dependencies
4. Then run tests

**Not recommended** - use Docker instead.

## Quick Reference

```bash
# Show test breakdown
make list-tests      # Shows 1 standalone, 11 integration files
make test-count      # Shows 8 standalone, 100+ total tests

# Run what you can locally (fast)
make test            # 8 tests in ~0.1 seconds

# Run everything (slow but complete)
make test-act        # 100+ tests in ~5-10 minutes
```

## Why This Design?

### Standalone Tests
- **Fast iteration** during development
- **No dependencies** needed
- **Quick feedback** loop
- Perfect for testing pure functions

### Integration Tests
- **Real CKAN environment** needed
- **Database** required
- **Full stack** testing
- Ensures everything works together

## The Trade-off

| Approach | Speed | Coverage | Setup |
|----------|-------|----------|-------|
| `make test` (local) | ⚡ Fast (0.1s) | 📊 Partial (8 tests) | ✅ Simple |
| `make test-act` (Docker) | 🐌 Slow (5-10min) | 📊 Complete (100+ tests) | 🐳 Docker required |

## Recommendations

### During Development
```bash
make test    # Quick feedback on standalone code
```

### Before Committing
```bash
make test-full    # Ensure nothing breaks
```

### In CI/CD
```bash
make test-act    # Full test suite in Docker
```

## Adding More Standalone Tests

To create tests that run locally without CKAN:

1. **Don't import CKAN modules** in the test file
2. **Test pure Python functions** only
3. **Name the file** `*_standalone.py`
4. **Copy functions** to test if needed (like we did with `comma_swap_formatter`)

Example:
```python
# test_my_feature_standalone.py
import pytest

def my_pure_function(x):
    return x * 2

def test_my_function():
    assert my_pure_function(5) == 10
```

## Summary

- ✅ **8 tests run locally** because only 1 file doesn't require CKAN
- ⚙️ **11 test files require CKAN** to import and run
- 🐳 **Use Docker (`make test-act`)** to run all ~100+ tests
- ⚡ **Local tests are for speed**, Docker tests for completeness

**This is intentional design** - fast local iteration with optional full integration testing.
