*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime
Resource    api.robot

*** Keywords ***
Criar Usuario
    [Arguments]    ${nome}    ${email_prefix}    ${senha}    ${admin}=true
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=${nome}    email=${email_prefix}${timestamp}@empresa.com    password=${senha}    administrador=${admin}
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    [Return]    ${response}    ${dados}