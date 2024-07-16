*** Settings ***
Documentation    Base methods for files
Library    OperatingSystem
Library    yaml

*** Keywords ***
Add data to file
    [Arguments]    ${file}    ${data_to_be_added}
    ${add}  Get File  ${data_to_be_added}
    Append To File    ${file}    ${add}

Get data From YAML
    [Arguments]     ${file} 
    ${data}   Get File   ${file}
    ${yaml}   Safe Load  ${data}
    RETURN  ${yaml}