*** Settings ***
Documentation     Carts API endpoint object with error handling
Resource          base_endpoint.resource
Resource          ../locators/endpoints.resource

*** Keywords ***
Get All Carts
    [Documentation]    Get all carts from Fake Store API
    ${items}=    _Get All Items From Endpoint    ${CARTS_ENDPOINT}    carts
    RETURN    ${items}

Get Cart By ID
    [Documentation]    Get cart by ID from Fake Store API
    [Arguments]    ${id}
    ${item}=    _Get Item By Id From Endpoint    ${CARTS_ENDPOINT}    cart    ${id}
    RETURN    ${item}

Get Carts By User
    [Documentation]    Get carts filtered by user ID with error handling
    [Arguments]    ${user_id}
    TRY
        ${response}=    Send GET Request    ${CARTS_ENDPOINT}/user/${user_id}
        VAR    ${carts}    ${response.json()}
        ${count}=    Get Length    ${carts}
        Log    Got ${count} carts for user: ${user_id}    console=${LOG_TO_CONSOLE}
        RETURN    ${carts}
    EXCEPT    AS    ${err}
        Fail    Failed to get carts by user | User ID: ${user_id} | Error: ${err}
    END
