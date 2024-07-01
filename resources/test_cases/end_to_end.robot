*** Settings ***
Documentation    End to End test case started from file till Presentation layer
Resource         ../../resources/connectors/connectors.robot
Resource         ../../resources/base_methods/db.robot
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
Load data to Source
    [Documentation]  Add data on source depend on source type lag: db, csv
    [Arguments]  ${source_info}
    @{source_types}=  Set Variable  ${source_info}[type]
    # Define a type of the source
    FOR    ${source_type}    IN    @{source_types}
        IF    '${source_type}' == 'db'
            ${schema_name}=   Set Variable  ${source_info}[${source_type}][schema]
            FOR    ${table_name}    IN   @{source_info}[${source_type}][table_name]
                # Read data from csv file
                ${data}=    Get data from CSV  ./test_data/e2e/uffs/${source_type}/${table_name}.csv
                    # Collect headers and join them in one row 
                    ${headers}=    Catenate    SEPARATOR=,    @{data.columns}
                    ${counts}=  Get Length  ${data}
                    # Take each row and generate inserts
                    FOR  ${i}  IN RANGE  0  ${counts}
                        ${values}=   Catenate  SEPARATOR=','    @{data}[${i}]
                        # Log To Console   '${values}'
                        Insert data  ${CONNECTION}  ${schema_name}  ${table_name}  ${headers}  '${values}'
                    END                    
            END
        ELSE IF  '${source_type}' == 'csv'
            ${csv_sources}=  Set variable  ${source_info}[${source_type}]
            FOR    ${key}    ${value}    IN    &{csv_sources}
                Add data to file    ${value}[source_file_path]   ${value}[data_to_insert_path]
            END
        ELSE
            Log To Console    Source ${source_type} is not defined
        END
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