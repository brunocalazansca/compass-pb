*** Variables ***
${BASE_URL}     https://restful-booker.herokuapp.com
${HEADERS}      {"Accept": "application/json", "Content-Type": "application/json", "Cookie": "token=9be32522dcf0450"}

*** Keywords ***
Montar url
    [Arguments]     ${endpoint}
    ${url}=     Catenate        SEPARATOR=      ${BASE_URL}     ${endpoint}
    RETURN       ${url}

Montar headers com cookie
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json    Cookie=token=${token}
    RETURN      ${headers}
