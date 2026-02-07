*** Settings ***
Documentation     Base database table object with error handling
Resource          ${EXECDIR}/resources/config/config.resource

*** Keywords ***
Connect To Test Database
    [Documentation]    Connect to test database with error handling
    TRY
        Log    Connecting to database: ${DB_PATH}    console=True
        Connect To Database    ${DB_API}    ${DB_PATH}
        Log    Database connected    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to connect to database | Path: ${DB_PATH} | API: ${DB_API} | Error: ${err}
    END

Disconnect From Test Database
    [Documentation]    Disconnect from database with error handling
    TRY
        Disconnect From Database
        Log    Database disconnected    console=True
    EXCEPT    AS    ${err}
        Log    Failed to disconnect from database | Error: ${err}    level=WARN
    END

Table Must Contain Data
    [Documentation]    Verify table has at least one row with error handling
    [Arguments]    ${table_name}
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM ${table_name}
        Should Be True    ${count} > 0
        Log    Table '${table_name}' contains ${count} rows    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to verify table contains data | Table: ${table_name} | Error: ${err}
    END

Get Row Count
    [Documentation]    Get number of rows in table with error handling
    [Arguments]    ${table_name}
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM ${table_name}
        Log    Table '${table_name}' has ${count} rows    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get row count | Table: ${table_name} | Error: ${err}
    END

Execute Query
    [Documentation]    Execute SQL query and return results with error handling
    [Arguments]    ${sql}
    TRY
        Log    Executing query: ${sql}    console=True
        @{results}=    Query    ${sql}
        ${row_count}=    Get Length    ${results}
        Log    Query returned ${row_count} rows    console=True
        RETURN    @{results}
    EXCEPT    AS    ${err}
        Fail    Query failed | SQL: ${sql} | Error: ${err}
    END

Get Single Row
    [Documentation]    Execute query and return first row with error handling
    [Arguments]    ${sql}
    TRY
        Log    Executing query for single row: ${sql}    console=True
        @{row}=    Query    ${sql}
        Should Not Be Empty    ${row}    msg=Query returned no results
        Log    Got single row    console=True
        RETURN    @{row}
    EXCEPT    AS    ${err}
        Fail    Failed to get single row | SQL: ${sql} | Error: ${err}
    END

_Get Table Item Count
    [Documentation]    Internal: Get row count from a table with error handling
    [Arguments]    ${table_name}
    TRY
        ${count}=    Row Count    SELECT COUNT(*) FROM ${table_name}
        Log    Table ${table_name} has ${count} rows    console=True
        RETURN    ${count}
    EXCEPT    AS    ${err}
        Fail    Failed to get row count | Table: ${table_name} | Error: ${err}
    END

_Get Table Item By Id
    [Documentation]    Internal: Get item by ID from a table with error handling
    [Arguments]    ${table_name}    ${id}
    TRY
        @{rows}=    Query    SELECT * FROM ${table_name} WHERE id=${id}
        ${count}=    Get Length    ${rows}
        IF    ${count} == 0
            Fail    No ${table_name} found with ID ${id}
        END
        Log    Found ${table_name} with ID ${id}    console=True
        RETURN    @{rows}[0]
    EXCEPT    AS    ${err}
        Fail    Failed to get ${table_name} by ID | ID: ${id} | Error: ${err}
    END
