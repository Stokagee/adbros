*** Settings ***
Documentation     Carts API endpoint object with error handling
Library           RequestsLibrary
Library           BuiltIn
Library           Collections
Resource          base_endpoint.resource

*** Variables ***
${CARTS_ENDPOINT}    /carts

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
        Log    Got ${count} carts for user: ${user_id}    console=True
        RETURN    ${carts}
    EXCEPT    AS    ${err}
        Fail    Failed to get carts by user | User ID: ${user_id} | Error: ${err}
    END
