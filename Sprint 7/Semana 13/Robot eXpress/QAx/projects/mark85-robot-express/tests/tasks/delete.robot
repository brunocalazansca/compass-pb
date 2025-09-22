*** Settings ***
Documentation       Cenários de teste de remoção de terefas
Resource            ../../resources/base.resource
Test Setup          Start Session
Test Teardown       Take Screenshot


*** Test Cases ***
Deve poder apagar uma tarefa quando indesejada
    ${data}        Get fixture        tasks        delete

    Clean user from database          ${data}[user][email]
    Insert user into database         ${data}[user]

    POST user session                 ${data}[user]
    POST a new task                   ${data}[task]

    Submit login form                 ${data}[user]
    User should be logged in          ${data}[user][name]

    Request removal                   ${data}[task][name]
    Task should not exist             ${data}[task][name]
