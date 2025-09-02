*** Settings ***
Resource        ../../api/api_config.robot
Resource        ../data/json_loader.robot
Resource        ../data/fake_data_generator.robot
Library         RequestsLibrary
Library         Collections

*** Keywords ***
Criar booking
    [Arguments]    ${endpoint}
    ${payload}=    Generate Fake Booking Data    complete
    Create Session      booking     ${BASE_URL}     headers=${HEADERS}
    ${response}=    POST On Session    booking    ${endpoint}    json=${payload}
    RETURN    ${response}

Pegar todos os bookings
    [Arguments]    ${endpoint}
    Create Session      booking     ${BASE_URL}     headers=${HEADERS}
    ${response}=    GET On Session    booking    ${endpoint}
    RETURN    ${response}

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

Atualizar booking completamente
    [Arguments]    ${booking_id}    ${token}    ${body}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${headers}=     Set To Dictionary    ${headers}    Content-Type=application/json
    ${response}=    PUT    ${url}    headers=${headers}    data=${body}
    RETURN    ${response}

Atualizar booking parcialmente
    [Arguments]    ${booking_id}    ${token}    ${body}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${headers}=     Set To Dictionary    ${headers}    Content-Type=application/json
    ${response}=    PUT    ${url}    headers=${headers}    data=${body}
    RETURN        ${response}

Deletar booking
    [Arguments]    ${booking_id}    ${token}
    ${endpoint}=    Set Variable    /booking/${booking_id}
    ${url}=         Montar url     ${endpoint}
    ${headers}=     Montar headers com cookie    ${token}
    ${response}=    DELETE    ${url}    headers=${headers}
    RETURN        ${response}