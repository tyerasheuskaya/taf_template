*** Settings ***
Documentation    Stub test for Reconciliation
Resource         ../../resources/test_cases/regression.robot
Suite Setup      Connect to db  ORACLE19
Test Teardown    Disconnect from db  ORACLE19


*** Variables ***
&{data}    LT1=${10}

*** Test Cases ***

Run prepared queries
    [Documentation]  Run tests by prepared queries
    [Template]  The query result for ${table_name} should be ${expected}
    FOR  ${table}  ${result}  IN  &{data}
         ${table}    ${result}
    END


