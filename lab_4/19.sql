-- Write a function byRegion(regionId) which, taken as input a regionID(SHIPREGION)
-- prints the shipper with the most orders handled and the
-- 10 most sold products in the region.

SET SERVEROUTPUT ON;

create or replace procedure byRegion(regionId VARCHAR) IS
CURSOR curBestShipper IS (SELECT shipperid, companyname FROM 
                                        (
                                        SELECT s.shipperid shipperid,
                                        s.companyname companyname
                                        FROM NW_SHIPPERS s JOIN NW_ORDERS o ON
                                        s.shipperid = o.shipvia
                                        WHERE o.shipregion IS NOT NULL AND o.shipregion = regionId
                                        GROUP BY s.shipperid, s.companyname
                                        ORDER BY COUNT(*) DESC) WHERE rownum <= 1
                                        );
CURSOR curMostSold IS (SELECT * FROM (SELECT od.productid productid, SUM(od.quantity) howmany
                                      FROM NW_ORDERS o JOIN NW_ORDERDETAILS od
                                      ON o.orderid = od.orderid
                                      WHERE o.shipregion = regionId
                                      GROUP BY od.productid
                                      ORDER BY howmany DESC) tt JOIN NW_PRODUCTS pr ON 
                                      tt.productid = pr.productid WHERE rownum <= 10);

bestShipperId NUMBER;
bestShipperName NW_SHIPPERS.COMPANYNAME%TYPE;

BEGIN 
    OPEN curBestShipper;
    FETCH curBestShipper INTO bestShipperId, bestShipperName;
    DBMS_OUTPUT.PUT_LINE('shipper most active in region: ' || regionId || ' is '
                        || bestShipperName || ', id: ' || bestShipperId);
    CLOSE curBestShipper;
    FOR product IN curMostSold LOOP
        DBMS_OUTPUT.PUT_LINE('product: ' || product.productname || '(' || product.howmany || ')');
    END LOOP;
END byRegion;
/
BEGIN
    byRegion('AK');
END;
