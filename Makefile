# Makefile for ckanext-scheming tests
# Provides commands for running tests with Docker (act)

.PHONY: help test clean

# Colors for output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
NC     := \033[0m # No Color

# Directories
TEST_DIR := ckanext/scheming/tests

# Test files
TEST_FILES := $(shell find $(TEST_DIR) -name "test_*.py" -type f | sort)

##@ General

help: ## Display this help message
	@echo "$(BLUE)ckanext-scheming Test Runner$(NC)"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-25s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Testing (act - full CKAN environment)

test: ## Run all tests with act (Docker/GitHub Actions)
	@echo "$(BLUE)Running tests with act (Docker)...$(NC)"
	@./run_tests.sh

test-quick: ## Run act tests without cleanup (faster for debugging)
	@echo "$(BLUE)Running act tests (no cleanup)...$(NC)"
	@act pull_request -j test --pull=false

##@ Utility

list-tests: ## List all test files
	@echo "$(BLUE)Test files:$(NC)"
	@echo ""
	@for test in $(TEST_FILES); do \
		echo "  $$test"; \
	done
	@echo ""
	@echo "$(BLUE)Summary:$(NC)"
	@echo "  Total test files: $$(echo $(TEST_FILES) | wc -w)"

clean: ## Clean up test artifacts and Docker containers
	@echo "$(BLUE)Cleaning up...$(NC)"
	@rm -rf .pytest_cache
	@rm -rf ckanext/__pycache__ ckanext/scheming/__pycache__
	@rm -rf ckanext/scheming/tests/__pycache__
	@rm -rf *.egg-info
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@docker ps -a --filter "name=act-" --format "{{.ID}}" | xargs -r docker rm -f 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

.DEFAULT_GOAL := help
