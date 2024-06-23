/*
Scrivere un trigger che a fronte della cancellazione di un ordine in NW_Orders
elimina tutti i dettagli ad esso relativi in NW_OrderDetails (e aggiorna NW_EmployeeRank )
*/

CREATE OR REPLACE TRIGGER trg_canc_ord 
BEFORE DELETE ON NW_Orders
FOR EACH ROW
BEGIN
    DELETE FROM NW_orderdetails WHERE orderid = :OLD.orderid;
    UPDATE NW_Employeerank
    SET numorders = numorders - 1
    WHERE employeeid = :OLD.employeeid;
END trg_canc_ord;

ALTER TRIGGER trg_canc_ord ENABLE;

delete from NW_orders where orderid=10436;
delete from NW_orders where orderid=11079;

SELECT * FROM NW_EMPLOYEERANK ;