-- Write a function that takes as parameter a product id and a integer q; 
-- as output it should return TRUE iff the product has a UNITSINSTOCK 
-- value strictly greater than q, FALSE otherwise.

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE verifyQuantity(quantity NUMBER, productIdRec NUMBER) IS 
qty NUMBER(5);
BEGIN 
    SELECT unitsinstock INTO qty FROM NW_PRODUCTS WHERE PRODUCTID = productIdRec;
    IF qty > quantity THEN
    DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
    DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END verifyQuantity;
/

BEGIN 
    verifyQuantity(38, 1);
END;