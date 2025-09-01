*** Settings ***
Resource        ../../resources/get_all_bookings.robot

*** Test Cases ***
Teste pegar todos os bookings
    ${endpoint}=    Set Variable    /booking
    ${response}=    Pegar todos os bookings    ${endpoint}
    Should Be Equal As Integers    ${response.status_code}    200
    ${bookings}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${bookings[0]}    bookingid