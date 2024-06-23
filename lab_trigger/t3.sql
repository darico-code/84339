-- Data la tabella riassuntiva order_stats :
CREATE TABLE order_stats as
SELECT  EXTRACT (year FROM orderdate) as year, 
        count (Distinct customerid) as numCust,
        count (*) as numOrd
FROM    nw_orders
GROUP BY EXTRACT (year FROM orderdate)
ORDER BY 1;

-- Aggiorna la tabella a fronte di variazioni nella tabella ordini

create or replace trigger trg_update_stats_order 
AFTER INSERT OR DELETE OR UPDATE ON nw_orders
DECLARE
Cursor cursore IS (SELECT  EXTRACT (year FROM orderdate) as year, 
        count (Distinct customerid) as numCust,
        count (*) as numOrd
        FROM    nw_orders
        GROUP BY EXTRACT (year FROM orderdate));
BEGIN
    FOR os IN cursore LOOP
        UPDATE order_stats 
        SET numCust = os.numCust, numOrd = os.numOrd
        WHERE year = os.year;
        IF SQL%NOTFOUND THEN 
            INSERT INTO order_stats VALUES (os.year, os.numCust, os.numOrd);
        END IF;
    END LOOP;
END trg_update_stats_order;
    

ALTER TRIGGER trg_update_stats_order ENABLE;
INSERT INTO nw_orders VALUES
('20001','BONAP','9','20852',null,null,null,'2','38.28','Bon app''','12, rue des
Bouchers','Marseille',null,'13008','France');