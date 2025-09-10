*** Settings ***
Library    RequestsLibrary
Library    DateTime
Resource    api_keywords.robot

*** Keywords ***
Criar Usuario Para Login
    [Arguments]    ${nome}    ${email_prefix}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=${nome}    email=${email_prefix}${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    Should Be Equal As Numbers    ${response.status_code}    201
    [Return]    ${dados}[email]    ${dados}[password]

Fazer Login
    [Arguments]    ${email}    ${senha}
    ${dados_login}=    Create Dictionary    email=${email}    password=${senha}
    ${response}=    Fazer Requisicao API    POST    /login    ${dados_login}
    [Return]    ${response}