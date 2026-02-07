*** Settings ***
Documentation     Checkout flow test suite for SauceDemo
Library           Browser
Library           BuiltIn
Resource          ../../resources/config/config.resource
Resource          ../../resources/config/test_data.resource
Resource          ../../resources/pages/login_page.resource
Resource          ../../resources/pages/inventory_page.resource
Resource          ../../resources/pages/cart_page.resource
Resource          ../../resources/pages/checkout_page.resource
Resource          ../../resources/pages/navigation_page.resource
Resource          ../../resources/keywords/common_keywords.resource

Suite Setup       Setup Browser Context
Suite Teardown    Teardown Browser Context
Test Setup        Setup Checkout Test
Test Teardown     Run Keywords    Clean Cart If Needed    AND    Close Page

Test Tags         checkout    ui    demo

*** Keywords ***
Setup Checkout Test
    [Documentation]    Setup for checkout tests - login, add item, go to cart
    Open Login Page
    Login As Standard User
    Add Product To Cart By Index    0
    Click Cart Link

*** Test Cases ***

Complete Checkout Flow
    [Documentation]    Verify complete checkout flow works end-to-end
    [Tags]    smoke    regression
    Click Checkout Button
    Verify Checkout Step One Loaded
    Fill Checkout Information    ${TEST_FIRST_NAME}    ${TEST_LAST_NAME}    ${TEST_POSTAL_CODE}
    Click Continue Button
    Verify Checkout Step Two Loaded
    Click Finish Button
    Verify Order Complete

Checkout Without First Name Shows Error
    [Documentation]    Verify error when first name is missing
    [Tags]    negative    validation
    Click Checkout Button
    Verify Checkout Step One Loaded
    Fill Text Input    data-test=lastName    ${TEST_LAST_NAME}
    Fill Text Input    data-test=postalCode    ${TEST_POSTAL_CODE}
    Click Continue Button
    Verify Checkout Error Displayed    Error: First Name is required

Checkout Without Last Name Shows Error
    [Documentation]    Verify error when last name is missing
    [Tags]    negative    validation
    Click Checkout Button
    Verify Checkout Step One Loaded
    Fill Text Input    data-test=firstName    ${TEST_FIRST_NAME}
    Fill Text Input    data-test=postalCode    ${TEST_POSTAL_CODE}
    Click Continue Button
    Verify Checkout Error Displayed    Error: Last Name is required

Checkout Without Postal Code Shows Error
    [Documentation]    Verify error when postal code is missing
    [Tags]    negative    validation
    Click Checkout Button
    Verify Checkout Step One Loaded
    Fill Text Input    data-test=firstName    ${TEST_FIRST_NAME}
    Fill Text Input    data-test=lastName    ${TEST_LAST_NAME}
    Click Continue Button
    Verify Checkout Error Displayed    Error: Postal Code is required

Cancel Checkout Returns To Cart
    [Documentation]    Verify cancel button returns to cart page
    [Tags]    navigation
    Click Checkout Button
    Verify Checkout Step One Loaded
    Click Cancel Button
    ${url}=    Get Current URL
    Should Contain    ${url}    cart.html

Order Summary Is Correct
    [Documentation]    Verify order summary shows correct information
    [Tags]    regression
    Click Checkout Button
    Fill Checkout Information    ${TEST_FIRST_NAME}    ${TEST_LAST_NAME}    ${TEST_POSTAL_CODE}
    Click Continue Button
    Verify Checkout Step Two Loaded
    ${item_total}=    Get Item Total
    Should Contain    ${item_total}    29.99

Back To Products After Order
    [Documentation]    Verify back to products button works after order completion
    [Tags]    navigation
    Complete Checkout Flow
    [Setup]    Setup Checkout Test
    Click Back Home Button
    Verify On Inventory Page

Thank You Message Displayed
    [Documentation]    Verify thank you message is displayed after order completion
    [Tags]    visual
    Click Checkout Button
    Fill Checkout Information    ${TEST_FIRST_NAME}    ${TEST_LAST_NAME}    ${TEST_POSTAL_CODE}
    Click Continue Button
    Click Finish Button
    ${message}=    Get Complete Message
    Should Contain    ${message}    Thank you

Cancel From Checkout Step Two Returns To Inventory
    [Documentation]    Verify cancel from step two returns to inventory (cancels order)
    [Tags]    navigation
    Click Checkout Button
    Fill Checkout Information    ${TEST_FIRST_NAME}    ${TEST_LAST_NAME}    ${TEST_POSTAL_CODE}
    Click Continue Button
    Click Element    data-test=cancel
    ${url}=    Get Current URL
    Should Contain    ${url}    inventory.html
