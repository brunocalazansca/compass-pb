*** Settings ***
Documentation   Arquivo base
Library         libs/database.py
Library         Browser
Resource        env.resource
Resource        pages/SignupPage.resource
Resource        pages/LoginPage.resource
Resource        pages/components/Notice.resource
Resource        pages/components/Alert.resource
Resource        pages/components/Header.resource


*** Keywords ***
Start Session
    New Browser     browser=chromium    headless=False
    New Page        ${BASE_URL}
