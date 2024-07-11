*** Settings ***
Documentation    Base methods for DBs
Library          DatabaseLibrary
Library          String
Library          OperatingSystem

*** Keywords ***
Create table test_cases_result
    [Arguments]    ${alias}
    ${query}    Set Variable    CREATE TABLE TEST_CASES_RESULT
    ...    (ID NUMBER(6) NOT NULL, 
    ...    TABLE_NAME VARCHAR2(25) NOT NULL, 
    ...    TEST_CASE_NAME VARCHAR2(25) NOT NULL, 
    ...    METRIC_VALUE VARCHAR2(25) NOT NULL, 
    ...    START_DATE DATE NOT NULL, 
    ...    END_DATE DATE NOT NULL  
    ...    CONSTRAINT ID_PK PRIMARY KEY (ID))
    Log  ${query}
    Query    ${query}    ${alias}

Insert data
    [Arguments]     ${alias}    ${schema}   ${table}    ${columns}  ${values}
    ${query}    Set Variable    INSERT INTO ${schema}.${table} (${columns}) VALUES(${values})
    Log  ${query}
    Execute Sql String    ${query}    alias=${alias}
    Log To Console    Inserted successfully!

Get Columns
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable   SELECT UPPER(COLUMN_NAME) FROM ALL_TAB_COLUMNS WHERE UPPER(OWNER)=UPPER('${schema}') AND UPPER(TABLE_NAME) = UPPER('${table}')
    Log  ${query}
    @{result}   Query    ${query}    alias=${alias}
    RETURN  ${result} 

Get Metadata by table
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable   SELECT UPPER(COLUMN_NAME) AS COLUMN_NAME, UPPER(DATA_TYPE) AS DATA_TYPE FROM ALL_TAB_COLUMNS WHERE UPPER(OWNER)=UPPER('${schema}') AND UPPER(TABLE_NAME) = UPPER('${table}') ORDER BY UPPER(OWNER) ASC, UPPER(TABLE_NAME) ASC, UPPER(COLUMN_NAME)
    Log  ${query}
    @{result}   Query    ${query}    alias=${alias}
    RETURN  ${result} 

Get list of presented tables
    [Arguments]    ${alias}    ${schema}    ${tables}
    ${tables_expr}  Catenate  SEPARATOR=','    @{tables}  
    ${query}    Set Variable   SELECT distinct UPPER(TABLE_NAME) FROM ALL_TAB_COLUMNS WHERE UPPER(OWNER)=UPPER('${schema}') AND UPPER(TABLE_NAME) in ('${tables_expr}') ORDER by UPPER(TABLE_NAME) ASC
    Log  ${query}
    @{result}   Query    ${query}    alias=${alias}
    ${tables_list}  Evaluate   [t[0] for t in ${result}]
    RETURN  ${tables_list} 

Concat columns into one string
    [Arguments]    ${columns}
        ${columns}  Evaluate   [t[0] for t in ${columns}]
        ${columns_as_string}    Evaluate    ' , '.join(${columns})
    RETURN  ${columns_as_string}

Get Row Counts
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable    SELECT COUNT(*) FROM ${schema}.${table}
    Log  ${query}
    @{result}    Query    ${query}    alias=${alias}
    RETURN  ${result}[0][0]

Get Hash
    [Arguments]    ${alias}    ${key}    ${schema}    ${table}
    ${columns}  Get Columns    ${alias}    ${schema}    ${table}
    ${columns_expr}    Concat columns into one string    ${columns}
    ${columns_expr}    Replace String Using Regexp    ${columns_expr}    ,    ||
    ${query}   Set Variable    SELECT ora_hash(${columns_expr}) AS row_hash FROM ${schema}.${table} ORDER BY ${key}
    Log  ${query}
    @{result}    Query    ${query}    alias=${alias}
    Log  ${result}
    RETURN  ${result}

Get objects statistic
    [Arguments]    ${alias}    ${schema}    ${table}
    ${query}    Set Variable  SELECT TABLE_NAME, NUM_ROWS FROM USER_TABLES WHERE UPPER(SCHEMA_NAME) = UPPER('${schema}') AND UPPER(TABLE_NAME) = UPPER('${table}');
    Log  ${query}
    @{result}   Query    ${query}    alias=${alias}
    RETURN  ${result} 

Get data from DB
    [Arguments]    ${alias}    ${schema}    ${table}    ${where_clause}
    ${where_clause}     Run Keyword If    '${where_clause}' == ''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${query}    Set Variable    SELECT COUNT(*) FROM ${schema}.${table} WHERE ${where_clause};
    Log   ${query}
    @{result}   Query    ${query}    alias=${alias}
    Log  ${result}[0][0]
    RETURN  ${result}[0][0]

Delete data from table
    [Arguments]    ${alias}    ${schema}    ${table}    ${where_clause}
    ${where_clause}     Run Keyword If    '${where_clause}' == ''    Set Variable    1=1    ELSE    Set Variable    ${where_clause}
    ${query}    Set Variable    DELETE FROM ${schema}.${table} WHERE ${where_clause};
    Log  ${query}
    Execute Sql String    ${query}    alias=${alias}
    
Delete data from tables
    [Arguments]     ${alias}
    Execute Sql Script    ${EXECDIR}${/}test_data${/}queries${/}e2e${/}clear_lt1_lt2.sql  alias=${alias}
    Log to Console  Deleted successfully!

Run script from file
    [Documentation]  Run prepared query from file
    [Arguments]  ${path}  ${alias}
    ${query}  Get File    ${path}
    ${result}=  Query  ${query}  alias=${alias}
    Log to Console  Query from ${path} executed successfully!