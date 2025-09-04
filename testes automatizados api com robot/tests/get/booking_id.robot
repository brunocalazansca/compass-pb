*** Settings ***
Resource        ../../keywords/booking/booking_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Buscar o booking pelo id
    ${booking_id}    Set Variable    7
    ${response}    Pegar booking por id    ${booking_id}
    Validate Response Status    ${response}    200
    ${booking_data}    To JSON    ${response.content}
    Validate Booking Response Structure    ${booking_data}