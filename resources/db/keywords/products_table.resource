*** Settings ***
Documentation     Products table object with error handling
Resource          base_table.resource
Resource          ../locators/tables.resource

*** Keywords ***
Get Product By ID
    [Documentation]    Get product by ID from database with error handling and dictionary return
    [Arguments]    ${product_id}
    VAR    ${sql}    SELECT title, price, category FROM products WHERE id = ${product_id}
    TRY
        Log    Getting product by ID: ${product_id}    console=${LOG_TO_CONSOLE}
        @{row}=    Query    ${sql}
        Should Not Be Empty    ${row}    msg=Product ID ${product_id} not found
        # Destructuring unpack for safe column access (Set Variable kept for destructuring)
        ${title}    ${price}    ${category}=    Set Variable    @{row}[0]
        ${price_num}=    Convert To Number    ${price}
        &{product}=    Create Dictionary    id=${product_id}    title=${title}    price=${price_num}    category=${category}
        Log    Found product: ${title} ($${price_num})    console=${LOG_TO_CONSOLE}
        RETURN    &{product}
    EXCEPT    AS    ${err}
        Fail    Get Product By ID failed | Product ID: ${product_id} | Error: ${err}
    END

Get Product Count
    [Documentation]    Get total number of products in database
    ${count}=    _Get Table Item Count    products
    RETURN    ${count}

Verify Product Exists
    [Documentation]    Verify product with given ID exists with error handling
    [Arguments]    ${product_id}
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM products WHERE id = ${product_id}
        Should Be True    ${count} > 0
        Log    Product ${product_id} exists    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to verify product exists | Product ID: ${product_id} | Error: ${err}
    END
