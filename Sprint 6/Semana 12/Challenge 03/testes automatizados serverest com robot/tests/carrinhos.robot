*** Settings ***
Resource    ../keywords/api.robot
Library    DateTime
Library    Collections
Suite Setup    Create Session    serverest    http://localhost:3000

*** Variables ***
${TOKEN_AUTH}
${ID_PRODUTO}
${ID_CARRINHO}

*** Test Cases ***
Criar Usuario Admin Para Carrinho
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_user}=    Create Dictionary    nome=Admin Carrinho    email=carrinho${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados_user}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    
    ${dados_login}=    Create Dictionary    email=${dados_user}[email]    password=${dados_user}[password]
    ${response_login}=    Fazer Requisicao API    POST    /login    ${dados_login}
    
    Should Be Equal As Numbers    ${response_login.status_code}    200
    Set Global Variable    ${TOKEN_AUTH}    ${response_login.json()}[authorization]

Criar Produto Para Carrinho
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=ProdutoCarrinho${timestamp}    preco=100    descricao=Produto para carrinho    quantidade=10
    ${response}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Set Global Variable    ${ID_PRODUTO}    ${response.json()}[_id]

Teste POST Carrinho Sucesso
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${produto}=    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${produtos}=    Create List    ${produto}
    ${dados}=    Create Dictionary    produtos=${produtos}
    ${response}=    Fazer Requisicao API    POST    /carrinhos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso
    Should Contain    ${response.json()}    _id
    
    Set Global Variable    ${ID_CARRINHO}    ${response.json()}[_id]

Teste POST Carrinho Sem Token
    ${produto}=    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${produtos}=    Create List    ${produto}
    ${dados}=    Create Dictionary    produtos=${produtos}
    ${response}=    Fazer Requisicao API    POST    /carrinhos    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste POST Carrinho Duplicado
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${produto}=    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${produtos}=    Create List    ${produto}
    ${dados}=    Create Dictionary    produtos=${produtos}
    ${response}=    Fazer Requisicao API    POST    /carrinhos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    400
    Should Be Equal    ${response.json()}[message]    Não é permitido ter mais de 1 carrinho

Teste GET Carrinho Por ID Sucesso
    ${response}=    Fazer Requisicao API    GET    /carrinhos/${ID_CARRINHO}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[_id]    ${ID_CARRINHO}
    Should Contain    ${response.json()}    produtos
    Should Contain    ${response.json()}    precoTotal
    Should Contain    ${response.json()}    quantidadeTotal
    Should Contain    ${response.json()}    idUsuario

Teste GET Carrinho ID Inexistente
    ${response}=    Fazer Requisicao API    GET    /carrinhos/123456789012345678901234
    
    Should Be Equal As Numbers    ${response.status_code}    400

Teste GET Listar Todos Carrinhos
    ${response}=    Fazer Requisicao API    GET    /carrinhos
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()}    carrinhos
    Should Contain    ${response.json()}    quantidade

Teste DELETE Cancelar Compra Sucesso
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/cancelar-compra    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro excluído com sucesso. Estoque dos produtos reabastecido

Teste DELETE Cancelar Compra Sem Token
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/cancelar-compra
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste DELETE Cancelar Compra Sem Carrinho
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/cancelar-compra    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Não foi encontrado carrinho para esse usuário

Criar Novo Carrinho Para Concluir
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${produto}=    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${produtos}=    Create List    ${produto}
    ${dados}=    Create Dictionary    produtos=${produtos}
    ${response}=    Fazer Requisicao API    POST    /carrinhos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    201

Teste DELETE Concluir Compra Sucesso
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/concluir-compra    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro excluído com sucesso

Teste DELETE Concluir Compra Sem Token
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/concluir-compra
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste DELETE Concluir Compra Sem Carrinho
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /carrinhos/concluir-compra    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Não foi encontrado carrinho para esse usuário