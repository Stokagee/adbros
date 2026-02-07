*** Settings ***
Documentation     Central configuration for all tests

*** Variables ***
# Application URLs
${BASE_URL}               https://www.saucedemo.com
${FAKESTORE_API_URL}      https://fakestoreapi.com

# Database Configuration
${DB_PATH}                ${EXECDIR}${/}resources${/}test_database.db
${DB_API}                 sqlite3

# Browser Configuration
${BROWSER}                chromium
${HEADLESS}               ${True}
${VIEWPORT_WIDTH}         1920
${VIEWPORT_HEIGHT}        1080

# Timeouts
${DEFAULT_TIMEOUT}        10s
${PAGE_LOAD_TIMEOUT}      30s
${ELEMENT_TIMEOUT}        5s

# Logging Configuration
${LOG_TO_CONSOLE}        ${False}
