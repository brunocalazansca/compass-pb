*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}     https://restful-booker.herokuapp.com
&{HEADERS}      Accept=application/json    Content-Type=application/json

*** Keywords ***
Montar url
    [Arguments]     ${endpoint}
    ${url}=     Catenate    SEPARATOR=    ${BASE_URL}    ${endpoint}
    RETURN    ${url}

Montar headers com cookie
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    &{HEADERS}    Cookie=token=${token}
    RETURN    ${headers}
