-- Write a procedure Intervals(iMin, iMax), which prints each customer c
-- and, if CO is the number of orders made by c, then
-- if C0 > iMax then print 'high range'
-- if CO < iMin then print 'low range'
-- print 'middle range' otherwise

SET SERVEROUTPUT ON;

create or replace procedure Intervals(iMin number, iMax number) IS
BEGIN
    FOR r IN (SELECT customerid, companyname, (CASE 
                                        WHEN num_orders > iMax THEN 'high range'
                                        WHEN num_orders < iMin THEN 'low range'
                                        ELSE 'middle range' END) cat 
            FROM (  SELECT  c.customerid customerid,
                            c.companyname companyname,
                            COUNT(*) num_orders 
                    FROM nw_customers c JOIN nw_orders o ON
                    c.customerid = o.customerid
                    GROUP BY c.customerid, c.companyname
                    ORDER BY num_orders DESC)) LOOP
    DBMS_OUTPUT.PUT_LINE('customerid: ' || r.companyname || ' is in range: '||
                        r.cat);
    END LOOP;
END;
/
BEGIN 
    Intervals(5, 15);
END;
/
                                        
