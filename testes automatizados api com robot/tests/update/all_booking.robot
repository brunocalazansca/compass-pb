*** Settings ***
Resource        ../../api/api_config.robot
Resource        ../../resources/get_all_bookings.robot
Resource        ../../resources/get_token.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Atualizar booking completamente
    [Arguments]    ${booking_id}    ${token}    ${body}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${headers}=     Set To Dictionary    ${headers}    Content-Type=application/json
    ${response}=    PUT    ${url}    headers=${headers}    data=${body}
    RETURN    ${response}

*** Test Cases ***
Atualizar booking completamente
    ${endpoint}=    Set Variable    /auth
    ${username}=    Set Variable    admin
    ${password}=    Set Variable    password123
    ${token}=       Criar token     ${endpoint}     ${username}     ${password}

    ${all_bookings}=    Pegar todos os bookings    /booking
    ${first_booking}=   Get From List    ${all_bookings.json()}    0
    ${booking_id}=      Set Variable    ${first_booking['bookingid']}

    ${body_dict}=    Create Dictionary
    ...    firstname=Bruno
    ...    lastname=Carritilha
    ...    totalprice=18
    ...    depositpaid=True
    ...    bookingdates=${EMPTY}
    ...    additionalneeds=Breakfast

    ${bookingdates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    Set To Dictionary    ${body_dict}    bookingdates=${bookingdates}

    ${body_json}=    Evaluate    json.dumps(${body_dict})    json

    ${response}=    Atualizar booking completamente    ${booking_id}    ${token}    ${body_json}

    Should Be Equal As Integers    ${response.status_code}    200

    ${updated}=    To JSON    ${response.content}

    Should Be Equal                ${updated['firstname']}    Bruno
    Should Be Equal                ${updated['lastname']}     Carritilha
    Should Be Equal As Integers    ${updated['totalprice']}   18

    ${depositpaid_bool}=           Evaluate    bool(${updated['depositpaid']})
    Should Be True                 ${depositpaid_bool}

    Should Be Equal                ${updated['bookingdates']['checkin']}   2018-01-01
    Should Be Equal                ${updated['bookingdates']['checkout']}  2019-01-01
    Should Be Equal                ${updated['additionalneeds']}   Breakfast

    Log To Console    Booking atualizado completamente: ${updated}
