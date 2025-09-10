*** Settings ***
Resource    ../keywords/api.robot
Library    DateTime
Suite Setup    Create Session    serverest    http://localhost:3000

*** Variables ***
${EMAIL_USUARIO}
${SENHA_USUARIO}

*** Test Cases ***
Criar Usuario Para Login
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=Usuario Login    email=login${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Set Global Variable    ${EMAIL_USUARIO}    ${dados}[email]
    Set Global Variable    ${SENHA_USUARIO}    ${dados}[password]

Teste POST Login Sucesso
    ${dados_login}=    Create Dictionary    email=${EMAIL_USUARIO}    password=${SENHA_USUARIO}
    ${response}=    Fazer Requisicao API    POST    /login    ${dados_login}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Login realizado com sucesso
    Should Contain    ${response.json()}    authorization

Teste POST Login Email Inexistente
    ${dados_login}=    Create Dictionary    email=inexistente@teste.com    password=12345
    ${response}=    Fazer Requisicao API    POST    /login    ${dados_login}
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Email e/ou senha inválidos

Teste POST Login Senha Incorreta
    ${dados_login}=    Create Dictionary    email=${EMAIL_USUARIO}    password=senhaerrada
    ${response}=    Fazer Requisicao API    POST    /login    ${dados_login}
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Email e/ou senha inválidos