*** Settings ***
Documentation     API test suite for Fake Store API
Library           RequestsLibrary
Library           Collections
Resource          ../../resources/api/common.resource

Suite Setup       Create API Session
Suite Teardown    Delete All Sessions

Test Tags         api    demo

*** Test Cases ***

Get All Products And Verify Structure
    [Documentation]    Verify GET /products returns valid product list
    [Tags]    smoke    regression
    ${products}=    Get All Products
    Should Not Be Empty    ${products}
    FOR    ${product}    IN    @{products}
        Should Contain    ${product}    id
        Should Contain    ${product}    title
        Should Contain    ${product}    price
        Should Contain    ${product}    category
    END

Get Product By ID And Verify Details
    [Documentation]    Verify GET /products/{id} returns correct product
    [Tags]    regression
    ${product}=    Get Product By ID    1
    Should Be Equal As Numbers    ${product}[id]    ${1}
    Should Be Equal    ${product}[title]    ${PRODUCT_1_NAME}
    ${price}=    Convert To Number    ${product}[price]
    Should Be Equal As Numbers    ${price}    ${PRODUCT_1_PRICE}

Get Products By Category
    [Documentation]    Verify GET /products/category/{category} filters correctly
    [Tags]    regression
    ${products}=    Get Products By Category    jewelery
    Should Not Be Empty    ${products}
    FOR    ${product}    IN    @{products}
        Should Be Equal    ${product}[category]    jewelery
    END

Get All Users And Verify Structure
    [Documentation]    Verify GET /users returns valid user list
    [Tags]    regression
    ${users}=    Get All Users
    Should Not Be Empty    ${users}
    FOR    ${user}    IN    @{users}
        Should Contain    ${user}    id
        Should Contain    ${user}    email
        Should Contain    ${user}    username
    END

Get User By ID
    [Documentation]    Verify GET /users/{id} returns correct user
    [Tags]    regression
    ${user}=    Get User By ID    1
    Should Be Equal As Numbers    ${user}[id]    ${1}

Get All Carts And Verify Structure
    [Documentation]    Verify GET /carts returns valid cart list
    [Tags]    regression
    ${carts}=    Get All Carts
    Should Not Be Empty    ${carts}
    FOR    ${cart}    IN    @{carts}
        Should Contain    ${cart}    id
        Should Contain    ${cart}    userId
        Should Contain    ${cart}    products
    END

Get Cart By ID
    [Documentation]    Verify GET /carts/{id} returns correct cart
    [Tags]    regression
    ${cart}=    Get Cart By ID    1
    Should Be Equal As Numbers    ${cart}[id]    ${1}

Get Carts By User ID
    [Documentation]    Verify GET /carts/user/{userId} filters correctly
    [Tags]    regression
    ${carts}=    Get Carts By User    1
    Should Not Be Empty    ${carts}
