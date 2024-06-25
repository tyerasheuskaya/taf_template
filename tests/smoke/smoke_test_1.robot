*** Settings ***
Library            SeleniumLibrary
Suite Setup        Open Browser    ${URL}    Chrome
Suite Teardown     Close Browser

*** Variables ***
${URL}    https://www.example.com

*** Keywords ***
Stub Keyword
    Log    This is a stub keyword.

*** Test Cases ***
Stub Test Case
    [Tags]  QA
    Stub Keyword
