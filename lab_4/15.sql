-- Write a procedure Orders(clientId) which prints all the orders
-- made by a customer and the products which are part of the order.

SET SERVEROUTPUT ON;

create or replace procedure Orders(customerId varchar) IS
cursor cursFetchProducts(orderIdPar nw_orders.orderid%TYPE) IS 
(SELECT p.productid productid, p.productname productname
FROM (NW_PRODUCTS p JOIN NW_ORDERDETAILS od ON p.productid = od.productid)
                            JOIN NW_ORDERS o ON od.orderid = o.orderid 
WHERE o.orderid = orderIdPar);
cursor cursFetchOrders(customerIdPar nw_orders.CUSTOMERID%TYPE) IS
(SELECT orderid FROM NW_ORDERS WHERE customerid = customerIdPar);
BEGIN
    FOR orderR IN cursFetchOrders(customerId) LOOP
        DBMS_OUTPUT.PUT_LINE(
                            'order ' || orderR.orderid || ' is composed of the ' ||
                            'following products: ' );
        FOR product IN cursFetchProducts(orderR.orderid) LOOP
            DBMS_OUTPUT.PUT_LINE('product id: ' || product.productid ||
            ' name: ' || product.productname);
        END LOOP;
    END LOOP;
END Orders;
/
BEGIN 
    Orders('ALFKI');
END;