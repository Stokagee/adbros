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
    [Documentation]    Get all carts from API with error handling
    TRY
        ${response}=    Send GET Request    ${CARTS_ENDPOINT}
        ${carts}=    Set Variable    ${response.json()}
        Should Not Be Empty    ${carts}
        ${count}=    Get Length    ${carts}
        Log    Got ${count} carts    console=True
        RETURN    ${carts}
    EXCEPT    AS    ${err}
        Fail    Failed to get all carts | Endpoint: ${CARTS_ENDPOINT} | Error: ${err}
    END

Get Cart By ID
    [Documentation]    Get specific cart by ID with error handling
    [Arguments]    ${cart_id}
    TRY
        ${response}=    Send GET Request    ${CARTS_ENDPOINT}/${cart_id}
        ${cart}=    Set Variable    ${response.json()}
        Should Be Equal As Numbers    ${cart}[id]    ${cart_id}
        Log    Got cart: ${cart}[id]    console=True
        RETURN    ${cart}
    EXCEPT    AS    ${err}
        Fail    Failed to get cart by ID | Cart ID: ${cart_id} | Error: ${err}
    END

Get Carts By User
    [Documentation]    Get carts filtered by user ID with error handling
    [Arguments]    ${user_id}
    TRY
        ${response}=    Send GET Request    ${CARTS_ENDPOINT}/user/${user_id}
        ${carts}=    Set Variable    ${response.json()}
        ${count}=    Get Length    ${carts}
        Log    Got ${count} carts for user: ${user_id}    console=True
        RETURN    ${carts}
    EXCEPT    AS    ${err}
        Fail    Failed to get carts by user | User ID: ${user_id} | Error: ${err}
    END
