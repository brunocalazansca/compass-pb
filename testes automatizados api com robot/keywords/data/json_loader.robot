*** Settings ***
Library    OperatingSystem
Library    Collections

*** Keywords ***
Load JSON Data
    [Arguments]    ${file_path}    ${data_key}
    ${json_content}=    Get File    ${file_path}
    ${data}=    Evaluate    json.loads('''${json_content}''')    json
    ${result}=    Get From Dictionary    ${data}    ${data_key}
    RETURN    ${result}

Get Booking Data
    [Arguments]    ${data_type}
    ${file_path}=    Set Variable    ${CURDIR}/../../test_data/json/booking_data.json
    ${data}=    Load JSON Data    ${file_path}    ${data_type}
    RETURN    ${data}