*** Settings ***
Documentation        Test case 1
Resource             ../../resources/e2e/end_to_end.resource
Resource             ../../resources/db/connectors.resource


*** Variables ***
${source_name}  UFFS
@{layers}       MDM  ODS
${target_db}    ORACLE19
${mock}         True

*** Tasks ***
Test Case 1
    [Documentation]   Mocking Example
    [Tags]  local_test
    Mock Requests Example


Test 2
    [Documentation]  Load to layer_params
    [Tags]  local_test
    Connect to db    ${target_db}
    Load Data to Layer  ${source_name}  ${layers}  ${target_db}  ${mock}  
    Disconnect from db    ${target_db}


Test 3
    [Documentation]  Load to source 
    [Tags]  local_test
    Connect to db    ${source_name}
    Load data to Source     ${source_name}
    Delete data from tables     ${source_name}
    Disconnect from db      ${source_name}
