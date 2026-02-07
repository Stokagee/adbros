*** Settings ***
Documentation     Login page test suite for SauceDemo
Library           Browser
Resource          ../../resources/ui/common.resource

Suite Setup       Setup Browser Context
Suite Teardown    Teardown Browser Context
Test Setup        Open Login Page
Test Teardown     Close Page

Test Tags         login    ui    demo

*** Test Cases ***

Successful Login With Valid Credentials
    [Documentation]    Verify user can login with valid credentials
    [Tags]    smoke    positive
    Login As Standard User
    Verify On Inventory Page

Failed Login With Invalid Username
    [Documentation]    Verify error message for invalid username
    [Tags]    negative
    Login As User    invalid_user    ${VALID_PASSWORD}
    Verify Login Error Displayed    Epic sadface: Username and password do not match

Failed Login With Invalid Password
    [Documentation]    Verify error message for invalid password
    [Tags]    negative
    Login As User    ${STANDARD_USER}    wrong_password
    Verify Login Error Displayed    Epic sadface: Username and password do not match

Login With Empty Username Shows Error
    [Documentation]    Verify error when username is empty
    [Tags]    negative    validation
    VAR    ${valid_password}    secret_sauce
    Fill Secret Input    data-test=password    ${valid_password}
    Click Element    data-test=login-button
    Verify Login Error Displayed    Epic sadface: Username is required

Login With Empty Password Shows Error
    [Documentation]    Verify error when password is empty
    [Tags]    negative    validation
    Fill Text Input    data-test=username    ${STANDARD_USER}
    Click Element    data-test=login-button
    Verify Login Error Displayed    Epic sadface: Password is required

Locked Out User Cannot Login
    [Documentation]    Verify locked out user gets appropriate error message
    [Tags]    negative    security
    Login As Locked Out User
    ${error}=    Get Error Message
    Should Contain    ${error}    Sorry, this user has been locked out

All Login Fields Are Visible
    [Documentation]    Verify all login form elements are visible
    [Tags]    smoke    visual
    Verify Username Field Visible
    Verify Password Field Visible
    Verify Login Button Visible

Login Page Loads Correctly
    [Documentation]    Verify login page loads without errors
    [Tags]    smoke
    ${states}=    Get Element States    data-test=username
    Should Contain    ${states}    visible
    ${states}=    Get Element States    data-test=password
    Should Contain    ${states}    visible
    ${states}=    Get Element States    data-test=login-button
    Should Contain    ${states}    visible
