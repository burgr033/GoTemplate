# Set environment variables
include .env
export

package_name = __GOMODNAME__  

ifeq ($(OS),Windows_NT)
    executable = __EXECUTABLE__.exe 
else
    executable = __EXECUTABLE__
endif

.PHONY: default
default: build

.PHONY: build
build: clean modules
	@echo "Building the application..."
	@go build $(package_name)  || exit 1

.PHONY: modules
modules:
	@echo "Go Modules..."
	@go mod tidy || exit 1
	@go get ./... || exit 1

.PHONY: run
run:
	@echo "Running the application..."
	@./$(executable)

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf *.exe *.out *.html

.PHONY: test
test: ensure-env
	@echo "Running tests..."
	@go test ./...

.PHONY: test-coverage
test-coverage: ensure-env
	@echo "Running tests with coverage..."
	@go test -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html

.PHONY: ensure-env
ensure-env:
	@echo "Setting environment variables..."

.PHONY: lint
lint:
	@echo "Running linter..."
	@golangci-lint run || exit 1

.PHONY: start
start: build run

.PHONY: release
release:
	@goreleaser

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build          Build the application"
	@echo "  modules        Get required modules" 
	@echo "  run            Run the application without building"
	@echo "  clean          Clean build artifacts"
	@echo "  test           Run tests"
	@echo "  test-coverage  Run tests with coverage report"
	@echo "  ensure-env     Ensure environment variables are set"
	@echo "  lint           Run linter"
	@echo "  start          Build and run the application"
	@echo "  help           Display this help message"
