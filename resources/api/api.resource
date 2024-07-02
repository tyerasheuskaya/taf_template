*** Settings ***
Documentation    Base methods for APIs
Library          RequestsLibrary

*** Keywords ***
API GET Request
    [Arguments]  ${url}    ${endpoint}
    Create Session  api  ${url}
    ${resp}=  GET On Session  api  ${endpoint}
    Should Be Equal As Strings  ${resp.status_code}  200
    Log  ${resp.status_code}
    
API POST Request
    [Arguments]    ${url}    ${data}    ${endpoint}
    Create Session    api    ${url}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    api    ${endpoint}    data=${data}    headers=${headers}
    RETURN    ${response}

API PUT Request
    [Arguments]    ${url}    ${data}    ${endpoint}    ${headers}
    Create Session  api   ${url}  headers=${headers}
    ${response}=  PUT On Session  api  ${endpoint}  data=${data}
    Log  ${response.content}