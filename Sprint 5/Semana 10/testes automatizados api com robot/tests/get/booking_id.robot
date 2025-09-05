*** Settings ***
Resource        ../../resources/get_all_bookings.robot
Resource        ../../api/api_config.robot

*** Keywords ***
Pegar o id do primeiro booking
    ${endpoint}=    Set Variable    /booking
    ${response}=    Pegar todos os bookings    ${endpoint}
    Should Be Equal As Integers    ${response.status_code}    200
    ${bookings}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${bookings[0]}    bookingid
    ${first_booking}=    Set Variable    ${bookings[0]["bookingid"]}

Pegar booking por id
    [Arguments]    ${booking_id}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${response}=    GET    ${url}
    RETURN        ${response}

*** Test Cases ***
Buscar o booking pelo id
    ${booking_id}=    Set Variable    7
    ${res}=    Pegar booking por id    ${booking_id}
    Should Be Equal As Integers    ${res.status_code}    200
    ${booking_data}=    To JSON    ${res.content}
    Dictionary Should Contain Key    ${booking_data}    firstname
    Dictionary Should Contain Key    ${booking_data}    lastname