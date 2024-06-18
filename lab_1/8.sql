----Per ogni categoria selezionare il costo medio relativo ai cinque prodotti più costosi
with product_rank AS
(
SELECT productname, categoryid, unitprice,
ROW_NUMBER() OVER (PARTITION BY categoryid ORDER BY unitprice DESC) rnk
FROM nw.products
)

SELECT categoryid, AVG(unitprice) avarage
FROM product_rank
WHERE rnk < 6
GROUP BY categoryid