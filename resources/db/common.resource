*** Settings ***
Documentation     Common resource file for database tests - imports all table objects
Resource          ${EXECDIR}/resources/config/config.resource
Resource          keywords/base_table.resource
Resource          keywords/products_table.resource
Resource          keywords/users_table.resource
Resource          keywords/carts_table.resource
Resource          keywords/database_keywords.resource
Resource          locators/tables.resource

*** Keywords ***
Setup Test Database
    [Documentation]    Set up test database with schema and sample data
    Initialize Test Database

Teardown Test Database
    [Documentation]    Tear down test database connection
    [Arguments]    ${db_path}=${DB_PATH}
    Disconnect From Test Database
