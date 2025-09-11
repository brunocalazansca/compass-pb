*** Settings ***
Resource    ../keywords/api.robot
Library    DateTime
Library    Collections
Suite Setup    Create Session    serverest    http://localhost:3000

*** Variables ***
${TOKEN_AUTH}
${ID_PRODUTO}

*** Test Cases ***
Criar Usuario Admin Para Produtos
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_user}=    Create Dictionary    nome=Admin Produtos    email=admin${timestamp}@empresa.com    password=12345    administrador=true
    ${response}=    Fazer Requisicao API    POST    /usuarios    ${dados_user}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    
    ${dados_login}=    Create Dictionary    email=${dados_user}[email]    password=${dados_user}[password]
    ${response_login}=    Fazer Requisicao API    POST    /login    ${dados_login}
    
    Should Be Equal As Numbers    ${response_login.status_code}    200
    Set Global Variable    ${TOKEN_AUTH}    ${response_login.json()}[authorization]

Teste POST Produto Sucesso
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=Produto${timestamp}    preco=100    descricao=Descrição do produto    quantidade=10
    ${response}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal    ${response.json()}[message]    Cadastro realizado com sucesso
    Should Contain    ${response.json()}    _id
    
    Set Global Variable    ${ID_PRODUTO}    ${response.json()}[_id]

Teste POST Produto Sem Token
    ${dados}=    Create Dictionary    nome=Produto Sem Token    preco=50    descricao=Teste sem auth    quantidade=5
    ${response}=    Fazer Requisicao API    POST    /produtos    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste POST Produto Nome Duplicado
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=ProdutoDup${timestamp}    preco=100    descricao=Produto original    quantidade=10
    ${response1}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    ${response2}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response2.status_code}    400
    Should Be Equal    ${response2.json()}[message]    Já existe produto com esse nome

Teste GET Listar Todos Produtos
    ${response}=    Fazer Requisicao API    GET    /produtos
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()}    produtos
    Should Contain    ${response.json()}    quantidade

Teste GET Produto Por ID Sucesso
    Skip If    '${ID_PRODUTO}' == '${EMPTY}'    Produto não foi criado
    ${response}=    Fazer Requisicao API    GET    /produtos/${ID_PRODUTO}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[_id]    ${ID_PRODUTO}
    Should Contain    ${response.json()}    nome
    Should Contain    ${response.json()}    preco
    Should Contain    ${response.json()}    descricao
    Should Contain    ${response.json()}    quantidade

Teste GET Produto ID Inexistente
    ${response}=    Fazer Requisicao API    GET    /produtos/123456789012345678901234
    
    Should Be Equal As Numbers    ${response.status_code}    400

Teste PUT Produto Sucesso
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=ProdutoAtualizado${timestamp}    preco=200    descricao=Produto atualizado    quantidade=20
    ${response}=    Fazer Requisicao API    PUT    /produtos/${ID_PRODUTO}    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro alterado com sucesso

Teste PUT Produto Sem Token
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados}=    Create Dictionary    nome=ProdutoSemToken${timestamp}    preco=150    descricao=Teste sem auth    quantidade=15
    ${response}=    Fazer Requisicao API    PUT    /produtos/${ID_PRODUTO}    ${dados}
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste PUT Produto ID Inexistente
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=ProdutoNovo${timestamp}    preco=300    descricao=Produto novo    quantidade=30
    ${response}=    Fazer Requisicao API    PUT    /produtos/123456789012345678901234    ${dados}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    400

Teste PUT Produto Nome Duplicado
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    
    ${dados1}=    Create Dictionary    nome=Produto1${timestamp}    preco=100    descricao=Produto 1    quantidade=10
    ${dados2}=    Create Dictionary    nome=Produto2${timestamp}    preco=200    descricao=Produto 2    quantidade=20
    
    ${response1}=    Fazer Requisicao API    POST    /produtos    ${dados1}    ${headers}
    ${response2}=    Fazer Requisicao API    POST    /produtos    ${dados2}    ${headers}
    
    Set To Dictionary    ${dados2}    nome    Produto1${timestamp}
    ${response3}=    Fazer Requisicao API    PUT    /produtos/${response2.json()}[_id]    ${dados2}    ${headers}
    
    Should Be Equal As Numbers    ${response3.status_code}    400
    Should Be Equal    ${response3.json()}[message]    Já existe produto com esse nome

Teste DELETE Produto Sucesso
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /produtos/${ID_PRODUTO}    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Registro excluído com sucesso

Teste DELETE Produto Sem Token
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${dados}=    Create Dictionary    nome=ProdutoDel${timestamp}    preco=100    descricao=Produto para deletar    quantidade=10
    ${response_create}=    Fazer Requisicao API    POST    /produtos    ${dados}    ${headers}
    
    ${response}=    Fazer Requisicao API    DELETE    /produtos/${response_create.json()}[_id]
    
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Teste DELETE Produto ID Inexistente
    ${headers}=    Create Dictionary    Authorization=${TOKEN_AUTH}
    ${response}=    Fazer Requisicao API    DELETE    /produtos/123456789012345678901234    ${EMPTY}    ${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    400