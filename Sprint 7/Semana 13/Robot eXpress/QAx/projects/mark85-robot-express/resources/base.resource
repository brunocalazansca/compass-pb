*** Settings ***
Documentation   Arquivo base
Library         libs/database.py
Library         Browser
Resource        env.resource
Resource        pages/SignupPage.resource


*** Keywords ***
Start Session
    New Browser     browser=chromium    headless=False
    New Page        ${BASE_URL}

Short password
    [Arguments]         ${short_pass}

    ${user}             Create Dictionary
    ...                 name=Bruno
    ...                 email=bruno@gmail.com
    ...                 password=${short_pass}

    Go to signup page
    Submit signup form                  ${user}

    Alert should be                     Informe uma senha com pelo menos 6 digitos