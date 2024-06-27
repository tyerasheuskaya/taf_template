*** Settings ***
Documentation    Base queries for DBs
Library          DatabaseLibrary
Library          String

*** Keywords ***
Create table test_cases_result
# Create table for test cases result 
    [Arguments]    ${connection}
    ${query}=    Set Variable    CREATE TABLE test_cases_result 
    ...    (id NUMBER(6) NOT NULL, 
    ...    table_name VARCHAR2(25) NOT NULL, 
    ...    test_case_name VARCHAR2(25) NOT NULL, 
    ...    metric_value VARCHAR2(25) NOT NULL, 
    ...    start_date Date NOT NULL, 
    ...    end_date Date NOT NULL  
    ...    CONSTRAINT id_pk PRIMARY KEY (id))
    # ${query}=  Set Variable   CREATE TABLE Album1 (AlbumId INTEGER NOT NULL, Title NVARCHAR(160) NOT NULL, ArtistId INTEGER NOT NULL) 
    Log    ${query}
    Query    ${query}    ${connection} 

Insert data into table
# Insert data into table
    [Arguments]    ${connection}    ${schema}    ${table}    ${values}
    ${columns} =  Get Columns    ${connection}    ${schema}    ${table}
    Log To Console  ${columns}
    ${columns_expr}=    Concat columns into one string    ${columns}
    ${schema}=   Set Variable If    '${schema}' == '${None}'    ${EMPTY}    ${schema}.
    ${query}=    Set Variable    INSERT INTO ${schema}${table} (${columns_expr}) VALUES(${values})
    Log To Console   ${query}
    Execute Sql String    ${query}    ${connection}

Get Columns
# Get list of columns base on table name
    [Arguments]    ${connection}    ${schema}    ${table}
        ${schema}=    Set Variable If    '${schema}' == '${None}'    ${EMPTY}    ${schema}.
    # ${query}=    Set Variable   SELECT lower(column_name) FROM all_tab_columns WHERE ${schema} and lower(table_name) = lower('${table}')

    ${query}=    Set Variable   Select Name from PRAGMA_TABLE_INFO('${table}')

    Log To Console  ${query}
    @{result}=    Query    ${query}    ${connection}
    RETURN  ${result} 

Concat columns into one string
# Concatenate all columns from list to be used for hash function
    [Arguments]    ${columns}
        ${columns_as_string}=    Evaluate    ' , '.join(${columns})
    RETURN  ${columns_as_string}

Get Row Counts from Table
# Get counts base on table name
    [Arguments]    ${connection}    ${schema}    ${table}
    ${query}=    Set Variable    SELECT COUNT(*) FROM ${schema}.${table}
    Log    ${query}
    @{result}=    Query    ${query}    ${connection}
    RETURN  ${result} 

Get Hash
# TODO! Get hash for each row base on table name
    [Arguments]    ${connection}    ${key}    ${schema}    ${table}
    ${columns} =  Get Columns    ${connection}    ${schema}    ${table}
    ${columns_expr}=    Concat columns into one string    ${columns}
    ${columns_expr}=    Replace String Using Regexp    ${columns_expr}    ,    ||
    ${schema}=    Set Variable If    '${schema}' == '${None}'    ${EMPTY}    ${schema}.
    ${query}=    Set Variable    SELECT ora_hash(${columns_expr}) AS row_hash FROM ${schema}${table} order by ${key}
    Log To Console  ${query}
    @{result}=    Query    ${query}    ${connection}
    Log To Console  ${result}
    RETURN  ${result}

Get objects statistic
# Get counts base on table name
    [Arguments]    ${connection}    ${schema}    ${table}
    ${query}=    Set Variable    SELECT table_name, num_rows FROM user_tables WHERE lower(schema_name) = lower('${schema}') and lower(table_name) = lower('${table}'');
    Log    ${query}
    @{result}=    Query    ${query}    ${connection}
    RETURN  ${result} 

Get data from DB
# Custom query that helps to validate that data are loaded to corresponding layer
    [Arguments]    ${connection}    ${schema}    ${table}    ${where_clause}
    ${where_clause}=   Run Keyword If    '${where_clause}' == ''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${schema}=    Set Variable If    '${schema}' == '${None}'    ${EMPTY}    ${schema}.
    ${query}=    Set Variable    SELECT count(*) FROM ${schema}${table} WHERE ${where_clause};
    Log To Console    ${query}
    @{result}=    Query    ${query}    ${connection}
    Log To Console    ${result}[0][0]
    RETURN  ${result}[0][0]

Delete data from DB
# Delete data from DB by clause
    [Arguments]    ${connection}    ${schema}    ${table}    ${where_clause}
    ${where_clause}=   Run Keyword If    ${where_clause}==''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${schema}=    Set Variable If    '${schema}' == '${None}'    ${EMPTY}    ${schema}.
    ${query}=    Set Variable    Delete FROM ${schema}${table} WHERE ${where_clause};
    Log    ${query}
    Execute Sql String    ${query}    ${connection}

