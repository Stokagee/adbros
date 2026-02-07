*** Settings ***
Documentation     Page object for SauceDemo shopping cart page
Library           Browser
Library           BuiltIn
Library           String
Library           Collections
Resource          base_page.resource

*** Variables ***
${CART_LIST}    .cart_list
${CART_ITEM}    .cart_item
${CART_ITEM_NAME}    data-test=inventory-item-name
${CART_ITEM_PRICE}    data-test=inventory-item-price
${CHECKOUT_BUTTON}    data-test=checkout
${CONTINUE_SHOPPING_BUTTON}    data-test=continue-shopping
${REMOVE_BUTTON}    data-test=remove-
${CART_QUANTITY}    data-test=item-quantity

*** Keywords ***
Verify Cart Page Loaded
    [Documentation]    Verify cart page is loaded with error handling
    TRY
        Wait For Page Load
        ${url}=    Get Url
        Should Contain    ${url}    cart.html
        Log    Cart page loaded    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify cart page loaded | Error: ${err}
    END

Get Cart Items Count
    [Documentation]    Get the number of items in the cart with error handling
    TRY
        ${count}=    Get Element Count    ${CART_ITEM}
        Log    Cart items count: ${count}    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get cart items count | Error: ${err}
    END

Get Cart Item Names
    [Documentation]    Get list of all item names in the cart with error handling
    TRY
        ${name_elements}=    Get Elements    ${CART_ITEM_NAME}
        @{names}=    Create List
        FOR    ${element}    IN    @{name_elements}
            ${text}=    Get Text    ${element}
            Append To List    ${names}    ${text}
        END
        Log    Cart items: ${names}    console=True
        RETURN    @{names}
    EXCEPT    AS    ${err}
        Fail    Failed to get cart item names | Error: ${err}
    END

Get Cart Item Quantities
    [Documentation]    Get list of all item quantities in the cart with error handling
    TRY
        ${quantity_elements}=    Get Elements    ${CART_QUANTITY}
        @{quantities}=    Create List
        FOR    ${element}    IN    @{quantity_elements}
            ${text}=    Get Text    ${element}
            Append To List    ${quantities}    ${text}
        END
        Log    Cart quantities: ${quantities}    console=True
        RETURN    @{quantities}
    EXCEPT    AS    ${err}
        Fail    Failed to get cart item quantities | Error: ${err}
    END

Remove Item From Cart By Name
    [Documentation]    Remove item from cart by its name with error handling
    [Arguments]    ${item_name}
    TRY
        ${normalized}=    Normalize Item Name    ${item_name}
        ${remove_button}=    Set Variable    ${REMOVE_BUTTON}${normalized}
        Click Element    ${remove_button}    context= (remove ${item_name})
        Log    Removed item from cart: ${item_name}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to remove item from cart | Item: ${item_name} | Error: ${err}
    END

Click Checkout Button
    [Documentation]    Click the checkout button to proceed with error handling
    TRY
        Click Element    ${CHECKOUT_BUTTON}    context= (checkout button)
        Log    Clicked checkout button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click checkout button | Error: ${err}
    END

Click Continue Shopping
    [Documentation]    Click continue shopping to return to inventory with error handling
    TRY
        Click Element    ${CONTINUE_SHOPPING_BUTTON}    context= (continue shopping)
        Log    Clicked continue shopping    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click continue shopping | Error: ${err}
    END

Verify Item In Cart
    [Documentation]    Verify a specific item is in the cart with error handling
    [Arguments]    ${item_name}
    TRY
        ${item_locator}=    Set Variable    //*[contains(@data-test, "inventory-item-name") and text()="${item_name}"]
        Element Should Be Visible    ${item_locator}
        Log    Item verified in cart: ${item_name}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify item in cart | Item: ${item_name} | Error: ${err}
    END

Get Cart Total
    [Documentation]    Calculate and return the cart total with error handling
    TRY
        ${price_elements}=    Get Elements    ${CART_ITEM_PRICE}
        ${total}=    Set Variable    0
        FOR    ${price_element}    IN    @{price_elements}
            ${price_text}=    Get Text    ${price_element}
            ${price}=    Remove String    ${price_text}    $    ,
            ${total}=    Evaluate    ${total} + float(${price})
        END
        Log    Cart total: ${total}    console=True
        RETURN    ${total}
    EXCEPT    AS    ${err}
        Fail    Failed to calculate cart total | Error: ${err}
    END

Verify Cart Empty
    [Documentation]    Verify cart is empty with error handling
    TRY
        ${count}=    Get Cart Items Count
        Should Be Equal As Numbers    ${count}    0
        Log    Cart is empty    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify cart empty | Error: ${err}
    END

Normalize Item Name
    [Documentation]    Normalize item name to match data-test attribute with error handling
    [Arguments]    ${name}
    TRY
        ${normalized}=    Convert To Lower Case    ${name}
        ${normalized}=    Replace String    ${normalized}    ${SPACE}    -
        RETURN    ${normalized}
    EXCEPT    AS    ${err}
        Fail    Failed to normalize item name | Name: ${name} | Error: ${err}
    END
