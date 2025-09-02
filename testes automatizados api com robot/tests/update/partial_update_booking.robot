*** Settings ***
Resource        ../../keywords/booking/booking_keywords.robot
Resource        ../../keywords/auth/token_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Resource        ../../keywords/data/fake_data_generator.robot
Resource        ../../config/test_config.robot
Library         Collections
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Atualizar booking parcialmente
    ${token}=    Criar token    /auth    ${USERNAME}    ${PASSWORD}

    ${all_bookings}=    Pegar todos os bookings    /booking
    ${first_booking}=   Get From List    ${all_bookings.json()}    0
    ${booking_id}=      Set Variable    ${first_booking['bookingid']}

    ${body_dict}=    Generate Fake Booking Data    partial
    ${body}=    Evaluate    json.dumps(${body_dict})    json

    ${response}=    Atualizar booking parcialmente    ${booking_id}    ${token}    ${body}
    Validate Response Status    ${response}    200
    ${updated}=    To JSON    ${response.content}
    Should Be Equal    ${updated['firstname']}    ${body_dict['firstname']}
    Should Be Equal    ${updated['lastname']}     ${body_dict['lastname']}