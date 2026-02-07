# Robot Framework Demo Project for Adbros

A comprehensive test automation demo showcasing Robot Framework capabilities with UI, API, and Database testing layers.

## Overview

This project demonstrates professional test automation practices using:
- **UI Testing**: SauceDemo.com e-commerce application using Robot Framework Browser library (Playwright)
- **API Testing**: Fake Store API using RequestsLibrary
- **Database Testing**: SQLite database using DatabaseLibrary
- **Docker**: Complete containerization for one-command execution

## Quick Start

### Prerequisites
- Docker Desktop installed and running
- Git (optional, for cloning)

### One-Command Execution

**Linux/macOS:**
```bash
# Run tests (fast, uses existing image)
./run_tests.sh

# Force rebuild when dependencies change
./run_tests.sh --build
```

**Windows:**
```batch
# Run tests (fast, uses existing image)
run_tests.bat

# Force rebuild when dependencies change
run_tests.bat --build
```

> **Note:** The Windows script includes an interactive menu after test completion with options to view the report (G), run tests again (A), or quit (L).

Or manually:
```bash
# Quick run (no rebuild)
docker compose up

# Force rebuild
docker compose up --build
```

### View Results
After tests complete, open:
- `reports/report.html` - Test execution summary
- `reports/log.html` - Detailed test logs

## Project Structure

```
adbros/
├── tests/                              # Test suites
│   ├── ui/                             # UI test suites (SauceDemo)
│   │   ├── login_tests.robot           # Authentication tests (9 cases)
│   │   ├── inventory_tests.robot       # Product listing tests (10 cases)
│   │   ├── cart_tests.robot            # Shopping cart tests (8 cases)
│   │   └── checkout_tests.robot        # Checkout flow tests (10 cases)
│   ├── api/                            # API test suites
│   │   └── fakestore_api_tests.robot   # API tests (8 cases)
│   └── db/                             # Database test suites
│       └── fakestore_db_tests.robot    # Database tests (12 cases)
│
├── resources/                          # Shared resources
│   ├── config/                         # Configuration files
│   │   ├── config.resource             # URLs, timeouts, browser settings
│   │   └── test_data.resource          # Test user credentials
│   │
│   ├── ui/                             # UI layer (Page Object Model)
│   │   ├── common.resource             # Imports all UI resources
│   │   ├── keywords/                   # Page object keywords
│   │   │   ├── base_page.resource      # Common page methods
│   │   │   ├── login_page.resource     # Login page keywords
│   │   │   ├── inventory_page.resource # Product inventory keywords
│   │   │   ├── cart_page.resource      # Shopping cart keywords
│   │   │   ├── checkout_page.resource  # Checkout flow keywords
│   │   │   └── navigation_page.resource # Navigation keywords
│   │   └── locators/                   # Page selectors (data-test, CSS)
│   │       ├── shared_locators.resource
│   │       ├── login_page.resource
│   │       ├── inventory_page.resource
│   │       ├── cart_page.resource
│   │       ├── checkout_page.resource
│   │       └── navigation_page.resource
│   │
│   ├── api/                            # API layer (Endpoint Object Model)
│   │   ├── common.resource             # Imports all API resources
│   │   ├── keywords/                   # Endpoint keywords
│   │   │   ├── base_endpoint.resource  # Base API methods
│   │   │   ├── products_endpoint.resource # Products endpoint
│   │   │   ├── users_endpoint.resource    # Users endpoint
│   │   │   └── carts_endpoint.resource    # Carts endpoint
│   │   └── locators/                   # Endpoint URLs
│   │       └── endpoints.resource
│   │
│   └── db/                             # Database layer (Table Object Model)
│       ├── common.resource             # Imports all DB resources
│       ├── keywords/                   # Table keywords
│       │   ├── base_table.resource     # Base database methods
│       │   ├── products_table.resource # Products table
│       │   ├── users_table.resource    # Users table
│       │   ├── carts_table.resource    # Carts table
│       │   └── database_keywords.resource # DB init/verify
│       └── locators/                   # Table names and SQL queries
│           └── tables.resource
│
├── reports/                            # Generated test reports
├── Dockerfile                          # Container image definition
├── docker-compose.yml                  # Service configuration
├── docker-compose.override.yml         # Development overrides (hot-reload)
├── requirements.txt                    # Python dependencies
├── init_db.py                          # Database initialization script
├── run_tests.sh                        # Linux/macOS test runner
├── run_tests.bat                       # Windows test runner
└── README.md                           # Project documentation
```

## Test Suites

