-- SELECT THE CUSTOMER WHO DID GENERATE THE HIGHEST REVENUE IN 1996

-- OBS: the value NW_ORDERDETAILS.DISCOUNT is assumed on the whole
-- price = QUANTITY x UNITPRICE

/* Table which contains for each order, the orderid and the cost of the order
following cost = unitprice * quantity * discount */
WITH checkout_price AS
(
SELECT ord.customerid, SUM(od.unitprice * od.quantity * od.discount) as total
FROM NW_ORDERDETAILS od JOIN NW_ORDERS ord ON od.orderid = ord.orderid
WHERE TO_CHAR(ord.orderdate, 'YYYY-MM-DD') >= '1996-01-01' AND
      TO_CHAR(ord.orderdate, 'YYYY-MM-DD') < '1997-01-01'
GROUP BY ord.customerid
ORDER BY total DESC
)

SELECT *
FROM NW_CUSTOMERS cu
WHERE cu.customerid = (
                        SELECT cp.customerid
                        FROM checkout_price cp
                        WHERE rownum <= 1
                      ) 
