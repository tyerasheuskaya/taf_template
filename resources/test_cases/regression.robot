*** Settings ***
Documentation    End to End test case started from file till Presentation layer
Resource         ../../resources/connectors/connectors.robot
Resource         ../../resources/base_methods/files.robot
Resource         ../../resources/base_methods/db.robot


*** Variables ***
${CONNECTION}
${path_to_queries}    resources/queries/regression

*** Keywords ***
The query result for ${table_name} should be ${expected}
    ${query}=  Get File    ${path_to_queries}/${table_name}.sql
    ${result}=  Query    ${query}    ${CONNECTION}
    Should Be Equal    ${result}[0][0]     ${expected}