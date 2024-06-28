*** Settings ***
Documentation    End to End test case started from file till Presentation layer
Resource         ../../resources/connectors/connectors.robot
Resource         ../../resources/base_methods/queries.robot
Resource         ../../resources/base_methods/apis.robot
Resource         ../../resources/base_methods/files.robot
Library          MockServerLibrary

*** Variables ***
${CONNECTION}
${URL}
${MOCK_SERVER}  http://localhost:1080/

*** Keywords ***
Used URL
    [Arguments]  ${value}
    Set Global Variable  ${URL}  ${value}

Insert data into Source
    [Documentation]  Add data on source depend on flag: source is files, source is db
    [Arguments]   ${flag}   ${data_for_load}
    IF  ${flag} == 'source is files'   
        Add data to file    ${data_for_load}[source_file]   ${data_for_load}[data_to_insert]
    ELSE IF  ${flag} == 'source is db'
        Insert data into table  ${CONNECTION}   ${data_for_load}[schema]  ${data_for_load}[table_name]  ${data_for_load}[data_to_insert]
    ELSE
        Log To Console  Unknown type of source
    END

Load Data to Layer
    [Documentation]  Loade data to layer
    [Arguments]    ${layer_params}
    Log To Console  ${layer_params}
    ${api_resnonse}=  API GET Request  ${URL}  ${layer_params}[api]
    ${result}=  Get data from DB  ${CONNECTION}   ${layer_params}[schema]  ${layer_params}[table_name]  ${layer_params}[where_clause]
    Should Not Be Equal  ${result}  ${0}   #Test type of return

Mock Requests Example
    Create Mock Session     ${MOCK_SERVER}
    Reset All Requests
    Create Default Mock Expectation    GET    /service_one     response_body={"key": "some value service 1"}
    Create Default Mock Expectation    GET    /service_two     response_body={"key": "some value service 2"}
    ${service_one_resnonse} =  GET  ${MOCK_SERVER}/service_one
    ${service_two_resnonse} =  GET  ${MOCK_SERVER}/service_two
    ${service_one_resnonse_body}    Set Variable     ${service_one_resnonse.json()}

Get data
    [Arguments]    ${layer_params}
    ${result}=  Get Row Counts   ${CONNECTION}  ${layer_params}[schema]  ${layer_params}[table_name]
    Log To Console    ${result}