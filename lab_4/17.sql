-- Write a function Correlate(idCat1, idCat2) which taken the two categories
-- as parameters prints the sum of the number of times a product with cateogry 
-- idCat1 is ordered together with a product with category idCat2. 
-- By sum of number of times it is meant that if a product idCat1 is in an order with
-- 3 products of idCat2 then we count this as 3 and not 1.


CREATE OR REPLACE FUNCTION Correlate(idCat1 NUMBER, idCat2 NUMBER) RETURN NUMBER IS
  correlation NUMBER;
  
  CURSOR fetchResult IS ( SELECT COUNT( od1.orderid)
              FROM NW_PRODUCTS p1
              JOIN NW_ORDERDETAILS od1 ON p1.PRODUCTID = od1.PRODUCTID
              JOIN NW_ORDERDETAILS od2 ON od1.ORDERID = od2.ORDERID
              JOIN NW_PRODUCTS p2 ON od2.PRODUCTID = p2.PRODUCTID
              WHERE p1.CATEGORYID = idCat1 AND p2.CATEGORYID = idCat2 AND p1.productid!=p2.productid) ;
  
BEGIN   
  OPEN fetchResult;
  FETCH fetchResult INTO correlation;
  IF idCat1=idCat2 THEN /* if it is the same category each pair is doubled */
    correlation := correlation / 2;
  END IF;
  RETURN correlation;
END Correlate;
/

-- Testing
SELECT Correlate(1, 2) AS Correlation FROM dual;

-- If you did it like this(the normal way) it is valid

/*
SELECT od1.orderid
FROM NW_PRODUCTS p1 JOIN NW_ORDERDETAILS od1 ON p1.PRODUCTID = od1.PRODUCTID
WHERE p1.categoryID = 1 AND 
                        EXISTS(SELECT *
                        FROM NW_ORDERDETAILS od2 JOIN NW_PRODUCTS p2 ON 
                                                    od2.PRODUCTID = p2.PRODUCTID
                        WHERE p2.CATEGORYID = 2 AND od2.ORDERID = od1.ORDERID) 
*/