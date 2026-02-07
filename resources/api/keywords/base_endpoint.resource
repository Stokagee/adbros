*** Settings ***
Documentation     Base API endpoint object with error handling
Resource          ${EXECDIR}/resources/config/config.resource

*** Variables ***
${CONTENT_TYPE}    application/json

*** Keywords ***
Create API Session
    [Documentation]    Create API session with error handling
    [Arguments]    ${base_url}=${FAKESTORE_API_URL}
    TRY
        &{headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
        Create Session    fakestore    ${base_url}    headers=${headers}
        Log    API session created: fakestore -> ${base_url}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Failed to create API session | URL: ${base_url} | Error: ${err}
    END

Send GET Request
    [Documentation]    Send GET request and return response with error handling
    [Arguments]    ${endpoint}    ${expected_status}=200
    TRY
        ${response}=    GET On Session    fakestore    ${endpoint}    expected_status=${expected_status}
        Log    GET ${endpoint} -> ${response.status_code}    console=${LOG_TO_CONSOLE}
        RETURN    ${response}
    EXCEPT    AS    ${err}
        Fail    GET request failed | Endpoint: ${endpoint} | Expected status: ${expected_status} | Error: ${err}
    END

Send POST Request
    [Documentation]    Send POST request with JSON body and error handling
    [Arguments]    ${endpoint}    ${body}    ${expected_status}=200
    TRY
        ${response}=    POST On Session    fakestore    ${endpoint}    json=${body}    expected_status=${expected_status}
        Log    POST ${endpoint} -> ${response.status_code}    console=${LOG_TO_CONSOLE}
        RETURN    ${response}
    EXCEPT    AS    ${err}
        Fail    POST request failed | Endpoint: ${endpoint} | Body: ${body} | Expected status: ${expected_status} | Error: ${err}
    END

Verify Response Status
    [Documentation]    Verify response status code with error handling
    [Arguments]    ${response}    ${expected_status}
    TRY
        Status Should Be    ${expected_status}    ${response}
        Log    Response status verified: ${expected_status}    console=${LOG_TO_CONSOLE}
    EXCEPT    AS    ${err}
        Fail    Response status verification failed | Expected: ${expected_status} | Actual: ${response.status_code} | Error: ${err}
    END

Verify Response Contains
    [Documentation]    Verify response body contains key/value with error handling
    [Arguments]    ${response}    ${key}    ${value}=${None}
    TRY
        VAR    ${body}    ${response.json()}
        IF    "${value}" == "${None}"
            Should Contain    ${body}    ${key}
            Log    Response contains key: ${key}    console=${LOG_TO_CONSOLE}
        ELSE
            Should Be Equal    ${body}[${key}]    ${value}
            Log    Response contains ${key}=${value}    console=${LOG_TO_CONSOLE}
        END
    EXCEPT    AS    ${err}
        Fail    Response verification failed | Key: ${key} | Value: ${value} | Error: ${err}
    END

_Get All Items From Endpoint
    [Documentation]    Internal: Get all items from an endpoint with error handling
    [Arguments]    ${endpoint}    ${resource_name}
    TRY
        ${response}=    Send GET Request    ${endpoint}
        VAR    ${items}    ${response.json()}
        Should Not Be Empty    ${items}
        ${count}=    Get Length    ${items}
        Log    Got ${count} ${resource_name}    console=${LOG_TO_CONSOLE}
        RETURN    ${items}
    EXCEPT    AS    ${err}
        Fail    Failed to get all ${resource_name} | Error: ${err}
    END

_Get Item By Id From Endpoint
    [Documentation]    Internal: Get item by ID from an endpoint with error handling
    [Arguments]    ${endpoint}    ${resource_name}    ${id}
    TRY
        ${response}=    Send GET Request    ${endpoint}/${id}
        VAR    ${item}    ${response.json()}
        Should Not Be Empty    ${item}
        Log    Got ${resource_name} with ID ${id}    console=${LOG_TO_CONSOLE}
        RETURN    ${item}
    EXCEPT    AS    ${err}
        Fail    Failed to get ${resource_name} by ID | ID: ${id} | Error: ${err}
    END
