-- Write a procedure which shows the name of the customer associated with 
-- an order id given as parameter.
-- Handle the case where no customer is found.

SET SERVEROUTPUT ON; 

CREATE OR REPLACE PROCEDURE showClient(orderIdPar number) IS 
clientName NW_CUSTOMERS.contactname%TYPE;
BEGIN 
    SELECT c.contactname INTO clientName
    FROM NW_CUSTOMERS c JOIN NW_ORDERS o ON c.customerid = o.customerid WHERE o.orderId = orderIdPar;
    DBMS_OUTPUT.PUT_LINE(clientName);
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Client not found');
END showClient;
/

BEGIN
    showClient(10436);
END;