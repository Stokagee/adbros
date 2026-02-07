*** Settings ***
Documentation     Carts table object with error handling
Library           DatabaseLibrary
Library           Collections
Resource          base_table.resource
Resource          ../locators/tables.resource

*** Keywords ***
Get Cart By ID
    [Documentation]    Get cart by ID from database with error handling and dictionary return
    [Arguments]    ${cart_id}
    VAR    ${sql}    SELECT user_id, date, products FROM carts WHERE id = ${cart_id}
    TRY
        Log    Getting cart by ID: ${cart_id}    console=True
        @{row}=    Query    ${sql}
        Should Not Be Empty    ${row}    msg=Cart ID ${cart_id} not found
        # Destructuring unpack for safe column access (Set Variable kept for destructuring)
        ${user_id}    ${date}    ${products}=    Set Variable    @{row}[0]
        &{cart}=    Create Dictionary    id=${cart_id}    user_id=${user_id}    date=${date}    products=${products}
        Log    Found cart: ${cart_id} for user ${user_id}    console=True
        RETURN    &{cart}
    EXCEPT    AS    ${err}
        Fail    Get Cart By ID failed | Cart ID: ${cart_id} | Error: ${err}
    END

Get Cart Count
    [Documentation]    Get total number of carts in database
    ${count}=    _Get Table Item Count    carts
    RETURN    ${count}

Get Carts By User
    [Documentation]    Get all carts for a user with error handling
    [Arguments]    ${user_id}
    VAR    ${sql}    SELECT id, user_id, date, products FROM carts WHERE user_id = ${user_id}
    TRY
        Log    Getting carts for user: ${user_id}    console=True
        @{rows}=    Query    ${sql}
        @{carts}=    Create List
        FOR    ${row}    IN    @{rows}
            # Destructuring unpack for safe column access (Set Variable kept for destructuring)
            ${id}    ${uid}    ${date}    ${products}=    Set Variable    @{row}
            &{cart}=    Create Dictionary    id=${id}    user_id=${uid}    date=${date}    products=${products}
            Append To List    ${carts}    ${cart}
        END
        ${count}=    Get Length    ${carts}
        Log    Found ${count} carts for user ${user_id}    console=True
        RETURN    @{carts}
    EXCEPT    AS    ${err}
        Fail    Get Carts By User failed | User ID: ${user_id} | Error: ${err}
    END
