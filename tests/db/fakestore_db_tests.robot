*** Settings ***
Documentation     Database test suite for Fake Store API data
Library           DatabaseLibrary
Library           Collections
Library           OperatingSystem
Resource          ../../resources/config/config.resource
Resource          ../../resources/config/test_data.resource
Resource          ../../resources/tables/base_table.resource
Resource          ../../resources/tables/products_table.resource
Resource          ../../resources/tables/users_table.resource
Resource          ../../resources/tables/carts_table.resource
Resource          ../../resources/keywords/database_keywords.resource

Suite Setup       Initialize Test Database
Suite Teardown    Disconnect From Test Database

Test Tags         db    demo

*** Test Cases ***

Verify Database File Exists
    [Documentation]    Verify database file was created
    [Tags]    smoke
    Verify Database Exists

Verify Product Count In Database
    [Documentation]    Verify products table has data
    [Tags]    smoke    regression
    ${count}=    Get Product Count
    Should Be True    ${count} > 0
    Log    Found ${count} products in database    console=True

Verify Product Details In Database
    [Documentation]    Verify specific product details are stored correctly
    [Tags]    regression
    &{product}=    Get Product By ID    1
    Should Contain    ${product}[title]    Fjallraven
    Should Be Equal As Numbers    ${product}[price]    109.95
    Should Be Equal    ${product}[category]    men's clothing
    Log    Product verified: ${product}[title] ($${product}[price])    console=True

Verify Product Exists
    [Documentation]    Verify product lookup by ID works
    [Tags]    regression
    Verify Product Exists    1

Verify User Data In Database
    [Documentation]    Verify users table has data
    [Tags]    regression
    ${count}=    Get User Count
    Should Be True    ${count} > 0
    Log    Found ${count} users in database    console=True

Verify User By ID
    [Documentation]    Verify user lookup by ID works
    [Tags]    regression
    &{user}=    Get User By ID    1
    Should Be Equal    ${user}[email]    john@example.com
    Log    User verified: ${user}[username]    console=True

Verify Cart Data In Database
    [Documentation]    Verify carts table has data
    [Tags]    regression
    ${count}=    Get Cart Count
    Should Be True    ${count} > 0
    Log    Found ${count} carts in database    console=True

Verify Cart By ID
    [Documentation]    Verify cart lookup by ID works
    [Tags]    regression
    &{cart}=    Get Cart By ID    1
    Should Be Equal As Numbers    ${cart}[user_id]    1
    Log    Cart verified: ${cart}[id] for user ${cart}[user_id]    console=True

Verify Products Table Has Data
    [Documentation]    Verify products table is populated
    [Tags]    smoke    regression
    Table Must Contain Data    products

Verify Users Table Has Data
    [Documentation]    Verify users table is populated
    [Tags]    smoke    regression
    Table Must Contain Data    users

Verify Carts Table Has Data
    [Documentation]    Verify carts table is populated
    [Tags]    smoke    regression
    Table Must Contain Data    carts
