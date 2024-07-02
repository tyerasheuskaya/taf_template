*** Settings ***
Documentation    Base queries for DBs
Library          DatabaseLibrary
Library          String

*** Keywords ***
Create table test_cases_result
    [Arguments]    ${alias}
    ${query}    Set Variable    CREATE TABLE test_cases_result
    ...    (id NUMBER(6) NOT NULL, 
    ...    table_name VARCHAR2(25) NOT NULL, 
    ...    test_case_name VARCHAR2(25) NOT NULL, 
    ...    metric_value VARCHAR2(25) NOT NULL, 
    ...    start_date Date NOT NULL, 
    ...    end_date Date NOT NULL  
    ...    CONSTRAINT id_pk PRIMARY KEY (id))
    Log To Console    ${query}
    Query    ${query}    ${alias}

Insert data
    [Arguments]     ${alias}    ${schema}   ${table}    ${columns}  ${values}
    ${query}    Set Variable    INSERT INTO ${schema}.${table} (${columns}) VALUES(${values})
    Log To Console   ${query}
    Execute Sql String    ${query}    alias=${alias}

Get Columns
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable   select lower(column_name) from all_tab_columns WHERE lower(owner)=lower('${schema}') and lower(table_name) = lower('${table}')
    Log To Console  ${query}
    @{result}   Query    ${query}    alias=${alias}
    RETURN  ${result} 

Concat columns into one string
    [Arguments]    ${columns}
        ${columns}  Evaluate   [t[0] for t in ${columns}]
        ${columns_as_string}    Evaluate    ' , '.join(${columns})
    RETURN  ${columns_as_string}

Get Row Counts
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable    SELECT COUNT(*) FROM ${schema}.${table}
    Log To Console    ${query}
    @{result}    Query    ${query}    alias=${alias}
    RETURN  ${result}[0][0]

Get Hash
    [Arguments]    ${alias}    ${key}    ${schema}    ${table}
    ${columns}  Get Columns    ${alias}    ${schema}    ${table}
    ${columns_expr}    Concat columns into one string    ${columns}
    ${columns_expr}    Replace String Using Regexp    ${columns_expr}    ,    ||
    ${query}   Set Variable    SELECT ora_hash(${columns_expr}) AS row_hash FROM ${schema}.${table} order by ${key}
    Log To Console  ${query}
    @{result}    Query    ${query}    alias=${alias}
    Log To Console  ${result}
    RETURN  ${result}

Get objects statistic
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable  SELECT table_name, num_rows FROM user_tables
    ...     WHERE lower(schema_name) = lower('${schema}') and lower(table_name) = lower('${table}');
    Log To Console  ${query}
    @{result}   Query    ${query}    alias=${alias}
    RETURN  ${result} 

Get data from DB
    [Arguments]    ${alias}    ${schema}    ${table}    ${where_clause}
    ${where_clause}     Run Keyword If    '${where_clause}' == ''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${query}    Set Variable    SELECT count(*) FROM ${schema}.${table} WHERE ${where_clause};
    Log To Console    ${query}
    @{result}   Query    ${query}    alias=${alias}
    Log To Console    ${result}[0][0]
    RETURN  ${result}[0][0]

Delete data from table
    [Arguments]    ${alias}    ${schema}    ${table}    ${where_clause}
    ${where_clause}     Run Keyword If    '${where_clause}' == ''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${query}    Set Variable    Delete FROM ${schema}.${table} WHERE ${where_clause};
    Log To Console   ${query}
    Execute Sql String    ${query}    alias=${alias}
    

Delete data from tables
    [Arguments]     ${alias}
    Execute Sql Script    ${EXECDIR}${/}resources${/}db${/}queries${/}e2e${/}clear_lt1_lt2.sql  alias=${alias}