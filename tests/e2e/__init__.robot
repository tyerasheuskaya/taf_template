*** Settings ***
Resource            ../../resources/api/api.resource

Suite Setup         Init Mock Server

Suite Teardown      Shutdown Mock Server