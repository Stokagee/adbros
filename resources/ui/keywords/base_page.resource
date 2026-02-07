*** Settings ***
Documentation     Base page with common methods using Robot Framework Browser library
Resource          ${EXECDIR}/resources/config/config.resource

*** Variables ***
${SELECTOR_TIMEOUT}    ${ELEMENT_TIMEOUT}
${PAGE_LOAD_TIMEOUT}    30s

*** Keywords ***
Wait For Element Visible
    [Documentation]    Wait for element to be visible with error handling
    [Arguments]    ${locator}    ${timeout}=${SELECTOR_TIMEOUT}
    TRY
        Wait For Elements State    ${locator}    visible    ${timeout}
        Log    Element visible: ${locator}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to wait for element visibility | Locator: ${locator} | Timeout: ${timeout} | Error: ${err}
    END

Wait For Element Enabled
    [Documentation]    Wait for element to be enabled with error handling
    [Arguments]    ${locator}    ${timeout}=${SELECTOR_TIMEOUT}
    TRY
        Wait For Elements State    ${locator}    enabled    ${timeout}
        Log    Element enabled: ${locator}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to wait for element enabled | Locator: ${locator} | Timeout: ${timeout} | Error: ${err}
    END

Wait For Element Hidden
    [Documentation]    Wait for element to be hidden with error handling
    [Arguments]    ${locator}    ${timeout}=${SELECTOR_TIMEOUT}
    TRY
        Wait For Elements State    ${locator}    hidden    ${timeout}
        Log    Element hidden: ${locator}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to wait for element hidden | Locator: ${locator} | Timeout: ${timeout} | Error: ${err}
    END

Click Element
    [Documentation]    Click element when enabled with error handling
    [Arguments]    ${locator}    ${context}=${EMPTY}
    TRY
        Wait For Element Enabled    ${locator}
        Click    ${locator}
        Log    Clicked element: ${locator} ${context}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to click element | Locator: ${locator} | Context: ${context} | Error: ${err}
    END

Fill Text Input
    [Documentation]    Fill text input field with error handling
    [Arguments]    ${locator}    ${text}    ${context}=${EMPTY}
    TRY
        Wait For Element Visible    ${locator}
        Fill Text    ${locator}    ${text}
        Log    Entered text in: ${locator} ${context}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to enter text | Locator: ${locator} | Context: ${context} | Error: ${err}
    END

Fill Secret Input
    [Documentation]    Fill secret input field (for passwords) with error handling
    [Arguments]    ${locator}    ${secret}    ${context}=${EMPTY}
    TRY
        Wait For Element Visible    ${locator}
        IF    "${secret}" == "${EMPTY}"
            Fill Text    ${locator}    ${EMPTY}
        ELSE
            Fill Secret    ${locator}    $secret
        END
        Log    Entered secret in: ${locator} ${context}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to enter secret | Locator: ${locator} | Context: ${context} | Error: ${err}
    END

Get Element Text Content
    [Documentation]    Get text content of element with error handling
    [Arguments]    ${locator}    ${context}=${EMPTY}
    TRY
        ${text}=    Get Text    ${locator}
        Log    Got text from: ${locator}    console=${LOG_TO_CONSOLE}
        RETURN    ${text}
    EXCEPT    AS    ${err}
        Fail    Failed to get text content | Locator: ${locator} | Context: ${context} | Error: ${err}
    END

Get Element Count
    [Documentation]    Get count of elements matching locator with error handling
    [Arguments]    ${locator}
    TRY
        ${count}=    Browser.Get Element Count    ${locator}
        Log    Element count for '${locator}': ${count}    console=${LOG_TO_CONSOLE}
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get element count | Locator: ${locator} | Error: ${err}
    END

Element Should Be Visible
    [Documentation]    Verify element is visible with error handling
    [Arguments]    ${locator}
    TRY
        ${states}=    Get Element States    ${locator}
        Should Contain    ${states}    visible
        Log    Element is visible: ${locator}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Element not visible | Locator: ${locator} | Error: ${err}
    END

Element Should Contain Text
    [Documentation]    Verify element contains expected text with error handling
    [Arguments]    ${locator}    ${expected_text}
    TRY
        ${actual_text}=    Get Text    ${locator}
        Should Contain    ${actual_text}    ${expected_text}
        Log    Element contains expected text: ${locator}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Element does not contain expected text | Locator: ${locator} | Expected: ${expected_text} | Error: ${err}
    END

Wait For Page Load
    [Documentation]    Wait for page to finish loading with error handling
    [Arguments]    ${timeout}=${PAGE_LOAD_TIMEOUT}
    TRY
        Wait For Load State    networkidle    ${timeout}
        Log    Page loaded    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Page load failed | Timeout: ${timeout} | Error: ${err}
    END

Take Screenshot On Failure
    [Documentation]    Take screenshot when test fails with error handling
    [Arguments]    ${filename}=screenshot.png
    TRY
        Take Screenshot    ${filename}
        Log    Screenshot saved: ${filename}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Log    Failed to take screenshot | Filename: ${filename} | Error: ${err}    level=WARN
    END

Normalize Text For Selector
    [Documentation]    Normalize text to match data-test attribute format (lowercase, spaces to hyphens) with error handling
    [Arguments]    ${text}
    TRY
        ${normalized}=    Convert To Lower Case    ${text}
        ${normalized}=    Replace String    ${normalized}    ${SPACE}    -
        Log    Normalized text: ${normalized}    console=${LOG_TO_CONSOLE}
        RETURN    ${normalized}
    EXCEPT    AS    ${err}
        Fail    Failed to normalize text | Text: ${text} | Error: ${err}
    END
