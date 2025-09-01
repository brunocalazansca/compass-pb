*** Settings ***
Resource        ../../api/api_config.robot
Resource        ../../resources/get_all_bookings.robot
Resource        ../../resources/get_token.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Atualizar booking parcialmente
    [Arguments]    ${booking_id}    ${token}    ${body}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${response}=    PATCH    ${url}    headers=${headers}   data=${body}
    RETURN        ${response}

*** Test Cases ***
Atualizar booking parcialmente
    ${endpoint}=    Set Variable    /auth
    ${username}=    Set Variable    admin
    ${password}=    Set Variable    password123
    ${token}=       Criar token     ${endpoint}     ${username}     ${password}

    ${all_bookings}=    Pegar todos os bookings    /booking
    ${first_booking}=   Get From List    ${all_bookings.json()}    0
    ${booking_id}=      Set Variable    ${first_booking['bookingid']}

    ${body_dict}=    Create Dictionary    firstname=Bruno    lastname=Calazans Carritilha
    ${body}=    Evaluate    json.dumps(${body_dict})    json

    ${response}=    Atualizar booking parcialmente    ${booking_id}    ${token}    ${body}

    Should Be Equal As Integers    ${response.status_code}    200

    ${updated}=    To JSON    ${response.content}
    Should Be Equal    ${updated['firstname']}    Bruno
    Should Be Equal    ${updated['lastname']}     Calazans Carritilha