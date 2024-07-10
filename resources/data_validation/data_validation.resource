*** Settings ***
Documentation    Data validation methods
Library         Collections
Resource         ../../resources/db/connectors.resource
Resource         ../../resources/db/db.resource
Resource         ../../resources/os/files.resource
Variables        ../../config/data_validation/${ENV}.yaml
Library         ../../resources/utils/matchers.py


*** Keywords ***
Verify table presents for ${schema}
    [Documentation]   Check table existance
    [Arguments]  ${target_db}  ${schema}  ${expected_tables}
    Log To Console   Checking existance of tables for schema ${schema}
    ${actual_tables}   Get list of presented tables   ${target_db}  ${schema}  ${expected_tables}
    Assert Lists Are Equal  ${expected_tables}      ${actual_tables}

Verify metadata for ${schema}.${table}
    [Documentation]   Check metadata
    [Arguments]  ${target_db}   ${schema}  ${table}  ${source_name}
    Log To Console   Checking metadata for schema ${schema} and table ${table}
    ${db_metadata}  Get Metadata by table  alias=${target_db}  schema=${schema}  table=${table}
    &{actual_metadata}  Evaluate  {x[0]: x[1] for x in ${db_metadata}}
    ${expected_metadata}  Get data From YAML  test_data${/}data_validation${/}${source_name}${/}${schema}${/}${table}.yaml
    Dictionaries Should Be Equal    dict1=&{actual_metadata}    dict2=&{expected_metadata}


Verify counts for ${schema}.${table}. Should be >0
    [Documentation]  Check Table Counts
    [Arguments]  ${target_db}   ${schema}  ${table}
    Log To Console   Checking Counts for schema ${schema} and table ${table}
    ${count}  Get Row Counts  alias=${target_db}  schema=${schema}  table=${table}
    Assert Greater Than  ${count}    ${11}
