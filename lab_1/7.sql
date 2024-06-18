-- Group products based on the quantity of sold units: 
-- group n1: times sold > s*2/3 
-- group n2: times sold < s*1/3
-- group n3: anything else
-- s is the number of units sold of the most sold product

with PView AS
(
SELECT PRODUCTID, sum (o.quantity) qntSold
FROM NW.ORDERDETAILS O group by PRODUCTID),
sview AS (
SELECT MAX(qntSold) highest FROM PView
)

SELECT PRODUCTID, case
                       when qntSold>(2.0/3.0)*sview.highest then 'group 1'
                       when qntSold<(1.0/3.0)*sview.highest then 'group 2'
                       else 'group 3'
                  end groupN, qntSold
FROM PView
CROSS JOIN sview;