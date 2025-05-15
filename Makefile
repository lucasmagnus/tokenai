#!make

help:
	@echo "Usage: make [test,lint,format]"
	@echo ""
	@echo "Usage:"
	@echo "  make test  	         Runs the flutter tests"
	@echo "  make lint  	         Runs the flutter analyzer"
	@echo "  make format       Formats the flutter code with the flutter formatter"
	@echo ""

setup:
	flutter pub get

tests: setup
	flutter test --coverage

lint: setup
	flutter analyze .

format:
	flutter format .
