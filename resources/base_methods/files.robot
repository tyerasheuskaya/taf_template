*** Settings ***
Documentation    Base methods for files
Library    OperatingSystem
Library    pandas
Library    Collections
Library    String

*** Keywords ***
Add data to file
# Write data to file
    [Arguments]    ${filename}    ${data_to_be_added}
    ${add}=  Get File  ${data_to_be_added}
    Append To File    ${filename}    ${add}
    

Load data from file Into DataFrame
# Get data from file and load to data frame
    [Arguments]  ${filename}
    ${data}=  Evaluate  pandas.read_csv(r'${filename}')  pandas
    RETURN  ${data}
