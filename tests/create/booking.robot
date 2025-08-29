*** Settings ***
Resource        ../../api/api_config.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Criar booking
    [Arguments]    ${endpoint}

    ${bookingdate}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${payload}=    Create Dictionary
        ...    firstname=Bruno
        ...    lastname=Calazans
        ...    totalprice=18
        ...    depositpaid=${True}
        ...    bookingdates=${bookingdate}
        ...    additionalneeds=Breakfast

        Create Session      booking     ${BASE_URL}     headers=${HEADERS}

        ${response}=    POST On Session    booking    ${endpoint}    json=${payload}

        [Return]    ${response}

*** Test Cases ***
Test Criar Booking
    ${endpoint}=    Set Variable    /booking

    ${response}=    Criar booking    ${endpoint}

    Should Be Equal As Integers    ${response.status_code}    200
