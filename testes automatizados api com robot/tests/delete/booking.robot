*** Settings ***
Resource        ../../keywords/booking/booking_keywords.robot
Resource        ../../keywords/auth/token_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Resource        ../../config/test_config.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Deletar primeiro booking
    ${token}=    Criar token    /auth    ${USERNAME}    ${PASSWORD}
    ${all_bookings}=    Pegar todos os bookings    /booking
    ${first_booking}=   Get From List    ${all_bookings.json()}    0
    ${booking_id}=      Set Variable    ${first_booking['bookingid']}
    ${response}=        Deletar booking    ${booking_id}    ${token}
    Validate Response Status    ${response}    201
