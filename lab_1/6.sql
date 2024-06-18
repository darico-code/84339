-- SELECT THE FIVE CLIENTS WITH THE MOST NUMBER OF ORDERS MADE

-- SOLUTION 1

WITH customer_number_of_orders AS
(
SELECT o.customerid customerid, count(o.customerid) numberOfOrders
FROM NW_CUSTOMERS c JOIN NW_ORDERS o on c.customerid = o.customerid
GROUP BY o.customerid 
)

SELECT *
FROM customer_number_of_orders co JOIN NW_customers cu ON co.customerid = cu.customerid 
WHERE rownum <= 5