*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Fazer Requisicao API
    [Arguments]    ${metodo}    ${endpoint}    ${dados}=${EMPTY}    ${headers}=${EMPTY}
    [Documentation]    Keyword reutilizável para fazer requisições HTTP na API
    
    Create Session    serverest    ${BASE_URL}
    
    IF    '${metodo}' == 'GET'
        ${response}=    GET On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    ELSE IF    '${metodo}' == 'POST'
        ${response}=    POST On Session    serverest    ${endpoint}    json=${dados}    headers=${headers}    expected_status=any
    ELSE IF    '${metodo}' == 'PUT'
        ${response}=    PUT On Session    serverest    ${endpoint}    json=${dados}    headers=${headers}    expected_status=any
    ELSE IF    '${metodo}' == 'DELETE'
        ${response}=    DELETE On Session    serverest    ${endpoint}    headers=${headers}    expected_status=any
    END
    
    RETURN    ${response}