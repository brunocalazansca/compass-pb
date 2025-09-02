*** Settings ***
Resource        ../../keywords/auth/token_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Resource        ../../config/test_config.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Teste criar token
    ${token}=    Criar token    /auth    ${USERNAME}    ${PASSWORD}
    Should Not Be Empty    ${token}
