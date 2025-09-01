*** Settings ***
Resource        ../api/api_config.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Criar token
    [Arguments]     ${endpoint}     ${username}     ${password}
    ${url}=     Montar url      ${endpoint}
    Create Session      booking     ${BASE_URL}     headers=${HEADERS}
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    booking    ${endpoint}    json=${payload}
    ${json}=    To JSON    ${response.content}
    ${token}=    Get From Dictionary    ${json}    token
    Set Global Variable    ${TOKEN}    ${token}
    RETURN        ${TOKEN}