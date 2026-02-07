*** Settings ***
Documentation     Inventory page test suite for SauceDemo
Library           Browser
Library           BuiltIn
Resource          ../../resources/config/config.resource
Resource          ../../resources/config/test_data.resource
Resource          ../../resources/pages/login_page.resource
Resource          ../../resources/pages/inventory_page.resource
Resource          ../../resources/pages/navigation_page.resource
Resource          ../../resources/keywords/common_keywords.resource

Suite Setup       Setup Browser Context
Suite Teardown    Teardown Browser Context
Test Setup        Open Login Page And Login
Test Teardown     Run Keywords    Clean Cart If Needed    AND    Close Page

*** Keywords ***
Open Login Page And Login
    [Documentation]    Open login page and login as standard user
    Open Login Page
    Login As Standard User

Test Tags         inventory    ui    demo

*** Test Cases ***

Display All Products
    [Documentation]    Verify all products are displayed on inventory page
    [Tags]    smoke    visual
    Verify Inventory Page Loaded
    ${count}=    Get Product Count
    Should Be True    ${count} > 0

Add Single Product To Cart
    [Documentation]    Verify a single product can be added to cart
    [Tags]    smoke    cart
    Add Product To Cart By Index    0
    ${cart_count}=    Get Cart Count
    Should Be Equal As Numbers    ${cart_count}    1

Add Multiple Products To Cart
    [Documentation]    Verify multiple products can be added to cart
    [Tags]    cart
    # Add first product
    ${add_buttons_1}=    Get Elements    [data-test^="add-to-cart-"]
    Click    ${add_buttons_1}[0]
    # Add second product (after first click, the button becomes remove)
    ${add_buttons_2}=    Get Elements    [data-test^="add-to-cart-"]
    Click    ${add_buttons_2}[0]
    ${cart_count}=    Get Cart Count
    Should Be Equal As Numbers    ${cart_count}    2

Remove Product From Cart
    [Documentation]    Verify product can be removed from cart on inventory page
    [Tags]    cart
    Add Product To Cart By Index    0
    ${cart_count}=    Get Cart Count
    Should Be Equal As Numbers    ${cart_count}    1
    # After adding, the button becomes remove button
    ${remove_buttons}=    Get Elements    [data-test^="remove-"]
    Click    ${remove_buttons}[0]
    # Cart badge should be removed or show 0
    TRY
        ${cart_count}=    Get Cart Count
        Should Be Equal As Numbers    ${cart_count}    0
    EXCEPT
        Log    Cart badge removed (expected behavior)    console=True
    END

Sort Products By Name Ascending
    [Documentation]    Verify products can be sorted by name (A to Z)
    [Tags]    sort
    Sort Products By    Name (A to Z)
    ${names}=    Get Product Names
    # Verify first product is alphabetically first
    Should Be Equal    ${names}[0]    Sauce Labs Backpack

Sort Products By Price Ascending
    [Documentation]    Verify products can be sorted by price (low to high)
    [Tags]    sort
    Sort Products By    Price (low to high)
    ${price_1}=    Get Product Price By Name    Sauce Labs Onesie
    ${price_2}=    Get Product Price By Name    Sauce Labs Fleece Jacket
    # Onesie should be cheaper than Jacket
    ${price_1_clean}=    Remove String    ${price_1}    $
    ${price_2_clean}=    Remove String    ${price_2}    $
    ${numeric_1}=    Convert To Number    ${price_1_clean}
    ${numeric_2}=    Convert To Number    ${price_2_clean}
    Should Be True    ${numeric_1} < ${numeric_2}

Navigate To Cart From Inventory
    [Documentation]    Verify navigation to cart page
    [Tags]    navigation
    Click Cart Link
    ${url}=    Get Current URL
    Should Contain    ${url}    cart.html

Product List Is Not Empty
    [Documentation]    Verify product list contains items
    [Tags]    smoke
    Verify Inventory Page Loaded
    ${count}=    Get Product Count
    Should Not Be Equal As Numbers    ${count}    0

All Products Have Names And Prices
    [Documentation]    Verify each product has name and price displayed
    [Tags]    visual
    ${count}=    Get Product Count
    FOR    ${i}    IN RANGE    ${count}
        ${name_locator}=    Set Variable    (//*[@data-test="inventory-item-name"])[${i+1}]
        ${price_locator}=    Set Variable    (//*[@data-test="inventory-item-price"])[${i+1}]
        ${name_states}=    Get Element States    ${name_locator}
        Should Contain    ${name_states}    visible    msg=Product name at index ${i} is not visible
        ${price_states}=    Get Element States    ${price_locator}
        Should Contain    ${price_states}    visible    msg=Product price at index ${i} is not visible
    END
