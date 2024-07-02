*** Settings ***
Documentation        Test case 1
Resource             ../../resources/test_cases/end_to_end.robot
Variables            ../../configurations/connestions/${ENV}_UFFS.yaml


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
    Connect to db    UFFS
    Get data    ${MDM}
    Disconnect from db  UFFS
    Connect to db    ORACLE19
    Get data    ${ODS}
    Disconnect from db    ORACLE19


Test 4
    [Documentation]  Load to source 
    [Tags]  WIP
#    Connect to db    UFFS
    Load data to Source  ${Source}
    Disconnect from db  UFFS
