#Testes de um mesmo endpoint ou método podem ser aglomerados juntos, ou mesmo todos os testes em um só arquivo. 
#Para isso, podem ser usadas tags. Exemplo na linha 11
*** Settings ***
Resource        ../../api/api_config.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Criar booking
    [Arguments]    ${endpoint}
    [Tags]         POST            #Melhora visibilidade
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

        RETURN    ${response}

*** Test Cases ***
Test Criar Booking
    ${endpoint}=    Set Variable    /booking

    ${response}=    Criar booking    ${endpoint}

    Should Be Equal As Integers    ${response.status_code}    200
