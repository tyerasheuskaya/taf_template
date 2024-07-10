*** Settings ***
Resource         ../../resources/api/api.resource
Resource         ../../resources/db/connectors.resource


Suite Setup     Connect to Databases

Suite Teardown  Disconnect from Databases


*** Keywords ***
Connect to Databases
    @{databases}    Create List     ORACLE19
    FOR     ${database}     IN      @{databases}
        Connect to db    ${database}
    END

Disconnect from Databases
    @{databases}    Create List     ORACLE19
    FOR     ${database}     IN      @{databases}
        Disconnect from db    ${database}
    END