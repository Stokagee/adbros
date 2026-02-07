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
    [Documentation]    Get all products from API with error handling
    TRY
        ${response}=    Send GET Request    ${PRODUCTS_ENDPOINT}
        ${products}=    Set Variable    ${response.json()}
        Should Not Be Empty    ${products}
        ${count}=    Get Length    ${products}
        Log    Got ${count} products    console=True
        RETURN    ${products}
    EXCEPT    AS    ${err}
        Fail    Failed to get all products | Endpoint: ${PRODUCTS_ENDPOINT} | Error: ${err}
    END

Get Product By ID
    [Documentation]    Get specific product by ID with error handling
    [Arguments]    ${product_id}
    TRY
        ${response}=    Send GET Request    ${PRODUCTS_ENDPOINT}/${product_id}
        ${product}=    Set Variable    ${response.json()}
        Should Be Equal As Numbers    ${product}[id]    ${product_id}
        Log    Got product: ${product}[id] - ${product}[title]    console=True
        RETURN    ${product}
    EXCEPT    AS    ${err}
        Fail    Failed to get product by ID | Product ID: ${product_id} | Error: ${err}
    END

Get Products By Category
    [Documentation]    Get products filtered by category with error handling
    [Arguments]    ${category}
    TRY
        ${response}=    Send GET Request    ${PRODUCTS_ENDPOINT}/category/${category}
        ${products}=    Set Variable    ${response.json()}
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
