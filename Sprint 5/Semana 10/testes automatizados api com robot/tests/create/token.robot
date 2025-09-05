*** Settings ***
Resource        ../../api/api_config.robot
Resource        ../../resources/get_token.robot

*** Test Cases ***
Teste criar token
    ${endpoint}=    Set Variable    /auth
    ${username}=    Set Variable    admin
    ${password}=    Set Variable    password123

    Criar token     ${endpoint}     ${username}     ${password}
