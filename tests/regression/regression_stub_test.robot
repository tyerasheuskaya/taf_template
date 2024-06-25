*** Settings ***
Documentation    Stub test for Reconciliation
Resource         ../../resources/test_cases/regression.robot
Resource         ../../configurations/connections/connections_qa.robot
Suite Setup      Connect to db  sqlight
Test Teardown    Disconnect from db  sqlight


*** Variables ***
&{data}    Album=${347}   Playlist=${18}

*** Test Cases ***

Run prepared queries
    [Documentation]  Run tests by prepared queries
    [Template]  The query result for ${table_name} should be ${expected}
    FOR  ${table}  ${result}  IN  &{data}
         ${table}    ${result}
    END


