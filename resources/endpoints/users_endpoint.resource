*** Settings ***
Documentation     Users API endpoint object with error handling
Library           RequestsLibrary
Library           BuiltIn
Library           Collections
Resource          base_endpoint.resource

*** Variables ***
${USERS_ENDPOINT}    /users

*** Keywords ***
Get All Users
    [Documentation]    Get all users from API with error handling
    TRY
        ${response}=    Send GET Request    ${USERS_ENDPOINT}
        ${users}=    Set Variable    ${response.json()}
        Should Not Be Empty    ${users}
        ${count}=    Get Length    ${users}
        Log    Got ${count} users    console=True
        RETURN    ${users}
    EXCEPT    AS    ${err}
        Fail    Failed to get all users | Endpoint: ${USERS_ENDPOINT} | Error: ${err}
    END

Get User By ID
    [Documentation]    Get specific user by ID with error handling
    [Arguments]    ${user_id}
    TRY
        ${response}=    Send GET Request    ${USERS_ENDPOINT}/${user_id}
        ${user}=    Set Variable    ${response.json()}
        Should Be Equal As Numbers    ${user}[id]    ${user_id}
        Log    Got user: ${user}[id] - ${user}[username]    console=True
        RETURN    ${user}
    EXCEPT    AS    ${err}
        Fail    Failed to get user by ID | User ID: ${user_id} | Error: ${err}
    END
