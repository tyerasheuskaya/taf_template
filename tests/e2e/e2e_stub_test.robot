*** Settings ***
Documentation        Test case 1
Resource             ../../resources/e2e/end_to_end.resource
Resource             ../../resources/db/connectors/connectors.resource



*** Tasks ***
# Test Case 1
#     [Documentation]   End to End Test. Process Source till DB Presentation level".  
#     # Available parameters for source insert: 'source is db',  'source is files'
#     [Tags]    LOCAL_TEST
#     Insert data into Source     'source is db'    ${data_for_load}
#     Used URL                     https://example.com/
#     Load data to Layer           ${TEST_LAYER}


Test Case 2
    [Documentation]   Mocking Example
    Mock Requests Example


Test case 3
    [Documentation]  Check that connections work
    ${source_name}  Set Variable    UFFS
    ${layer_name}   Set Variable    MDM
    Connect to db    ${source_name}
    Load Data to Layer    ${source_name}    ${layer_name}
    Get data    ${source_name}    ${layer_name}
    Disconnect from db  ${source_name}
    ${source_name}  Set Variable    ORACLE19
    ${layer_name}   Set Variable    ODS
    Connect to db    ${source_name}
    Load Data to Layer    ${source_name}    ${layer_name}
    Get data    ${source_name}    ${layer_name}
    Disconnect from db    ${source_name}


Test 4
    [Documentation]  Load to source 
    [Tags]  WIP
    ${source_name}  Set Variable    UFFS
    Connect to db    ${source_name}
    Load data to Source     ${source_name}
    Disconnect from db      ${source_name}
