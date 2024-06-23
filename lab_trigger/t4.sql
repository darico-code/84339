CREATE TABLE NW_EmployeeRank(EmployeeID INT PRIMARY KEY, NumOrders INT)

INSERT INTO Nw_EmployeeRank (SELECT o.employeeid, count(*) FROM NW_Orders o GROUP BY o.employeeid);

CREATE OR REPLACE TRIGGER trg_employee_rank 
BEFORE INSERT ON nw_orders
FOR EACH ROW
BEGIN
    UPDATE NW_EmployeeRank 
    SET NumOrders = NumOrders + 1
    WHERE EmployeeID = :NEW.employeeid;
    IF SQL%NOTFOUND then
        INSERT INTO NW_EmployeeRank VALUES (:NEW.employeeid, 1);
    END IF;
END trg_employee_rank;


ALTER TRIGGER trg_employee_rank ENABLE;

Insert into NW_ORDERS values ('13078','BONAP','9','20852',to_date('07-MAY-
98','DD-MON-RR'),to_date('04-JUN-98','DD-MON-RR'),null,'2','38.28','Bon app''','12,
rue des Bouchers','Marseille',null,'13008','France');