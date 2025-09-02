*** Variables ***
&{VALID_BOOKING_DATA}
...    firstname=Bruno
...    lastname=Calazans
...    totalprice=18
...    depositpaid=${True}
...    additionalneeds=Breakfast

&{BOOKING_DATES}
...    checkin=2018-01-01
...    checkout=2019-01-01

&{UPDATE_BOOKING_DATA}
...    firstname=Bruno
...    lastname=Carritilha
...    totalprice=18
...    depositpaid=True
...    additionalneeds=Breakfast

&{PARTIAL_UPDATE_DATA}
...    firstname=Bruno
...    lastname=Calazans Carritilha