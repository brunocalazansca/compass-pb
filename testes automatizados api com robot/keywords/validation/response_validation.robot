*** Settings ***
Library    Collections

*** Keywords ***
Validate Response Status
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Validate Booking Response Structure
    [Arguments]    ${booking_data}
    Dictionary Should Contain Key    ${booking_data}    firstname
    Dictionary Should Contain Key    ${booking_data}    lastname
    Dictionary Should Contain Key    ${booking_data}    totalprice
    Dictionary Should Contain Key    ${booking_data}    depositpaid
    Dictionary Should Contain Key    ${booking_data}    bookingdates

Validate Booking Dates Structure
    [Arguments]    ${booking_dates}
    Dictionary Should Contain Key    ${booking_dates}    checkin
    Dictionary Should Contain Key    ${booking_dates}    checkout

Validate Booking Creation Response
    [Arguments]    ${response}
    Validate Response Status    ${response}    200
    ${booking_data}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${booking_data}    bookingid
    Dictionary Should Contain Key    ${booking_data}    booking
    Validate Booking Response Structure    ${booking_data['booking']}

Validate Token Response
    [Arguments]    ${response}
    Validate Response Status    ${response}    200
    ${token_data}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${token_data}    token
    Should Not Be Empty    ${token_data['token']}