*** Settings ***
Library    RequestsLibrary
Library    DateTime
Library    Collections
Resource    api_keywords.robot
Resource    produto_keywords.robot

*** Keywords ***
Criar Carrinho
    [Arguments]    ${id_produto}    ${quantidade}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${produto}=    Create Dictionary    idProduto=${id_produto}    quantidade=${quantidade}
    ${produtos}=    Create List    ${produto}
    ${dados}=    Create Dictionary    produtos=${produtos}
    ${response}=    Fazer Requisicao API    POST    /carrinhos    ${dados}    ${headers}
    [Return]    ${response}

Preparar Ambiente Carrinho
    ${token}=    Criar Usuario Admin E Fazer Login    AdminCarrinho
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${response_produto}=    Criar Produto    ProdutoCarrinho${timestamp}    100    Produto para carrinho    10    ${token}
    Should Be Equal As Numbers    ${response_produto.status_code}    201
    [Return]    ${token}    ${response_produto.json()}[_id]