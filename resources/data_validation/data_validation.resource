*** Settings ***
Documentation    Data validation methods
Resource         ../../resources/db/connectors.resource
Resource         ../../resources/db/db.resource
Resource         ../../resources/os/files.resource
Variables        ../../config/data_validation/${ENV}.yaml


*** Keywords ***
Verify metadata for ${schema}.${table}. Should be TODO
    [Documentation]   Check table metadata
    [Arguments]  ${target_db}   ${schema}  ${table}
    Log To Console  Checking metadata for schema ${schema} and table ${table}
    ${metadata}  Get Metadata  alias=${target_db}  schema=${schema}  table=${table}


Verify counts for ${schema}.${table}. Should be >0
    [Documentation]  Check Table Counts for schema ${schema} and table ${table}
    [Arguments]  ${target_db}   ${schema}  ${table}
    Log To Console  Checking count for schema ${schema} and table ${table}
    ${count}  Get Row Counts  alias=${target_db}  schema=${schema}  table=${table}
    Should Be True  ${count} != 70  msg=Count for schema ${schema} and table ${table} is not more than 0