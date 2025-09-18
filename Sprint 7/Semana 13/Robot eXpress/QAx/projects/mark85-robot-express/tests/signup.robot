*** Settings ***
Documentation       Cenários de teste do cadastro do usuário
Resource            ../resources/base.resource

Test Setup          Start Session
Test Teardown       Take Screenshot

*** Test Cases ***
Deve poder cadastrar um novo usuario
    ${user}             Create Dictionary
    ...     name=Bruno
    ...     email=bruno@gmail.com
    ...     password=181409

    Remove user from database           ${user}[email]

    Go to signup page
    Submit signup form                  ${user}
    Notice should be                    Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir o cadastro com email duplicado
    [Tags]              duplicado

    ${user}             Create Dictionary
    ...                 name=Bruno Carritilha
    ...                 email=brunocarritilha@gmail.com
    ...                 password=181409

    Remove user from database       ${user}[email]
    Insert user into database       ${user}

    Go to signup page
    Submit signup form                  ${user}
    Notice should be                    Oops! Já existe uma conta com o e-mail informado.
