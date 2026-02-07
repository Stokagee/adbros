*** Settings ***
Documentation     Page object for SauceDemo inventory/products page
Library           Browser
Library           BuiltIn
Library           String
Library           Collections
Resource          base_page.resource

*** Variables ***
${PRODUCT_LIST}    .inventory_list
${PRODUCT_ITEM}    .inventory_item
${PRODUCT_NAME}    data-test=inventory-item-name
${PRODUCT_PRICE}    data-test=inventory-item-price
${ADD_TO_CART_BTN}    data-test=add-to-cart-
${REMOVE_BTN}    data-test=remove-
${CART_LINK}    data-test=shopping-cart-link
${CART_BADGE}    data-test=shopping-cart-badge
${SORT_DROPDOWN}    data-test=product-sort-container
${MENU_BUTTON}    data-test=react-burger-menu-btn

*** Keywords ***
Verify Inventory Page Loaded
    [Documentation]    Verify inventory page is loaded and visible with error handling
    TRY
        Wait For Element Visible    ${PRODUCT_LIST}
        ${url}=    Get Url
        Should Contain    ${url}    inventory.html
        Log    Inventory page loaded    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify inventory page loaded | Error: ${err}
    END

Get Product List
    [Documentation]    Get list of all products on the page with error handling
    TRY
        ${products}=    Get Elements    ${PRODUCT_ITEM}
        Log    Got product list    console=True
        RETURN    @{products}
    EXCEPT    AS    ${err}
        Fail    Failed to get product list | Error: ${err}
    END

Get Product Count
    [Documentation]    Get the number of products displayed with error handling
    TRY
        ${count}=    Get Element Count    ${PRODUCT_ITEM}
        Log    Product count: ${count}    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get product count | Error: ${err}
    END

Add Product To Cart By Name
    [Documentation]    Add product to cart by its name with error handling
    [Arguments]    ${product_name}
    TRY
        ${normalized}=    Normalize Product Name    ${product_name}
        ${add_button}=    Set Variable    ${ADD_TO_CART_BTN}${normalized}
        Click Element    ${add_button}    context= (add ${product_name})
        Log    Added product to cart: ${product_name}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to add product to cart | Product: ${product_name} | Error: ${err}
    END

Add Product To Cart By Index
    [Documentation]    Add product to cart by its index (0-based) with error handling
    [Arguments]    ${index}
    TRY
        ${add_buttons}=    Get Elements    [data-test^="add-to-cart-"]
        ${count}=    Get Length    ${add_buttons}
        Should Be True    ${count} > 0    msg=No add-to-cart buttons found
        Should Be True    ${index} < ${count}    msg=Index ${index} out of range (count: ${count})
        ${button}=    Set Variable    ${add_buttons}[${index}]
        Click    ${button}
        Log    Added product at index ${index} to cart    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to add product at index ${index} | Error: ${err}
    END

Remove Product From Cart By Name
    [Documentation]    Remove product from cart by its name with error handling
    [Arguments]    ${product_name}
    TRY
        ${normalized}=    Normalize Product Name    ${product_name}
        ${remove_button}=    Set Variable    ${REMOVE_BTN}${normalized}
        Click Element    ${remove_button}    context= (remove ${product_name})
        Log    Removed product from cart: ${product_name}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to remove product from cart | Product: ${product_name} | Error: ${err}
    END

Get Product Price By Name
    [Documentation]    Get the price of a specific product with error handling
    [Arguments]    ${product_name}
    TRY
        ${price_locator}=    Set Variable    //*[contains(@data-test, "inventory-item-name") and text()="${product_name}"]/../..//*[@data-test="inventory-item-price"]
        ${price_text}=    Get Element Text Content    ${price_locator}
        Log    Got price for ${product_name}: ${price_text}    console=True
        RETURN    ${price_text}
    EXCEPT    AS    ${err}
        Fail    Failed to get product price | Product: ${product_name} | Error: ${err}
    END

Get Cart Count
    [Documentation]    Get the number of items in the cart with error handling
    TRY
        ${count}=    Get Element Count    ${CART_BADGE}
        Log    Cart count: ${count}    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get cart count | Error: ${err}
    END

Click Cart Link
    [Documentation]    Click on the shopping cart link with error handling
    TRY
        Click Element    ${CART_LINK}    context= (cart link)
        Log    Clicked cart link    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click cart link | Error: ${err}
    END

Sort Products By
    [Documentation]    Sort products by selected option with error handling
    [Arguments]    ${sort_option}
    TRY
        Select Options By    ${SORT_DROPDOWN}    label    ${sort_option}
        Log    Sorted products by: ${sort_option}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to sort products | Option: ${sort_option} | Error: ${err}
    END

Get Product Names
    [Documentation]    Get list of all product names with error handling
    TRY
        ${names}=    Get Elements    ${PRODUCT_NAME}
        @{product_names}=    Create List
        FOR    ${name_element}    IN    @{names}
            ${text}=    Get Text    ${name_element}
            Append To List    ${product_names}    ${text}
        END
        ${count}=    Get Length    ${product_names}
        Log    Got ${count} product names    console=True
        RETURN    @{product_names}
    EXCEPT    AS    ${err}
        Fail    Failed to get product names | Error: ${err}
    END

Verify Product Displayed
    [Documentation]    Verify a specific product is displayed with error handling
    [Arguments]    ${product_name}
    TRY
        ${product_locator}=    Set Variable    //*[contains(@data-test, "inventory-item-name") and text()="${product_name}"]
        Element Should Be Visible    ${product_locator}
        Log    Product displayed: ${product_name}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify product displayed | Product: ${product_name} | Error: ${err}
    END

Normalize Product Name
    [Documentation]    Normalize product name to match data-test attribute format with error handling
    [Arguments]    ${name}
    TRY
        ${normalized}=    Convert To Lower Case    ${name}
        ${normalized}=    Replace String    ${normalized}    ${SPACE}    -
        RETURN    ${normalized}
    EXCEPT    AS    ${err}
        Fail    Failed to normalize product name | Name: ${name} | Error: ${err}
    END
