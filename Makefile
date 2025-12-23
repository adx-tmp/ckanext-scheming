# Makefile for ckanext-scheming tests
# Provides commands for running tests locally (pytest) or with Docker (act)

.PHONY: help setup test-all test-local test-act clean

# Colors for output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
NC     := \033[0m # No Color

# Directories
VENV_DIR := .venv
TEST_DIR := ckanext/scheming/tests
PYTHON := $(VENV_DIR)/bin/python
PYTEST := $(VENV_DIR)/bin/pytest

# Test files
TEST_FILES := $(shell find $(TEST_DIR) -name "test_*.py" -type f | sort)
STANDALONE_TESTS := $(TEST_DIR)/test_unaids_helpers_standalone.py
INTEGRATION_TESTS := $(filter-out $(STANDALONE_TESTS),$(TEST_FILES))

##@ General

help: ## Display this help message
	@echo "$(BLUE)ckanext-scheming Test Runner$(NC)"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-25s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Setup

setup: ## Setup virtual environment and install dependencies
	@echo "$(BLUE)Setting up virtual environment...$(NC)"
	@python3 -m venv $(VENV_DIR)
	@$(VENV_DIR)/bin/pip install -q --upgrade pip setuptools wheel
	@$(VENV_DIR)/bin/pip install -q -e .
	@$(VENV_DIR)/bin/pip install -q pytest pytest-cov beautifulsoup4 factory-boy jinja2
	@echo "$(GREEN)✓ Setup complete!$(NC)"

clean: ## Clean up virtual environment and test artifacts
	@echo "$(BLUE)Cleaning up...$(NC)"
	@rm -rf $(VENV_DIR)
	@rm -rf .pytest_cache
	@rm -rf ckanext/__pycache__ ckanext/scheming/__pycache__
	@rm -rf ckanext/scheming/tests/__pycache__
	@rm -rf *.egg-info
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

##@ Local Testing (pytest - fast, no Docker)

test-local: setup ## Run all standalone tests locally with pytest (only test_unaids_helpers_standalone.py)
	@echo "$(BLUE)Running standalone tests with pytest...$(NC)"
	@echo "$(YELLOW)Note: Only 1/12 test files can run without CKAN (test_unaids_helpers_standalone.py)$(NC)"
	@echo "$(YELLOW)      Use 'make test-act' to run all 12 test files with Docker/CKAN$(NC)"
	@echo ""
	@$(PYTEST) -c pytest-standalone.ini $(STANDALONE_TESTS) -v

test-local-all: setup ## Run all tests locally (will fail - most require CKAN)
	@echo "$(YELLOW)⚠️  Warning: Most tests require CKAN and will fail!$(NC)"
	@echo "$(YELLOW)    9/12 test files need CKAN modules$(NC)"
	@echo "$(YELLOW)    Use 'make test-act' for full test suite$(NC)"
	@echo ""
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR) -v --tb=short || true

test-local-cov: setup ## Run standalone tests with coverage
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	@$(PYTEST) -c pytest-standalone.ini $(STANDALONE_TESTS) --cov=ckanext.scheming --cov-report=term-missing -v

##@ Local Testing - Individual Files

test-local-unaids-helpers-standalone: setup ## Test: UNAIDS helpers (standalone)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_unaids_helpers_standalone.py -v

test-local-unaids-helpers: setup ## Test: UNAIDS helpers (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_unaids_helpers.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-unaids-helpers'$(NC)"

test-local-unaids-validators: setup ## Test: UNAIDS validators (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_unaids_validators.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-unaids-validators'$(NC)"

test-local-helpers: setup ## Test: scheming helpers (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_helpers.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-helpers'$(NC)"

test-local-validation: setup ## Test: validation (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_validation.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-validation'$(NC)"

test-local-form: setup ## Test: form rendering (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_form.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-form'$(NC)"

test-local-dataset-display: setup ## Test: dataset display (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_dataset_display.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-dataset-display'$(NC)"

test-local-dataset-logic: setup ## Test: dataset logic (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_dataset_logic.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-dataset-logic'$(NC)"

test-local-group-display: setup ## Test: group display (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_group_display.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-group-display'$(NC)"

test-local-group-logic: setup ## Test: group logic (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_group_logic.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-group-logic'$(NC)"

test-local-load: setup ## Test: schema loading (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_load.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-load'$(NC)"

test-local-form-snippets: setup ## Test: form snippets (requires CKAN)
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR)/test_form_snippets.py -v || echo "$(YELLOW)Requires CKAN - use 'make test-act-form-snippets'$(NC)"

##@ Docker Testing (act - full CKAN environment)

