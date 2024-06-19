-- Write a procedure Productivity(start, end) which, taken in input two dates,
-- prints the employee with highest value of the following function and the
-- value of the function.
-- F = F1 + F2 + F3 
-- F1 = numberOfCustomers/totalNumberOfCustomers i.e. (Distinct customerid in NW_ORDERS in the period for the employee)
-- F2 = numberOfWorkDays/totalWorkDays 
--      (numberOfWorkDays is the number of days where the employee took care of at least one order,
--      totalWorkDays is the number of days where at least a order was taken care)
-- F3 = numberOfOrders/totalNumberOfOrders 

SET SERVEROUTPUT ON;

create or replace procedure Productivity(startDate date, endDate date) IS
cursor curs_numberOfCustomers( employee_id NW_EMPLOYEES.EMPLOYEEID%TYPE) IS
( SELECT COUNT( DISTINCT o.CUSTOMERID) numberOfCustomers
  FROM NW_ORDERS o
  WHERE o.employeeid = employee_id AND o.orderdate >= startDate AND o.orderdate <= endDate); 

cursor curs_totalNumberOfCustomers IS 
( SELECT COUNT( DISTINCT o.customerid) totalNumberOfCustomers FROM NW_ORDERS o 
    WHERE o.orderdate >= startDate AND o.orderdate <= endDate );

cursor curs_numberOfWorkDays( employee_id NW_EMPLOYEES.EMPLOYEEID%TYPE) IS
( SELECT COUNT(DISTINCT o.orderdate) numberOfWorkDays
  FROM NW_ORDERS o
  WHERE o.employeeid = employee_id AND o.orderdate >= startDate AND o.orderdate <= endDate); 

cursor curs_totalNumberOfWorkDays IS
( SELECT COUNT(DISTINCT o.orderdate) totalNumberOfWorkDays
  FROM NW_ORDERS o
  WHERE o.orderdate >= startDate AND o.orderdate <= endDate); 
  
cursor curs_numberOfOrders( employee_id NW_EMPLOYEES.EMPLOYEEID%TYPE) IS
( SELECT COUNT(o.ORDERID) numberOfOrders
  FROM NW_ORDERS o
  WHERE o.employeeid = employee_id AND o.orderdate >= startDate AND o.orderdate <= endDate); 

cursor curs_totalNumberOfOrders IS
( SELECT COUNT(o.ORDERID) totalNumberOfOrders
  FROM NW_ORDERS o
  WHERE o.orderdate >= startDate AND o.orderdate <= endDate); 

cursor curs_employees IS (SELECT employeeid FROM NW_EMPLOYEES);

bestScore NUMBER := -1;

bestEmployeeId NW_EMPLOYEES.EMPLOYEEID%TYPE;

totalNumberOfWorkDays NUMBER;

totalNumberOfCustomers NUMBER;

totalNumberOfOrders NUMBER;

F1 NUMBER;

F2 NUMBER;

F3 NUMBER;

F NUMBER;

BEGIN
    OPEN curs_totalNumberOfCustomers;
    FETCH curs_totalNumberOfCustomers INTO totalNumberOfCustomers;
    CLOSE curs_totalNumberOfCustomers;
    
    OPEN curs_totalNumberOfWorkDays;
    FETCH curs_totalNumberOfWorkDays INTO totalNumberOfWorkDays;
    CLOSE curs_totalNumberOfWorkDays;
    
    OPEN curs_totalNumberOfOrders;
    FETCH curs_totalNumberOfOrders INTO totalNumberOfOrders;
    CLOSE curs_totalNumberOfOrders;

    FOR employee IN curs_employees LOOP 
        OPEN curs_numberOfCustomers(employee.employeeid);
        OPEN curs_numberOfWorkDays(employee.employeeid);
        OPEN curs_numberOfOrders(employee.employeeid);
        FETCH curs_numberOfCustomers INTO F1;
        FETCH curs_numberOfWorkDays INTO F2;
        FETCH curs_numberOfOrders INTO F3;
        CLOSE curs_numberOfCustomers;
        CLOSE curs_numberOfWorkDays;
        CLOSE curs_numberOfOrders;
        F := ROUND(F1/totalNumberOfCustomers,3) + ROUND(F2/totalNumberOfWorkDays, 3) 
            + ROUND(F3/totalNumberOfOrders, 3);
        IF F > bestScore THEN 
            bestScore := F;
            bestEmployeeId := employee.employeeid;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Employeeid: ' || bestEmployeeId || ' score: ' ||
                        bestScore);
    
END Productivity;
/
BEGIN 
    Productivity(
    TO_DATE('19960129', 'YYYYMMDD'),
    TO_DATE('19970529', 'YYYYMMDD'));
END;

