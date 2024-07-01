*** Settings ***
Documentation    Base methods for files
Library    OperatingSystem
Library    Collections
Library    RPA.Tables

*** Keywords ***
Get data from CSV 
    [Arguments]     ${file} 
    # ${data}=  Get File  ${file}
    ${data}  Read table from CSV  ${file}   header=True
    RETURN  ${data}

Add data to file
# Write data to file
    [Arguments]    ${file}    ${data_to_be_added}
    ${add}=  Get File  ${data_to_be_added}
    Append To File    ${file}    ${add}
