*** Settings ***
Documentation     Common keywords shared across all test suites
Library           Browser

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${HEADLESS}    ${True}
${BROWSER}    chromium

*** Keywords ***
Setup Browser Context
    [Documentation]    Set up browser context for tests
    [Arguments]    ${headless}=${HEADLESS}
    New Browser    ${BROWSER}    headless=${headless}
    New Context    viewport={'width': 1920, 'height': 1080}

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

Login As Standard User
    [Documentation]    Login as standard test user
    Login To Application    standard_user    secret_sauce

Generate Random User Data
    [Documentation]    Generate random user data for checkout
    ${first_name}=    Set Variable    Test
    ${last_name}=    Set Variable    User${RANDOM}
    ${postal_code}=    Set Variable    ${RANDOM}
    RETURN    ${first_name}    ${last_name}    ${postal_code}

Clean Cart If Needed
    [Documentation]    Remove all items from cart if any exist
    ${cart_exists}=    Does Element Exist    data-test=shopping-cart-badge
    IF    ${cart_exists}
        Click    data-test=shopping-cart-link
        ${items}=    Get Element Count    .cart_item
        FOR    ${i}    IN RANGE    ${items}
            ${remove_buttons}=    Get Elements    [data-test^="remove-"]
            IF    ${remove_buttons.__len__()} > 0
                Click    ${remove_buttons}[0]
            END
        END
        Go To    ${BASE_URL}/inventory.html
    END
