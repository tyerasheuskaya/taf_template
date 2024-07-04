*** Settings ***
Resource            ../../resources/e2e/end_to_end.resource

Suite Setup         Init Mock Server and Connect to Databases

Suite Teardown      Shutdown Mock Server and Disconnect from Databases