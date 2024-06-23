-- Data tracking: log dei cambiamenti di prezzo dei prodotti

CREATE SEQUENCE nw_track_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE nw_data_tracking (
IDtracking INT PRIMARY KEY,
IDprod INT NOT NULL ,
old_value INT NOT NULL ,
new_value INT NOT NULL ,
dateModified DATE NOT NULL,
userModified varchar2(20)
);

CREATE OR REPLACE TRIGGER trg_log_update_price
AFTER UPDATE OF UNITPRICE ON NW_PRODUCTS
FOR EACH ROW
BEGIN
    INSERT INTO nw_data_tracking VALUES
    (nw_track_id.nextval, :NEW.productid, :OLD.unitprice, :NEW.unitprice, SYSDATE, user);
END;

/*

TESTING

ALTER TRIGGER trg_log_update_price ENABLE;

UPDATE nw_products
SET unitprice=unitprice+1
WHERE productid=1;

SELECT * FROM nw_data_tracking;
*/


