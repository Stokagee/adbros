*** Settings ***
Documentation     Users table object with error handling
Library           DatabaseLibrary
Library           BuiltIn
Library           Collections
Resource          base_table.resource

*** Keywords ***
Get User By ID
    [Documentation]    Get user by ID from database with error handling and dictionary return
    [Arguments]    ${user_id}
    ${sql}=    Set Variable    SELECT email, username, name FROM users WHERE id = ${user_id}
    TRY
        Log    Getting user by ID: ${user_id}    console=True
        @{row}=    Query    ${sql}
        Should Not Be Empty    ${row}    msg=User ID ${user_id} not found
        # Destructuring unpack for safe column access
        ${email}    ${username}    ${name}=    Set Variable    @{row}[0]
        &{user}=    Create Dictionary    id=${user_id}    email=${email}    username=${username}    name=${name}
        Log    Found user: ${username} (${email})    console=True
        RETURN    &{user}
    EXCEPT    AS    ${err}
        Fail    Get User By ID failed | User ID: ${user_id} | Error: ${err}
    END

Get User Count
    [Documentation]    Get total number of users with error handling
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM users
        Log    User count: ${count}    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get user count | Error: ${err}
    END

Verify User Exists
    [Documentation]    Verify user with given ID exists with error handling
    [Arguments]    ${user_id}
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM users WHERE id = ${user_id}
        Should Be True    ${count} > 0
        Log    User ${user_id} exists    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify user exists | User ID: ${user_id} | Error: ${err}
    END
