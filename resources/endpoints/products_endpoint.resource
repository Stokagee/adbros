*** Settings ***
Documentation     Products API endpoint object with error handling
Library           RequestsLibrary
Library           BuiltIn
Library           Collections
Resource          base_endpoint.resource

*** Variables ***
${PRODUCTS_ENDPOINT}    /products

*** Keywords ***
Get All Products
    [Documentation]    Get all products from Fake Store API
    ${items}=    _Get All Items From Endpoint    ${PRODUCTS_ENDPOINT}    products
    RETURN    ${items}

Get Product By ID
    [Documentation]    Get product by ID from Fake Store API
    [Arguments]    ${id}
    ${item}=    _Get Item By Id From Endpoint    ${PRODUCTS_ENDPOINT}    product    ${id}
    RETURN    ${item}

Get Products By Category
    [Documentation]    Get products filtered by category with error handling
    [Arguments]    ${category}
    TRY
        ${response}=    Send GET Request    ${PRODUCTS_ENDPOINT}/category/${category}
        VAR    ${products}    ${response.json()}
        Should Not Be Empty    ${products}
        FOR    ${product}    IN    @{products}
            Should Be Equal    ${product}[category]    ${category}
        END
        ${count}=    Get Length    ${products}
        Log    Got ${count} products in category: ${category}    console=True
        RETURN    ${products}
    EXCEPT    AS    ${err}
        Fail    Failed to get products by category | Category: ${category} | Error: ${err}
    END
