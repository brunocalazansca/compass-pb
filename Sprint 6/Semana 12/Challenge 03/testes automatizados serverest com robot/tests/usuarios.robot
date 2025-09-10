*** Settings ***
Resource    ../keywords/api.robot
Resource    ../keywords/usuario.robot
Library    DateTime
Suite Setup    Create Session    serverest    http://localhost:3000

*** Variables ***
${ID_USUARIO}
${EMAIL_USUARIO}
${SENHA_USUARIO}

*** Test Cases ***
Teste POST Usuario Sucesso
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=Usuario Teste    email=teste${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso
    Should Contain    ${response.json()}    _id
    
    Set Global Variable    ${ID_USUARIO}    ${response.json()}[_id]
    Set Global Variable    ${EMAIL_USUARIO}    ${dados}[email]
    Set Global Variable    ${SENHA_USUARIO}    ${dados}[password]
    
    Validar Tamanho Senha    ${dados}[password]
    Validar Email Nao Gmail Hotmail    ${dados}[email]

Teste POST Usuario Email Duplicado
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=Usuario Teste    email=teste${timestamp}@empresa.com    password=12345    administrador=true
    ${response1}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    ${response2}=    Fazer Requisicao API    POST    /usuarios    ${dados}
    
    Should Be Equal As Numbers    ${response2.status_code}    400
    Should Be Equal    ${response2.json()}[message]    Este email já está sendo usado

Teste POST Usuario Email Gmail Nao Permitido
    ${dados}=    Create Dictionary    nome=Usuario Gmail    email=teste@gmail.com    password=12345    administrador=true
    Run Keyword And Expect Error    *    Validar Email Nao Gmail Hotmail    ${dados}[email]

Teste POST Usuario Senha Invalida
    ${dados}=    Create Dictionary    nome=Teste    email=teste@test.com    password=123    administrador=true
    Run Keyword And Expect Error    *    Validar Tamanho Senha    ${dados}[password]

Teste GET Usuario Por ID Sucesso
    [Documentation]    Usa o ID do usuário criado no primeiro teste
    ${response}=    Fazer Requisicao API    GET    /usuarios/${ID_USUARIO}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[nome]    Usuario Teste
    Should Be Equal    ${response.json()}[_id]    ${ID_USUARIO}
    Should Contain    ${response.json()}    administrador

Teste GET Usuario ID Inexistente
    ${response}=    Fazer Requisicao API    GET    /usuarios/123456789012345678901234
    
    Log    Status: ${response.status_code}
    Log    Response: ${response.text}
    
    Should Be Equal As Numbers    ${response.status_code}    400

Teste PUT Usuario Sucesso
    [Documentation]    Atualiza o usuário criado no primeiro teste
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=Usuario Atualizado    email=atualizado${timestamp}@empresa.com    password=54321    administrador=false
    ${response}=    Fazer Requisicao API    PUT    /usuarios/${ID_USUARIO}    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro alterado com sucesso
    
    Validar Tamanho Senha    ${dados}[password]
    Validar Email Nao Gmail Hotmail    ${dados}[email]

Teste PUT Usuario ID Inexistente
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=Usuario Teste    email=teste${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    PUT    /usuarios/123456789012345678901234    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso

Teste PUT Usuario Email Duplicado
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados1}=    Create Dictionary    nome=Usuario 1    email=user1${timestamp}@empresa.com    password=12345    administrador=true
    ${dados2}=    Create Dictionary    nome=Usuario 2    email=user2${timestamp}@empresa.com    password=12345    administrador=true
    
    ${response1}=    Fazer Requisicao API    POST    /usuarios    ${dados1}
    ${response2}=    Fazer Requisicao API    POST    /usuarios    ${dados2}
    
    Set To Dictionary    ${dados2}    email    user1${timestamp}@empresa.com
    ${response3}=    Fazer Requisicao API    PUT    /usuarios/${response2.json()}[_id]    ${dados2}
    
    Should Be Equal As Numbers    ${response3.status_code}    400
    Should Be Equal    ${response3.json()}[message]    Este email já está sendo usado

Teste GET Listar Todos Usuarios
    ${response}=    Fazer Requisicao API    GET    /usuarios
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()}    usuarios
    Should Contain    ${response.json()}    quantidade

Teste DELETE Usuario Sucesso
    ${response}=    Fazer Requisicao API    DELETE    /usuarios/${ID_USUARIO}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro excluído com sucesso

Teste DELETE Usuario ID Inexistente
    ${response}=    Fazer Requisicao API    DELETE    /usuarios/123456789012345678901234
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Nenhum registro excluído