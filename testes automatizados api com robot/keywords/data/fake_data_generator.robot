*** Settings ***
Library    Collections
Library    DateTime

*** Keywords ***
Generate Fake Booking Data
    [Arguments]    ${data_type}=complete
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_price}=    Evaluate    random.randint(50, 500)    random
    
    IF    '${data_type}' == 'complete'
        ${booking_data}=    Create Dictionary
        ...    firstname=TestUser${timestamp}
        ...    lastname=AutoTest
        ...    totalprice=${random_price}
        ...    depositpaid=${True}
        ...    bookingdates=${EMPTY}
        ...    additionalneeds=Automated Test
        
        ${dates}=    Create Dictionary
        ...    checkin=2024-01-01
        ...    checkout=2024-01-02
        Set To Dictionary    ${booking_data}    bookingdates=${dates}
        
    ELSE IF    '${data_type}' == 'update'
        ${booking_data}=    Create Dictionary
        ...    firstname=UpdatedUser${timestamp}
        ...    lastname=Modified
        ...    totalprice=${random_price}
        ...    depositpaid=${False}
        ...    bookingdates=${EMPTY}
        ...    additionalneeds=Updated Test
        
        ${dates}=    Create Dictionary
        ...    checkin=2024-02-01
        ...    checkout=2024-02-02
        Set To Dictionary    ${booking_data}    bookingdates=${dates}
        
    ELSE
        ${booking_data}=    Create Dictionary
        ...    firstname=PartialUser${timestamp}
        ...    lastname=PartialTest
        ...    totalprice=${random_price}
        ...    depositpaid=${True}
        ...    bookingdates=${EMPTY}
        ...    additionalneeds=Partial Test
        
        ${dates}=    Create Dictionary
        ...    checkin=2024-03-01
        ...    checkout=2024-03-02
        Set To Dictionary    ${booking_data}    bookingdates=${dates}
    END
    
    RETURN    ${booking_data}