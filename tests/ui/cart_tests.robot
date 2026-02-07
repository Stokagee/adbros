*** Settings ***
Documentation     Shopping cart test suite for SauceDemo
Library           Browser
Library           BuiltIn
Resource          ../../resources/ui/common.resource

Suite Setup       Setup Browser Context
Suite Teardown    Teardown Browser Context
Test Setup        Setup Cart Test
Test Teardown     Run Keywords    Clean Cart If Needed    AND    Close Page

Test Tags         cart    ui    demo

*** Keywords ***
Setup Cart Test
    [Documentation]    Setup for cart tests - login and add item to cart
    Open Login Page
    Login As Standard User
    Add Product To Cart By Index    0
    Click Cart Link

*** Test Cases ***

Cart Shows Added Items
    [Documentation]    Verify cart displays added items
    [Tags]    smoke
    Verify Cart Page Loaded
    ${count}=    Get Cart Items Count
    Should Be Equal As Numbers    ${count}    1

Remove Item From Cart
    [Documentation]    Verify items can be removed from cart
    [Tags]    cart
    Verify Cart Page Loaded
    ${count_before}=    Get Cart Items Count
    Remove Item From Cart By Name    Sauce Labs Backpack
    ${count_after}=    Get Cart Items Count
    Should Be True    ${count_before} > ${count_after}

Continue Shopping Returns To Inventory
    [Documentation]    Verify continue shopping button returns to inventory
    [Tags]    navigation
    Click Continue Shopping
    Verify On Inventory Page

Cart Empty Initially
    [Documentation]    Verify cart is empty when no items added
    [Tags]    smoke
    [Setup]    Open Login Page And Login
    Click Cart Link
    Verify Cart Empty

Multiple Items In Cart
    [Documentation]    Verify multiple items can be in cart
    [Tags]    cart
    [Setup]    Setup Multiple Items
    Verify Cart Page Loaded
    ${count}=    Get Cart Items Count
    Should Be Equal As Numbers    ${count}    2

Cart Items Display Correct Names
    [Documentation]    Verify cart items show correct product names
    [Tags]    visual
    Verify Cart Page Loaded
    ${names}=    Get Cart Item Names
    Should Not Be Empty    ${names}
    List Should Contain Value    ${names}    Sauce Labs Backpack

Cart Badge Updates Correctly
    [Documentation]    Verify cart badge shows correct item count
    [Tags]    visual
    [Setup]    Setup Multiple Items
    ${badge_count}=    Get Cart Badge Count
    Should Be Equal As Numbers    ${badge_count}    2

*** Keywords ***
Setup Multiple Items
    [Documentation]    Setup test with multiple cart items
    Open Login Page
    Login As Standard User
    Add Product To Cart By Index    0
    Add Product To Cart By Index    1
    Click Cart Link
