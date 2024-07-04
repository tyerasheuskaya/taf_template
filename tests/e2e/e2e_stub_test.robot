*** Settings ***
Documentation        This is initial test suite
Resource             ../../resources/e2e/end_to_end.resource
Resource             ../../resources/db/connectors.resource


*** Variables ***
${source_name}  UFFS
@{layers}       MDM  ODS
${target_db}    ORACLE19
${mock}         True


*** Test Cases ***
Verify mocking data
    [Documentation]   Mocking Example
    [Tags]  local_test
    Mock Requests Example


Verify loading data to layers
    [Documentation]  Load to layer_params
    [Tags]  local_test
    Load Data to Layer  ${source_name}  ${layers}  ${target_db}  ${mock}


Verify loading data to source
    [Documentation]  Load to source 
    [Tags]  local_test
    Load data to Source     ${source_name}
    Delete data from tables     ${source_name}