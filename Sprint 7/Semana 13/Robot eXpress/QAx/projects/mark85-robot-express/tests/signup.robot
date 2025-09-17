*** Settings ***
Documentation       Cenários de teste do cadastro do usuário
Resource            ../resources/base.robot

Test Setup          Start Session
Test Teardown       Take Screenshot

*** Test Cases ***
Deve poder cadastrar um novo usuario
    ${user}             Create Dictionary
    ...     name=Bruno
    ...     email=bruno@gmail.com
    ...     password=181409

    Remove user from database           ${user}[email]

    Go To                       http://localhost:3000/signup

    Wait for Elements State     css=h1      visible     5
    Get Text                    css=h1      equal       Faça seu cadastro

    Fill Text                   id=name         ${user}[name]
    Fill Text                   id=email        ${user}[email]
    Fill Text                   id=password     ${user}[password]

    Click                       id=buttonSignup

    Wait For Elements State     css=.notice p       visible     5
    Get Text                    css=.notice p       equal       Boas vindas ao Mark85, o seu gerenciador de tarefas.


Não deve permitir o cadastro com email duplicado
    [Tags]              duplicado

    ${user}             Create Dictionary
    ...                 name=Bruno Carritilha
    ...                 email=brunocarritilha@gmail.com
    ...                 password=181409

    Remove user from database       ${user}[email]
    Insert user into database       ${user}

    Go To                       http://localhost:3000/signup

    Wait for Elements State     css=h1      visible     5
    Get Text                    css=h1      equal       Faça seu cadastro

    Fill Text                   id=name         ${user}[name]
    Fill Text                   id=email        ${user}[email]
    Fill Text                   id=password     ${user}[password]

    Click                       id=buttonSignup

    Wait For Elements State     css=.notice p       visible     5
    Get Text                    css=.notice p       equal       Oops! Já existe uma conta com o e-mail informado.

