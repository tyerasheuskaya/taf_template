*** Settings ***
Documentation    Methods for connection to Databases
Library          DatabaseLibrary

*** Variables ***
${connections}      .${/}config${/}connections${/}${ENV}.cfg

*** Keywords ***
Connect to db
    [Arguments]    ${db_name}
    #  dbDriver=ODBC Driver 17 for SQL Server if {SQL Server} not working
    Connect To Database  dbConfigFile=${connections}  alias=${db_name}
    Log To Console  ${\n}Connected to ${db_name} successfully!

Disconnect from db
    [Arguments]  ${db_name}
    Disconnect From Database    alias=${db_name}
    Log To Console  ${\n}Disconnected from ${db_name} successfully!
