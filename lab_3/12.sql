-- WRITE A PROCEDURE THAT GETS AS PARAMETERS A PAIR OF INTEGERS AND PRINTS
-- HOW MANY PRODUCTS HAVE AN UNITPRICE IN THE INTERVAL.

SET SERVEROUTPUT ON;

CREATE OR REPLACE TYPE number_varray IS VARRAY(2) OF NUMBER; /* my tuple type */
/
CREATE OR REPLACE PROCEDURE countInterval( intervalPar number_varray) IS
CURSOR cursFetchCount ( ll NW_PRODUCTS.UNITPRICE%TYPE ,
                        lr NW_PRODUCTS.UNITPRICE%TYPE) IS
SELECT count(*) conteggio
FROM NW_PRODUCTS 
WHERE UNITPRICE
BETWEEN ll AND lr;

x number(5);

BEGIN 
    OPEN cursFetchCount(intervalPar(1), intervalPar(2));
    FETCH cursFetchCount INTO x;
    DBMS_OUTPUT.PUT_LINE('In (' || intervalPar(1) || ' and '
                        || intervalPar(2) || ') there are '
                        || x || ' product/s');
END countInterval;
/

BEGIN
    countInterval(number_varray(4,5));
END;