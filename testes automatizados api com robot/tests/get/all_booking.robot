*** Settings ***
Resource        ../../keywords/booking/booking_keywords.robot
Resource        ../../keywords/validation/response_validation.robot
Resource        ../../keywords/setup_teardown.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Teste pegar todos os bookings
    ${response}=    Pegar todos os bookings    /booking
    Validate Response Status    ${response}    200
    ${bookings}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${bookings[0]}    bookingid