*** Settings ***
Documentation     Users API endpoint object with error handling
Resource          base_endpoint.resource
Resource          ../locators/endpoints.resource

*** Keywords ***
Get All Users
    [Documentation]    Get all users from Fake Store API
    ${items}=    _Get All Items From Endpoint    ${USERS_ENDPOINT}    users
    RETURN    ${items}

Get User By ID
    [Documentation]    Get user by ID from Fake Store API
    [Arguments]    ${id}
    ${item}=    _Get Item By Id From Endpoint    ${USERS_ENDPOINT}    user    ${id}
    RETURN    ${item}
