*** Settings ***
Documentation    Methods for connection to Databases
Library          DatabaseLibrary
Library          String
Library          OperatingSystem

*** Variables ***
${connections}      ./configurations/connections/connections_qa.cfg

*** Keywords ***
Connect to db
    [Arguments]    ${db_name}
    Set Global Variable  ${CONNECTION}
    Connect To Database  dbConfigFile=${connections}  alias=${db_name}
    Log To Console  Connected to ${db_name} successfully!

Disconnect from db
    [Arguments]  ${db_name}
    Disconnect From Database    alias=${db_name}
    Log To Console  Disconnected from ${db_name} successfully!