*** Settings ***
Documentation     Common keywords shared across all test suites
Library           Browser
Resource          ../config/config.resource

*** Keywords ***
Setup Browser Context
    [Documentation]    Set up browser context for tests
    [Arguments]    ${headless}=${HEADLESS}
    New Browser    ${BROWSER}    headless=${headless}
    New Context    viewport={'width': ${VIEWPORT_WIDTH}, 'height': ${VIEWPORT_HEIGHT}}

Teardown Browser Context
    [Documentation]    Tear down browser context after tests
    Close Context
    Close Browser

Login To Application
    [Documentation]    Login to SauceDemo application
    [Arguments]    ${username}=standard_user    ${password}=secret_sauce
    New Page    ${BASE_URL}
    Fill Text    data-test=username    ${username}
    Fill Secret    data-test=password    ${password}
    Click    data-test=login-button
    Wait For Load State    networkidle

Generate Random User Data
    [Documentation]    Generate random user data for checkout
    ${first_name}=    Set Variable    Test
    ${last_name}=    Set Variable    User${RANDOM}
    ${postal_code}=    Set Variable    ${RANDOM}
    RETURN    ${first_name}    ${last_name}    ${postal_code}

Clean Cart If Needed
    [Documentation]    Remove all items from cart if any exist
    TRY
        ${states}=    Get Element States    data-test=shopping-cart-badge
        Log    Cart badge exists, cleaning cart    console=True
        Click    data-test=shopping-cart-link
        ${items}=    Browser.Get Element Count    .cart_item
        Log    Found ${items} items to remove    console=True
        FOR    ${i}    IN RANGE    ${items}
            ${remove_buttons}=    Get Elements    [data-test^="remove-"]
            ${count}=    Get Length    ${remove_buttons}
            Log    Iteration ${i}: Found ${count} remove buttons    console=True
            IF    ${count} > 0
                Click    ${remove_buttons}[0]
                Log    Removed item ${i}    console=True
            END
        END
        Log    Cart cleaned, returning to inventory    console=True
        Go To    ${BASE_URL}/inventory.html
    EXCEPT    AS    ${err}
        Log    No cart badge found or cart already empty: ${err}    console=True
    END
