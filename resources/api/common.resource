*** Settings ***
Documentation     Common resource file for API tests - imports all endpoint objects
Resource          ${EXECDIR}/resources/config/config.resource
Resource          ${EXECDIR}/resources/config/test_data.resource
Resource          keywords/base_endpoint.resource
Resource          keywords/products_endpoint.resource
Resource          keywords/users_endpoint.resource
Resource          keywords/carts_endpoint.resource
Resource          locators/endpoints.resource

*** Keywords ***
Setup API Session
    [Documentation]    Set up API session for tests
    Create API Session

Teardown API Session
    [Documentation]    Tear down API session after tests
    Delete All Sessions