test-act: ## Run all tests with act (Docker/GitHub Actions)
	@echo "$(BLUE)Running tests with act (Docker)...$(NC)"
	@./run_tests.sh

test-act-quick: ## Run act tests without cleanup (faster for debugging)
	@echo "$(BLUE)Running act tests (no cleanup)...$(NC)"
	@act pull_request -j test --pull=false

##@ Docker Testing - Individual Test Files

test-act-unaids-helpers-standalone: ## Test: UNAIDS helpers standalone (with act)
	@echo "$(BLUE)Running test_unaids_helpers_standalone.py with act...$(NC)"
	@act pull_request -j test --pull=false -e - <<< '{"pull_request":{"head":{"ref":"test"}}}' 2>&1 | grep -A 100 "test_unaids_helpers_standalone"

test-act-unaids-helpers: ## Test: UNAIDS helpers (with act)
	@echo "$(BLUE)Running test_unaids_helpers.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-unaids-validators: ## Test: UNAIDS validators (with act)
	@echo "$(BLUE)Running test_unaids_validators.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-helpers: ## Test: scheming helpers (with act)
	@echo "$(BLUE)Running test_helpers.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-validation: ## Test: validation (with act)
	@echo "$(BLUE)Running test_validation.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-form: ## Test: form rendering (with act)
	@echo "$(BLUE)Running test_form.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-dataset-display: ## Test: dataset display (with act)
	@echo "$(BLUE)Running test_dataset_display.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-dataset-logic: ## Test: dataset logic (with act)
	@echo "$(BLUE)Running test_dataset_logic.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-group-display: ## Test: group display (with act)
	@echo "$(BLUE)Running test_group_display.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-group-logic: ## Test: group logic (with act)
	@echo "$(BLUE)Running test_group_logic.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-load: ## Test: schema loading (with act)
	@echo "$(BLUE)Running test_load.py with act...$(NC)"
	@act pull_request -j test --pull=false

test-act-form-snippets: ## Test: form snippets (with act)
	@echo "$(BLUE)Running test_form_snippets.py with act...$(NC)"
	@act pull_request -j test --pull=false

##@ Utility

list-tests: ## List all test files and counts
	@echo "$(BLUE)Test files:$(NC)"
	@echo ""
	@echo "$(GREEN)Standalone (run locally without CKAN):$(NC)"
	@for test in $(TEST_FILES); do \
		if echo "$$test" | grep -q "standalone"; then \
			echo "  ✅ $$test"; \
		fi \
	done
	@echo ""
	@echo "$(YELLOW)Integration tests (require CKAN - use 'make test-act'):$(NC)"
	@for test in $(TEST_FILES); do \
		if ! echo "$$test" | grep -q "standalone"; then \
			echo "  ⚙️  $$test"; \
		fi \
	done
	@echo ""
	@echo "$(BLUE)Summary:$(NC)"
	@echo "  Total test files: $$(echo $(TEST_FILES) | wc -w)"
	@echo "  Standalone:       $$(echo $(TEST_FILES) | tr ' ' '\n' | grep -c 'standalone')"
	@echo "  Require CKAN:     $$(echo $(TEST_FILES) | tr ' ' '\n' | grep -cv 'standalone')"

test-count: setup ## Count test functions in standalone vs integration tests
	@echo "$(BLUE)Counting test functions...$(NC)"
	@echo ""
	@echo "$(GREEN)Standalone tests (can run locally):$(NC)"
	@$(PYTEST) -c pytest-standalone.ini $(STANDALONE_TESTS) --collect-only -q 2>/dev/null | tail -1 || echo "0 tests"
	@echo ""
	@echo "$(YELLOW)All tests (including those requiring CKAN):$(NC)"
	@$(PYTEST) -c pytest-standalone.ini $(TEST_DIR) --collect-only -q 2>&1 | grep "collected" || echo "Unable to count (CKAN required)"
	@echo ""
	@echo "$(BLUE)Note:$(NC) Most tests require full CKAN installation to run"
	@echo "      Use 'make test-act' for complete test suite"

docker-cleanup: ## Clean up Docker containers from act
	@echo "$(BLUE)Cleaning up act Docker containers...$(NC)"
	@docker ps -a --filter "name=act-" --format "{{.ID}}" | xargs -r docker rm -f 2>/dev/null || true
	@echo "$(GREEN)✓ Docker cleanup complete!$(NC)"

##@ Shortcuts

test: test-local ## Alias for test-local (quick local tests)

test-full: test-act ## Alias for test-act (full Docker tests)

.DEFAULT_GOAL := help
