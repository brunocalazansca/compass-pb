*** Settings ***
Resource        ../../api/api_config.robot
Resource        ../../resources/get_all_bookings.robot
Resource        ../../resources/get_token.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Deletar booking
    [Arguments]    ${booking_id}    ${token}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${response}=    DELETE    ${url}    headers=${headers}
    RETURN        ${response}

*** Test Cases ***
Deletar primeiro booking
    ${endpoint}=    Set Variable    /auth
    ${username}=    Set Variable    admin
    ${password}=    Set Variable    password123

    ${token}    Criar token     ${endpoint}     ${username}     ${password}

    ${all_bookings}=    Pegar todos os bookings    /booking
    ${first_booking}=   Get From List    ${all_bookings.json()}    0
    ${booking_id}=      Set Variable    ${first_booking['bookingid']}
    ${response}=        Deletar booking    ${booking_id}    ${token}
    Should Be Equal As Integers   ${response.status_code}    201