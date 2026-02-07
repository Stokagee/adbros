*** Settings ***
Documentation     Page object for SauceDemo checkout pages (step 1, step 2, complete)
Resource          base_page.resource
Resource          ../locators/checkout_page.resource

*** Keywords ***
Verify Checkout Step One Loaded
    [Documentation]    Verify checkout step one page is loaded with error handling
    TRY
        Wait For Page Load
        ${url}=    Get Url
        Should Contain    ${url}    checkout-step-one.html
        Wait For Element Visible    ${FIRST_NAME_INPUT}
        Log    Checkout step one page loaded    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify checkout step one loaded | Error: ${err}
    END

Fill Checkout Information
    [Documentation]    Fill all checkout form fields with error handling
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    TRY
        Fill Text Input    ${FIRST_NAME_INPUT}    ${first_name}    context= (first name)
        Fill Text Input    ${LAST_NAME_INPUT}    ${last_name}    context= (last name)
        Fill Text Input    ${POSTAL_CODE_INPUT}    ${postal_code}    context= (postal code)
        Log    Filled checkout information    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to fill checkout information | Error: ${err}
    END

Click Continue Button
    [Documentation]    Click continue to proceed to step two with error handling
    TRY
        Click Element    ${CONTINUE_BUTTON}    context= (continue button)
        Log    Clicked continue button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click continue button | Error: ${err}
    END

Click Cancel Button
    [Documentation]    Click cancel to return to cart with error handling
    TRY
        Click Element    ${CANCEL_BUTTON}    context= (cancel button)
        Log    Clicked cancel button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click cancel button | Error: ${err}
    END

Verify Checkout Error Displayed
    [Documentation]    Verify error message is displayed with error handling
    [Arguments]    ${expected_error}=Error: First Name is required
    TRY
        Wait For Element Visible    ${CHECKOUT_ERROR}
        Element Should Contain Text    ${CHECKOUT_ERROR}    ${expected_error}
        Log    Checkout error verified: ${expected_error}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify checkout error | Expected: ${expected_error} | Error: ${err}
    END

Get Checkout Error Message
    [Documentation]    Get the text of the checkout error message with error handling
    TRY
        ${error_text}=    Get Element Text Content    ${CHECKOUT_ERROR}
        Log    Got checkout error message    console=True
        RETURN    ${error_text}
    EXCEPT    AS    ${err}
        Fail    Failed to get checkout error message | Error: ${err}
    END

Verify Checkout Step Two Loaded
    [Documentation]    Verify checkout step two page is loaded with error handling
    TRY
        Wait For Page Load
        ${url}=    Get Url
        Should Contain    ${url}    checkout-step-two.html
        Log    Checkout step two page loaded    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify checkout step two loaded | Error: ${err}
    END

Get Item Total
    [Documentation]    Get the item total amount with error handling
    TRY
        ${total_text}=    Get Element Text Content    ${ITEM_TOTAL}
        ${amount}=    Remove String    ${total_text}    Item total: $    ,
        Log    Item total: ${amount}    console=True
        RETURN    ${amount}
    EXCEPT    AS    ${err}
        Fail    Failed to get item total | Error: ${err}
    END

Get Tax Amount
    [Documentation]    Get the tax amount with error handling
    TRY
        ${tax_text}=    Get Element Text Content    ${TAX_LABEL}
        ${amount}=    Remove String    ${tax_text}    Tax: $    ,
        Log    Tax amount: ${amount}    console=True
        RETURN    ${amount}
    EXCEPT    AS    ${err}
        Fail    Failed to get tax amount | Error: ${err}
    END

Get Total Amount
    [Documentation]    Get the total amount including tax with error handling
    TRY
        ${total_text}=    Get Element Text Content    ${TOTAL_LABEL}
        ${amount}=    Remove String    ${total_text}    Total: $    ,
        Log    Total amount: ${amount}    console=True
        RETURN    ${amount}
    EXCEPT    AS    ${err}
        Fail    Failed to get total amount | Error: ${err}
    END

Click Finish Button
    [Documentation]    Click finish to complete the order with error handling
    TRY
        Click Element    ${FINISH_BUTTON}    context= (finish button)
        Log    Clicked finish button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click finish button | Error: ${err}
    END

Verify Checkout Complete Page Loaded
    [Documentation]    Verify checkout complete page is loaded with error handling
    TRY
        Wait For Page Load
        ${url}=    Get Url
        Should Contain    ${url}    checkout-complete.html
        Log    Checkout complete page loaded    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify checkout complete page loaded | Error: ${err}
    END

Get Complete Message
    [Documentation]    Get the completion message header with error handling
    TRY
        ${message}=    Get Element Text Content    ${COMPLETE_HEADER}
        Log    Got complete message: ${message}    console=True
        RETURN    ${message}
    EXCEPT    AS    ${err}
        Fail    Failed to get complete message | Error: ${err}
    END

Get Complete Text
    [Documentation]    Get the completion description text with error handling
    TRY
        ${text}=    Get Element Text Content    ${COMPLETE_TEXT}
        Log    Got complete text    console=True
        RETURN    ${text}
    EXCEPT    AS    ${err}
        Fail    Failed to get complete text | Error: ${err}
    END

Click Back Home Button
    [Documentation]    Click back to products button with error handling
    TRY
        Click Element    ${BACK_HOME_BUTTON}    context= (back to products)
        Log    Clicked back to products button    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to click back home button | Error: ${err}
    END

Verify Order Complete
    [Documentation]    Verify order was completed successfully with error handling
    TRY
        Verify Checkout Complete Page Loaded
        ${message}=    Get Complete Message
        Should Contain    ${message}    Thank you
        Log    Order verified as complete    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify order complete | Error: ${err}
    END

Complete Checkout Flow
    [Documentation]    Complete the entire checkout flow with error handling
    [Arguments]    ${first_name}=John    ${last_name}=Doe    ${postal_code}=12345
    TRY
        Fill Checkout Information    ${first_name}    ${last_name}    ${postal_code}
        Click Continue Button
        Verify Checkout Step Two Loaded
        Click Finish Button
        Verify Order Complete
        Log    Completed checkout flow    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to complete checkout flow | Error: ${err}
    END
