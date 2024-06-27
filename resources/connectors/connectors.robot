*** Settings ***
Documentation    Methods for connection to Databases
Library          DatabaseLibrary
Library          String
Resource         ../../configurations/connections/connections_qa.robot

*** Variables ***
${DB_API_MODULE_NAME_ORACLE}    oracledb
${DB_API_MODULE_NAME_SQLIGHT}   sqlite3

*** Keywords ***
Connect to Oracle
    [Arguments]      ${db_name}    &{params}    
    Connect To Database    
    ...    dbapiModuleName=${DB_API_MODULE_NAME_ORACLE}  
    ...    dbName=${params}[SID]  
    ...    dbUsername=${params}[USER]     
    ...    dbPassword=${params}[PASSWORD]       
    ...    dbHost=${params}[HOST]        
    ...    dbPort=${params}[PORT]    
    ...    alias=${db_name}
    Log To Console  Connected to ${db_name} successfully!

Connect to sqlight
    [Arguments]      ${db_name}    &{params} 
    Connect To Database Using Custom Params    
    ...    dbapiModuleName=${DB_API_MODULE_NAME_SQLIGHT}     
    ...    db_connect_string=${params}[DATABASE]    
    ...    alias=${db_name}
    Log To Console  Connected to ${db_name} successfully!

Connect to db
    [Arguments]    ${db_name}
    Set Global Variable  ${CONNECTION}
    ${db_name_lower}=    Convert To Lowercase    ${db_name}
    IF    '${db_name_lower}' == 'oracle 12'
        Connect to Oracle  ${db_name}  &{ORACLE12}
    ELSE IF  '${db_name_lower}' == 'oracle 19'
        Connect to Oracle  ${db_name}  &{ORACLE19}
    ELSE IF  '${db_name_lower}' == 'sqlight'
        Connect to sqlight  ${db_name}  &{SQLIGHT}
    ELSE
        Log To Console  'Invalid or unsupported DB_NAME'
    END  

Disconnect from db
    [Arguments]  ${db_name}
    Disconnect From Database    alias=${db_name}
    Log To Console  Disconnected from ${db_name} successfully!