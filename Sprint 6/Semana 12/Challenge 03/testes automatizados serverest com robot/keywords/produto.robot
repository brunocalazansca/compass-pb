*** Settings ***
Library    RequestsLibrary
Library    DateTime
Library    Collections
Resource    api.robot

*** Keywords ***
Criar Usuario Admin E Fazer Login
    [Arguments]    ${nome_prefix}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_user}=    Create Dictionary    nome=${nome_prefix} ${timestamp}    email=${nome_prefix}${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados_user}
    Should Be Equal As Numbers    ${response.status_code}    201
    
    ${dados_login}=    Create Dictionary    email=${dados_user}[email]    password=${dados_user}[password]
    ${response_login}=    Fazer Requisicao API    POST    /login    ${dados_login}
    Should Be Equal As Numbers    ${response_login.status_code}    200
    [Return]    ${response_login.json()}[authorization]

Criar Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${dados}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${response}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    [Return]    ${response}