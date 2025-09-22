*** Settings ***
Documentation       Cenários de teste de atualização de terefas
Resource            ../../resources/base.resource
Test Setup          Start Session
Test Teardown       Take Screenshot


*** Test Cases ***
Deve poder marcar uma tarefa quando concluida
    ${data}        Get fixture        tasks        done

    Clean user from database          ${data}[user][email]
    Insert user into database         ${data}[user]

    POST user session                 ${data}[user]
    POST a new task                   ${data}[task]

    Submit login form                 ${data}[user]
    User should be logged in          ${data}[user][name]

    Mark task as completed            ${data}[task][name]
    Task should be complete           ${data}[task][name]
