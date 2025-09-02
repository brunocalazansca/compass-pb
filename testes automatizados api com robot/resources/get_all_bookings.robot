*** Settings ***
Resource        ../api/api_config.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Pegar todos os bookings
    [Arguments]    ${endpoint}
    Create Session      booking     ${BASE_URL}     headers=${HEADERS}
    ${response}=    GET On Session    booking    ${endpoint}
    RETURN    ${response}
