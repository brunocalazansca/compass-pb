*** Settings ***
Resource    ../keywords/auth/token_keywords.robot
Resource    ../keywords/booking/booking_keywords.robot
Resource    ../config/test_config.robot

*** Keywords ***
Test Setup
    Log    Starting test execution
    Set Test Variable    ${TEST_START_TIME}    ${EMPTY}

Test Teardown
    Log    Test execution completed
    Run Keyword If Test Failed    Log    Test failed - check logs for details

Suite Setup
    Log    Starting test suite
    Set Suite Variable    ${SUITE_TOKEN}    ${EMPTY}

Suite Teardown
    Log    Test suite completed

Get Authentication Token
    ${token}=    Criar token    /auth    ${USERNAME}    ${PASSWORD}
    Set Suite Variable    ${SUITE_TOKEN}    ${token}
    RETURN    ${token}

Create Test Booking
    ${response}=    Criar booking    /booking
    ${booking_data}=    To JSON    ${response.content}
    ${booking_id}=    Set Variable    ${booking_data['bookingid']}
    Set Test Variable    ${TEST_BOOKING_ID}    ${booking_id}
    RETURN    ${booking_id}