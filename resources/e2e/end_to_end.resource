*** Settings ***
Documentation    End to End test case started from file till Presentation layer
Resource         ../../resources/db/connectors.resource
Resource         ../../resources/db/db.resource
Resource         ../../resources/api/api.resource
Resource         ../../resources/os/files.resource
Variables        ../../config/e2e/${ENV}.yaml


*** Keywords ***
Load data to Source
    [Documentation]  Add data on source depend on source type lag: db, csv
    [Arguments]     ${source_name}
    ${source}   Create Dictionary   &{${source_name}}
    @{source_types}     Set Variable  ${source.type}
    # Define a type of the source
    FOR    ${source_type}    IN    @{source_types}
        ${data_to_insert_path}  Set Variable  .${/}test_data${/}e2e${/}${source_name}${/}${source_type}
        IF    '${source_type}' == 'db'
            ${schema_name}  Set Variable  ${source.${source_type}.schema}
            FOR    ${table_name}    IN   @{source.${source_type}.table_name}
                # Read data from csv file
                ${data}   Get data from CSV   ${data_to_insert_path}${/}${table_name}.csv
                    # Collect headers and join them in one row 
                    ${headers}  Catenate    SEPARATOR=,    @{data.columns}
                    ${counts}   Get Length  ${data}
                    # Take each row and generate inserts
                    FOR  ${i}  IN RANGE  0  ${counts}
                        ${values}   Catenate  SEPARATOR=','    @{data}[${i}]
                        # Log To Console   '${values}'
                        Insert data  ${source_name}  ${schema_name}  ${table_name}  ${headers}  '${values}'
                    END                    
            END
        ELSE IF  '${source_type}' == 'csv'
            ${csv_sources}  Set variable  ${source.${source_type}}
            FOR    ${key}    ${value}    IN    &{csv_sources}
                Add data to file    ${value.source_file_path}    ${data_to_insert_path}${/}${key}.csv
            END
        ELSE
            Log To Console    Source ${source_type} is not defined
        END
    END

Load Data to Layer
    [Documentation]  Load data to layer
    [Arguments]    ${source_name}  ${layers}  ${alias}  ${mock}=False
    FOR    ${layer}    IN    @{layers}
        ${source}   Create Dictionary   &{${source_name}.${layer}}
        FOR    ${path}    IN    @{source.path}
            Run Keyword If  ${mock}  Mock Request   ${path}  ELSE  API GET Request  ${source.host}  ${path}
        END
        FOR    ${query}    IN    @{source.query}
            ${path}  Set Variable  .${/}resources${/}db${/}queries${/}e2e${/}${query}.sql
            Run script from file    ${path}    ${alias}
        END
    END

Mock Requests Example
    Create Mock Session     ${MOCK_SERVER}
    Reset All Requests
    Create Default Mock Expectation    GET    /service_one     response_body={"key": "some value service 1"}
    Create Default Mock Expectation    GET    /service_two     response_body={"key": "some value service 2"}
    ${service_one_resnonse}     GET  ${MOCK_SERVER}/service_one
    ${service_two_resnonse}     GET  ${MOCK_SERVER}/service_two
    ${service_one_resnonse_body}    Set Variable     ${service_one_resnonse.json()}

Get data
    [Arguments]    ${source_name}   ${layer_name}
    ${layer_params}  Create Dictionary    &{${source_name}}[${layer_name}]
    ${result}   Get Row Counts   ${source_name}  ${layer_params}[schema]  ${layer_params}[table_name]
