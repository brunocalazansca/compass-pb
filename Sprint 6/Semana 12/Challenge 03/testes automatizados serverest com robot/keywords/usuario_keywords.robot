*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
Validar Email Nao Gmail Hotmail
    [Arguments]    ${email}
    Should Not Contain    ${email}    gmail.com
    Should Not Contain    ${email}    hotmail.com

Validar Tamanho Senha
    [Arguments]    ${senha}
    ${tamanho}=    Get Length    ${senha}
    Should Be True    ${tamanho} >= 5 and ${tamanho} <= 10