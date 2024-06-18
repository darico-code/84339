-- WRITE A PROCEDURE THAT PRINTS THE SUPPLIERS AND THEIR RESPECTIVE PRODUCTS

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE print_suppliers IS
CURSOR cursFetchProducts (supplierIdPar NW_SUPPLIERS.supplierid%TYPE) IS 
SELECT p.productid productid
FROM NW_SUPPLIERS s JOIN NW_PRODUCTS p ON  s.supplierid=p.supplierid AND
                                           s.supplierid=supplierIdPar;
CURSOR cursFetchSuppliers IS SELECT s.supplierid supplierid FROM NW_SUPPLIERS s;
BEGIN
    FOR supplier IN cursFetchSuppliers
    LOOP 
        DBMS_OUTPUT.PUT_LINE('supplierId is: ' || supplier.supplierid);
        FOR product IN cursFetchProducts(supplier.supplierid)
        LOOP 
            DBMS_OUTPUT.PUT_LINE('product with id: ' || product.productid);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('-------');
    END LOOP;
END print_suppliers;
/
BEGIN 
    print_suppliers();
END;

