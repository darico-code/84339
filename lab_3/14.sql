-- Define a temporary table: REORDER(idSupplier, idProduct, quantity)
-- Write a procedure which inserts in REORDER the products which "unitsinstock" 
-- is lower than the "reorderlevel"


SET SERVEROUTPUT ON;

CREATE GLOBAL TEMPORARY TABLE REORDER (
    idSupplier NUMBER,
    idProduct NUMBER,
    quantity NUMBER
) ON COMMIT PRESERVE ROWS;

create or replace procedure insertInReorder IS
BEGIN 
    FOR product IN  (SELECT supplierid, productid, unitsinstock, reorderlevel
                    FROM NW_PRODUCTS
                    ) LOOP
        IF product.unitsinstock < product.reorderlevel THEN
            
            INSERT INTO REORDER VALUES  (
                                        product.supplierid,
                                        product.productid,
                                        product.unitsinstock
                                        );
        END IF;
    END LOOP;   
END insertInReorder;
/
BEGIN 
    insertInReorder;
END;
/
SELECT IDSUPPLIER ,
IDPRODUCT ,
QUANTITY  FROM REORDER;