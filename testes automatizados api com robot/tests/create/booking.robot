*** Settings ***
Resource        ../../keywords/booking/booking_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Test Criar Booking
    ${response}=    Criar booking    /booking
    Validate Booking Creation Response    ${response}