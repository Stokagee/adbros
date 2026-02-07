*** Settings ***
Documentation     Page object for navigation and header elements
Library           Browser
Library           BuiltIn
Library           String
Library           Collections
Resource          base_page.resource
Resource          ../locators/navigation_page.resource
Resource          ../locators/shared_locators.resource

*** Keywords ***
Open Cart
    [Documentation]    Navigate to shopping cart with error handling
    TRY
        Click Element    ${CART_LINK}    context= (cart link)
        Log    Opened cart    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to open cart | Error: ${err}
    END

Get Cart Badge Count
    [Documentation]    Get the number displayed on cart badge with error handling
    TRY
        ${states}=    Get Element States    ${CART_BADGE}
        ${count}=    Get Element Text Content    ${CART_BADGE}
        Log    Cart badge count: ${count}    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Log    Cart badge not found, returning 0    console=True
        RETURN    ${0}
    END

Click Menu Button
    [Documentation]    Open the side menu with error handling
    TRY
        Click Element    ${MENU_BUTTON}    context= (menu button)
        Log    Clicked menu button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click menu button | Error: ${err}
    END

Logout
    [Documentation]    Logout from the application with error handling
    TRY
        Click Menu Button
        VAR    ${logout_link}    data-test=logout-sidebar-link
        Wait For Element Visible    ${logout_link}
        Click Element    ${logout_link}    context= (logout link)
        Log    Logged out    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to logout | Error: ${err}
    END

Get Current URL
    [Documentation]    Get the current page URL with error handling
    TRY
        ${url}=    Get Url
        Log    Current URL: ${url}    console=True
        RETURN    ${url}
    EXCEPT    AS    ${err}
        Fail    Failed to get current URL | Error: ${err}
    END

Verify On Inventory Page
    [Documentation]    Verify currently on inventory page with error handling
    TRY
        ${url}=    Get Current URL
        Should Contain    ${url}    inventory.html
        Log    Verified on inventory page    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify on inventory page | Error: ${err}
    END

Verify On Cart Page
    [Documentation]    Verify currently on cart page with error handling
    TRY
        ${url}=    Get Current URL
        Should Contain    ${url}    cart.html
        Log    Verified on cart page    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify on cart page | Error: ${err}
    END

Navigate To Inventory
    [Documentation]    Navigate to inventory page with error handling
    TRY
        Go To    ${INVENTORY_URL}
        Wait For Page Load
        Log    Navigated to inventory page    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to navigate to inventory | URL: ${INVENTORY_URL} | Error: ${err}
    END

Navigate To Cart
    [Documentation]    Navigate to cart page with error handling
    TRY
        Go To    ${CART_URL}
        Wait For Page Load
        Log    Navigated to cart page    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to navigate to cart | URL: ${CART_URL} | Error: ${err}
    END
