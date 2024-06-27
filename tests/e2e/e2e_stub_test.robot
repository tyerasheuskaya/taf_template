*** Settings ***
Documentation        Test case 1
Resource             ../../resources/test_cases/end_to_end.robot
Variables            ../../resources/utils/get_variables.py    test_source    TEST_ENV
Test Setup       On Test Start
Test Teardown    On Test Finish


*** Keywords ***
On Test Start
    Connect to db    sqlight
    Delete data from DB    '${CONNECTION}'    ${data_for_load}[schema]    ${data_for_load}[table_name]  ''

On Test Finish
    Delete data from DB    '${CONNECTION}'    ${data_for_load}[schema]    ${data_for_load}[table_name]  ''
    Disconnect from db  sqlight

*** Tasks ***
# ETE for Source 1
#     [Documentation]   End to End Test for Source "Source 1". Process "From Files update till DB Presentation level". 
#     [Tags]    QA
#     Insert data into Source     'source is files'    ${data_for_load} 
#     Connect to db                oracle 12
#     Used URL                     https://example.com/
#     Load data to Layer           ${MDM}    
#     Load data to Layer           ${STAGING}   
#     Load data to Layer           ${ODS}  
#     Load data to Layer           ${Presentation}
#     Disconnect from db           oracle 12   

# ETE for Source 2
#     [Documentation]   End to End Test for Source "Source 1". Process "From Source DB update till DB Presentation level". 
#     [Tags]    QA
#     nsert data into Source    'source is db'    ${data_for_load}
#     Connect to db                oracle 19
#     Used URL                     https://example.com/
#     Load data to Layer           ${MDM}    
#     Load data to Layer           ${STAGING}   
#     Load data to Layer           ${ODS}  
#     Load data to Layer           ${Presentation}
#     Disconnect from db           oracle 19   


Test Case 2
    [Documentation]   Test SQl light 
    [Tags]    LOCAL_TEST
    Log To Console  Test run
    Used URL    https://example.com/
     # Insert data into Source    'source is files'  ${data_for_load}
    Insert data into Source    'source is db'    ${data_for_load}
    Load data to Layer          ${TEST_LAYER}
#    Get Hash     ${data_for_load}

Test Case 3
    [Documentation]   Mocking Example
    Mock Requests Example