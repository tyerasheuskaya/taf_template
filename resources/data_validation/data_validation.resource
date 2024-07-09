*** Settings ***
Documentation    Data validation methods
Library         Collections
Resource         ../../resources/db/connectors.resource
Resource         ../../resources/db/db.resource
Resource         ../../resources/os/files.resource
Variables        ../../config/data_validation/${ENV}.yaml


*** Keywords ***
Verify table presents for ${schema}
    [Documentation]   Check table existance
    [Arguments]  ${target_db}  ${schema}  ${expected_tables}
    Log To Console   Checking existance of tables for schema ${schema}
    ${actual_tables}   Get list of presented tables   ${target_db}  ${schema}  ${expected_tables}
    ${missed tables}  Evaluate   set(${expected_tables})-set(${actual_tables})
    # ${extra tables}   Evaluate   set(${actual_tables})-set(${expected_tables}) 
    Lists Should Be Equal   ${expected_tables}   ${actual_tables}  Missed tables: ${missed tables}  # , Extra tables: ${extra tables}  

Verify metadata for ${schema}.${table}
    [Documentation]   Check metadata
    [Arguments]  ${target_db}   ${schema}  ${table}  ${source_name}
    Log To Console   Checking metadata for schema ${schema} and table ${table}
    ${db_metadata}  Get Metadata by table  alias=${target_db}  schema=${schema}  table=${table}
    &{actual_metadata}  Evaluate  {x[0]: x[1] for x in ${db_metadata}}
    ${expected_metadata}  Get data From YAML  test_data${/}data_validation${/}${source_name}${/}${schema}${/}${table}.yaml
    FOR  ${key}  IN  @{expected_metadata.keys()}
        Dictionary Should Contain Key  ${actual_metadata}  ${key}  Missed column in db! ${key} : ${expected_metadata}[${key}]
    END
    FOR  ${key}  IN  @{actual_metadata.keys()}
        Dictionary Should Contain Key  ${expected_metadata}   ${key}  Extra column in db! ${key} : ${actual_metadata}[${key}]
    END

Verify counts for ${schema}.${table}. Should be >0
    [Documentation]  Check Table Counts
    [Arguments]  ${target_db}   ${schema}  ${table}
    Log To Console   Checking Counts for schema ${schema} and table ${table}
    ${count}  Get Row Counts  alias=${target_db}  schema=${schema}  table=${table}
    Should Be True  ${count} >0  msg=Count for schema ${schema} and table ${table} is not more than 0
