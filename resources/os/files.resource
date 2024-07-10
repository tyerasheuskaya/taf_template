*** Settings ***
Documentation    Base methods for files
Library    OperatingSystem
Library    RPA.Tables
Library    yaml

*** Keywords ***
Get data from CSV 
    [Arguments]     ${file} 
    ${data}  Read table from CSV  ${file}   header=True
    RETURN  ${data}

Add data to file
    [Arguments]    ${file}    ${data_to_be_added}
    ${add}  Get File  ${data_to_be_added}
    Append To File    ${file}    ${add}

Get data From YAML
    [Arguments]     ${file} 
    ${data}   Get File   ${file}
    ${yaml}   Safe Load  ${data}
    RETURN  ${yaml}