### UI Tests (SauceDemo.com) - 37 Test Cases
- **Login Tests** (9 cases): Authentication, validation, error handling
- **Inventory Tests** (10 cases): Product listing, sorting, cart operations
- **Cart Tests** (8 cases): Cart management, item removal
- **Checkout Tests** (10 cases): Complete purchase flow

### API Tests (Fake Store API) - 8 Test Cases
- Product retrieval and validation
- User data verification
- Cart operations
- Filtering and sorting

### Database Tests (SQLite) - 12 Test Cases
- Data persistence verification
- Schema validation
- Data consistency checks

## Running Tests Locally (Without Docker)

### Setup
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Initialize browsers
rfbrowser init

# Initialize database
python init_db.py
```

### Run Tests
```bash
# Run all tests
robot --outputdir reports tests/

# Run specific test suites
robot --outputdir reports tests/ui/
robot --outputdir reports tests/api/
robot --outputdir reports tests/db/

# Run with specific tags
robot --include smoke --outputdir reports tests/
robot --include login --outputdir reports tests/ui/

# Run in parallel (requires pabot)
pabot --outputdir reports tests/
```

## Test Users (SauceDemo)

| Username | Password | Description |
|----------|----------|-------------|
| standard_user | secret_sauce | Standard user |
| locked_out_user | secret_sauce | Locked account |
| problem_user | secret_sauce | Problematic behavior |
| performance_glitch_user | secret_sauce | Slow performance |

## Technology Stack

- **Robot Framework** 7.4.1+ - Test automation framework
- **Robot Framework Browser** 18.0.0+ - Modern Playwright-based UI automation
- **robotframework-requests** 0.9.6+ - API testing
- **robotframework-databaselibrary** 1.2.5+ - Database operations
- **Python** 3.11 - Runtime environment
- **Docker** - Containerization
- **Node.js** 20 LTS - Required for Playwright browsers

## Tag Convention

- `ui` - UI tests
- `api` - API tests
- `db` - Database tests
- `smoke` - Critical smoke tests
- `regression` - Full regression suite
- `demo` - Tests suitable for demo purposes
- `login` - Authentication tests
- `cart` - Shopping cart tests
- `checkout` - Checkout flow tests

## Architecture Patterns

### Page Object Model (UI Layer)
This project follows the Page Object Model pattern for UI testing:
- Page keywords are in `resources/ui/keywords/`
- Locators (selectors) are separated in `resources/ui/locators/`
- Tests use `resources/ui/common.resource` which imports all page objects
- Promotes code reusability and maintainability

### Endpoint Object Model (API Layer)
- API endpoints are modeled as objects in `resources/api/keywords/`
- Endpoint URLs are defined in `resources/api/locators/endpoints.resource`
- Tests use `resources/api/common.resource` which imports all endpoints

### Table Object Model (Database Layer)
- Database tables are modeled as objects in `resources/db/keywords/`
- Table names and queries are in `resources/db/locators/tables.resource`
- Tests use `resources/db/common.resource` which imports all tables

## Docker Containerization

The project includes complete Docker setup:
- `Dockerfile`: Python 3.11-slim with Node.js 20 and Playwright browser support
- `docker-compose.yml`: Service configuration with CI-friendly image naming
- `docker-compose.override.yml`: Development overrides for hot-reload (included in repo)
- Automatic browser installation (`rfbrowser init`) and database initialization
- Test reports accessible on host machine via volume mount

### Development Workflow

The `docker-compose.override.yml` file is included and automatically mounts source files for hot-reload. Changes to test code are reflected immediately without rebuilding the Docker image.

```yaml
# docker-compose.override.yml (already included)
services:
  robot-tests:
    volumes:
      - ./tests:/app/tests
      - ./resources:/app/resources
      - ./init_db.py:/app/init_db.py
```

**Benefits:**
- Fast iteration during development
- No rebuild needed when changing tests
- CI pipelines can use pre-built images via `image: adbros-demo:latest`

## Project Notes

- **Language**: All tests are written in English
- **Architecture**: Three-layer separation (UI, API, DB) with strict object modeling
- **UI Automation**: Uses robotframework-browser (Playwright), not SeleniumLibrary
- **Selectors**: Prefers `data-test` attributes when available (SauceDemo.com)
- **Database**: Initialized via `init_db.py` during Docker build from Fake Store API
- **Reports**: Generated in `reports/` directory with screenshots on failure
- **Hot-Reload**: Use `docker-compose.override.yml` for development without rebuilds

## License

This is a demo project for showcasing test automation skills.
