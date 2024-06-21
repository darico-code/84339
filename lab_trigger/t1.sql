--  A fronte dell’inserimento di un nuovo ordine, se il campo data è NULL
--  assegna la data di oggi

-- After version

create or replace trigger trg_after_ord_insr_data
AFTER INSERT ON NW_ORDERS 
FOR EACH ROW
BEGIN
IF :NEW.orderdate IS NULL THEN
    UPDATE NW_ORDERS
    SET orderdate = SYSDATE 
    WHERE orderid = :NEW.orderid;
END IF;
END;

-- Before version

create or replace TRIGGER trg_before_ord_insr_data
BEFORE INSERT ON nw_orders
FOR EACH ROW
BEGIN
if :NEW.ORDERDATE is NULL then
    :NEW.ORDERDATE := sysdate;
end if;
END;

/*
Testing: 

ALTER TRIGGER trg_after_ord_insr_data ENABLE;
INSERT INTO nw_orders VALUES (20000,'BONAP',9,'20852',null,null,null,2,38.28,'Bon app', '12, rue des Bouchers','Marseille', null,'13008','France');
SELECT * from nw_orders WHERE orderid=20000
*/