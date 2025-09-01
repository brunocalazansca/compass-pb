
#Mesmas libraries usadas em api_config.robot, melhor juntar tudo no mesmo arquivo.
*** Settings ***
Resource        ../api/api_config.robot
Library     RequestsLibrary
Library     Collections

#A melhor prática nesse caso seria aglomerar todos os keywords em um só arquivo, que neste caso em específico 
# seria o arquivo api_config.robot.

*** Keywords ***
Pegar todos os bookings
    [Arguments]    ${endpoint}
    Create Session      booking     ${BASE_URL}     headers=${HEADERS}
    ${response}=    GET On Session    booking    ${endpoint}
    RETURN    ${response}