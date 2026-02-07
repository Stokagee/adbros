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
./run_tests.sh
```

**Windows:**
```batch
run_tests.bat
```

Or manually:
```bash
docker-compose up --build
```

### View Results
After tests complete, open:
- `reports/report.html` - Test execution summary
- `reports/log.html` - Detailed test logs

## Project Structure

```
adbros/
├── Dockerfile                  # Docker image definition
├── docker-compose.yml          # Service configuration
├── requirements.txt            # Python dependencies
├── run_tests.sh/.bat           # Startup scripts
├── init_db.py                  # Database initialization
├── pages/                      # Page Object Model
│   ├── base_page.robot        # Common page methods
│   ├── login_page.robot       # Login page objects
│   ├── inventory_page.robot   # Products page objects
│   ├── cart_page.robot        # Cart page objects
│   ├── checkout_page.robot    # Checkout page objects
│   └── navigation_page.robot  # Navigation elements
├── tests/                      # Test suites
│   ├── common/                # Shared keywords
│   ├── ui/                    # UI tests (SauceDemo)
│   ├── api/                   # API tests (Fake Store)
│   └── db/                    # Database tests
└── resources/                  # Test data and config
```

## Test Suites

### UI Tests (SauceDemo.com)
- **Login Tests**: Authentication, validation, error handling
- **Inventory Tests**: Product listing, sorting, cart operations
- **Cart Tests**: Cart management, item removal
- **Checkout Tests**: Complete purchase flow

### API Tests (Fake Store API)
- Product retrieval and validation
- User data verification
- Cart operations
- Filtering and sorting

### Database Tests (SQLite)
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

- **Robot Framework** 6.1+ - Test automation framework
- **Robot Framework Browser** 18.0+ - Modern Playwright-based UI automation
- **RequestsLibrary** - API testing
- **DatabaseLibrary** - Database operations
- **Python** 3.11 - Runtime environment
- **Docker** - Containerization

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

## Page Object Model

This project strictly follows the Page Object Model pattern:
- Each page has a dedicated `.robot` file in `pages/`
- Page objects contain locators and keywords for page interactions
- Test files use page objects, not direct selectors
- Promotes code reusability and maintainability

## Docker Containerization

The project includes complete Docker setup:
- `Dockerfile`: Python 3.11 with Playwright browser support
- `docker-compose.yml`: Service configuration with volume mounting
- Automatic browser installation and database initialization
- Test reports accessible on host machine

## Notes

- All tests are written in English
- Page Object Model pattern is strictly followed
- robotframework-browser (Playwright) is used for UI automation
- SQLite database is automatically initialized from Fake Store API
- Reports are generated in the `reports/` directory

## License

This is a demo project for showcasing test automation skills.
