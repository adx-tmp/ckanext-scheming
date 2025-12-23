# Test Commands Reference

Quick reference for running tests in ckanext-scheming.

## 🚀 Quick Commands

### Show Help
```bash
make help
```

### Fast Local Testing
```bash
make test                                   # Run standalone tests
make test-local-unaids-helpers-standalone  # Run specific test
make test-local-cov                        # Run with coverage
```

### Full Testing with Docker
```bash
make test-full              # Run all tests in Docker
make test-act               # Same as test-full
make test-act-quick         # Run without cleanup (faster)
```

### List Tests
```bash
make list-tests             # Show all test files
```

---

## 📋 All Local Test Commands

| Command | Description | Requires CKAN |
|---------|-------------|---------------|
| `make test-local` | Run standalone tests | ❌ No |
| `make test-local-all` | Try all tests (some will fail) | ⚠️ Partial |
| `make test-local-cov` | Run with coverage | ❌ No |
| `make test-local-unaids-helpers-standalone` | UNAIDS helpers standalone | ❌ No |
| `make test-local-unaids-helpers` | UNAIDS helpers | ✅ Yes |
| `make test-local-unaids-validators` | UNAIDS validators | ✅ Yes |
| `make test-local-helpers` | Scheming helpers | ✅ Yes |
| `make test-local-validation` | Validation tests | ✅ Yes |
| `make test-local-form` | Form rendering | ✅ Yes |
| `make test-local-dataset-display` | Dataset display | ✅ Yes |
| `make test-local-dataset-logic` | Dataset logic | ✅ Yes |
| `make test-local-group-display` | Group display | ✅ Yes |
| `make test-local-group-logic` | Group logic | ✅ Yes |
| `make test-local-load` | Schema loading | ✅ Yes |
| `make test-local-form-snippets` | Form snippets | ✅ Yes |

---

## 🐳 All Docker Test Commands

| Command | Description |
|---------|-------------|
| `make test-act` | Run all tests with Docker |
| `make test-act-quick` | Run without cleanup |
| `make test-act-unaids-helpers-standalone` | UNAIDS helpers standalone |
| `make test-act-unaids-helpers` | UNAIDS helpers |
| `make test-act-unaids-validators` | UNAIDS validators |
| `make test-act-helpers` | Scheming helpers |
| `make test-act-validation` | Validation tests |
| `make test-act-form` | Form rendering |
| `make test-act-dataset-display` | Dataset display |
| `make test-act-dataset-logic` | Dataset logic |
| `make test-act-group-display` | Group display |
| `make test-act-group-logic` | Group logic |
| `make test-act-load` | Schema loading |
| `make test-act-form-snippets` | Form snippets |

---

## 🛠️ Utility Commands

| Command | Description |
|---------|-------------|
| `make setup` | Setup virtual environment |
| `make clean` | Clean venv and cache |
| `make docker-cleanup` | Clean Docker containers |
| `make list-tests` | List all test files |

---

## 📝 Examples

### Development Workflow
```bash
# 1. Quick iteration
make test

# 2. Test specific feature
make test-local-unaids-helpers-standalone

# 3. Full test before commit
make test-full

# 4. Clean up
make clean
```

### Testing New Code
```bash
# Test locally first (fast)
make test-local-unaids-helpers-standalone

# Then test with full CKAN (slow but thorough)
make test-act-unaids-validators
```

### CI/CD Pipeline
```bash
# In GitHub Actions or local CI
make test-act
```

---

## 🎯 Which Command Should I Use?

| Scenario | Command |
|----------|---------|
| Quick iteration during development | `make test` |
| Testing UNAIDS standalone helpers | `make test-local-unaids-helpers-standalone` |
| Testing with full CKAN integration | `make test-act` |
| Before pushing to remote | `make test-full` |
| Debugging specific test | `make test-act-<test-name>` |
| Coverage report | `make test-local-cov` |

---

## 📚 More Information

- **Makefile Reference**: See [MAKEFILE.md](MAKEFILE.md)
- **Testing Guide**: See [TESTING.md](TESTING.md)
- **Quick Help**: Run `make help`
