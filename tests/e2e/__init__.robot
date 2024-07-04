*** Settings ***
Resource         ../../resources/api/api.resource
Resource         ../../resources/db/connectors.resource


Suite Setup     Init Mock Server and Connect to Databases

Suite Teardown  Shutdown Mock Server and Disconnect from Databases


*** Keywords ***
Init Mock Server and Connect to Databases
    Init Mock Server
    @{databases}    Create List     ORACLE19    UFFS
    FOR     ${database}     IN      @{databases}
        Connect to db    ${database}
    END

Shutdown Mock Server and Disconnect from Databases
    Shutdown Mock Server
    @{databases}    Create List     ORACLE19    UFFS
    FOR     ${database}     IN      @{databases}
        Disconnect from db    ${database}
    END