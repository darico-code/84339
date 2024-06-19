-- Write a procedure supplier(supplierid), that, taken as input a supplier,
-- returns the list of products for which unitsinstock < reorderlevel holds and
-- for which there exists at least 1 order which contains it and hasn't yet been
-- shipped(NULL value on shippeddate).

SET SERVEROUTPUT ON;

create or replace procedure Supplier(supplieridpar NUMBER) IS
cursor cursGetProducts IS (SELECT DISTINCT(pr.productid),
                            pr.productname productname
                            FROM NW_PRODUCTS pr JOIN NW_ORDERDETAILS od ON 
                            od.productid = pr.productid JOIN NW_ORDERS ord ON 
                            ord.orderid = od.orderid
                            WHERE pr.unitsinstock < pr.reorderlevel 
                            AND pr.supplierid = supplieridpar
                            AND ord.shippeddate IS NULL);
BEGIN 
    FOR product IN cursGetProducts LOOP
    DBMS_OUTPUT.PUT_LINE('productname: '|| product.productname);
    END LOOP;
END Supplier;
/
BEGIN 
    Supplier(1);   
END;