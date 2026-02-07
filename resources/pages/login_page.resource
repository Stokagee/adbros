*** Settings ***
Documentation     Page object for SauceDemo login page
Library           Browser
Library           BuiltIn
Library           String
Library           Collections
Resource          base_page.resource
Resource          ../config/test_data.resource

*** Variables ***
${USERNAME_INPUT}    data-test=username
${PASSWORD_INPUT}    data-test=password
${LOGIN_BUTTON}    data-test=login-button
${ERROR_MESSAGE}    data-test=error

*** Keywords ***
Open Login Page
    [Documentation]    Navigate to login page and verify it's loaded with error handling
    TRY
        New Page    ${BASE_URL}
        Wait For Page Load
        Wait For Element Visible    ${USERNAME_INPUT}
        Log    Login page opened    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to open login page | URL: ${BASE_URL} | Error: ${err}
    END

Login As User
    [Documentation]    Login with given credentials with error handling
    [Arguments]    ${username}    ${password}
    TRY
        Fill Text Input    ${USERNAME_INPUT}    ${username}    context= (username field)
        Wait For Element Visible    ${PASSWORD_INPUT}
        Fill Secret    ${PASSWORD_INPUT}    $password
        Click Element    ${LOGIN_BUTTON}    context= (login button)
        Log    Logged in as: ${username}    console=True
    EXCEPT    AS    ${err}
        Fail    Login failed for user '${username}' | Error: ${err}
    END

Login As Standard User
    [Documentation]    Login as standard user with error handling
    TRY
        Login As User    ${STANDARD_USER}    ${VALID_PASSWORD}
    EXCEPT    AS    ${err}
        Fail    Standard user login failed | Error: ${err}
    END

Login As Locked Out User
    [Documentation]    Login as locked out user with error handling
    TRY
        Login As User    ${LOCKED_OUT_USER}    ${VALID_PASSWORD}
    EXCEPT    AS    ${err}
        Fail    Locked out user login failed | Error: ${err}
    END

Verify Login Error Displayed
    [Documentation]    Verify error message is displayed with error handling
    [Arguments]    ${expected_error}=Epic sadface: Username is required
    TRY
        Wait For Element Visible    ${ERROR_MESSAGE}
        Element Should Contain Text    ${ERROR_MESSAGE}    ${expected_error}
        Log    Login error verified: ${expected_error}    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify login error | Expected: ${expected_error} | Error: ${err}
    END

Get Error Message
    [Documentation]    Get the text of the error message with error handling
    TRY
        ${error_text}=    Get Element Text Content    ${ERROR_MESSAGE}
        Log    Got error message    console=True
        RETURN    ${error_text}
    EXCEPT    AS    ${err}
        Fail    Failed to get error message | Error: ${err}
    END

Verify Username Field Visible
    [Documentation]    Verify username input field is visible with error handling
    TRY
        Element Should Be Visible    ${USERNAME_INPUT}
        Log    Username field is visible    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify username field visible | Error: ${err}
    END

Verify Password Field Visible
    [Documentation]    Verify password input field is visible with error handling
    TRY
        Element Should Be Visible    ${PASSWORD_INPUT}
        Log    Password field is visible    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify password field visible | Error: ${err}
    END

Verify Login Button Visible
    [Documentation]    Verify login button is visible with error handling
    TRY
        Element Should Be Visible    ${LOGIN_BUTTON}
        Log    Login button is visible    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify login button visible | Error: ${err}
    END

Clear Login Form
    [Documentation]    Clear all fields in the login form with error handling
    TRY
        Fill Text Input    ${USERNAME_INPUT}    ${EMPTY}
        Fill Secret Input    ${PASSWORD_INPUT}    ${EMPTY}
        Log    Login form cleared    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to clear login form | Error: ${err}
    END
