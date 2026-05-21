
-- Optimization Approach (MySQL)

-- Test cases before and after optimization

-- Test case 1

-- Before optimization

EXPLAIN ANALYZE
SELECT soh.salesorderid,
       soh.orderdate,
       soh.totaldue,
       c.customerid
FROM sales_salesorderheader soh
JOIN sales_customer c
ON soh.customerid = c.customerid
WHERE soh.customerid = 11000;


-- Output : -> Filter: (soh.customerid = 11000)  (cost=3240 rows=3136) (actual time=0.173..16.9 rows=3 loops=1)
    -> Table scan on soh  (cost=3240 rows=31358) (actual time=0.149..15.5 rows=31465 loops=1)


-- Optimize : Create index

CREATE INDEX idx_salesorderheader_customerid
ON sales_salesorderheader(customerid);


-- After optimization

EXPLAIN ANALYZE
SELECT soh.salesorderid,
       soh.orderdate,
       soh.totaldue,
       c.customerid
FROM sales_salesorderheader soh
JOIN sales_customer c
ON soh.customerid = c.customerid
WHERE soh.customerid = 11000;


-- Output : -> Index lookup on soh using idx_salesorderheader_customerid (customerid=11000)  (cost=1.05 rows=3) (actual time=0.0269..0.0294 rows=3 loops=1)



-- Test case 2

-- Before optimization 

EXPLAIN ANALYZE
SELECT sod.salesorderid,
       p.name,
       sod.orderqty,
       sod.unitprice
FROM sales_salesorderdetail sod
JOIN production_product p
ON sod.productid = p.productid
WHERE p.productid = 707;

-- Output : -> Filter: (sod.productid = 707)  (cost=12647 rows=12411) (actual time=10.6..64.6 rows=3083 loops=1)
    -> Table scan on sod  (cost=12647 rows=124108) (actual time=10.6..59.4 rows=121317 loops=1)


-- Optimize : Create index

CREATE INDEX idx_salesorderdetail_productid
ON sales_salesorderdetail(productid);


-- After optimization 

EXPLAIN ANALYZE
SELECT sod.salesorderid,
       p.name,
       sod.orderqty,
       sod.unitprice
FROM sales_salesorderdetail sod
JOIN production_product p
ON sod.productid = p.productid
WHERE p.productid = 707;

-- Output : -> Index lookup on sod using idx_salesorderdetail_productid (productid=707)  (cost=1007 rows=3083) (actual time=1.32..11.4 rows=3083 loops=1)



-- Test case 3

-- Before optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales_salesorderheader
WHERE customerid = 11000
AND orderdate >= '2013-01-01';

-- Output : -> Filter: (sales_salesorderheader.orderdate >= TIMESTAMP'2013-01-01 00:00:00')  (cost=0.85 rows=1) (actual time=0.0375..0.04 rows=3 loops=1)
    -> Index lookup on sales_salesorderheader using idx_salesorderheader_customerid (customerid=11000)  (cost=0.85 rows=3) (actual time=0.036..0.0382 rows=3 loops=1)


-- Optimize : create composite index 

CREATE INDEX idx_customer_orderdate
ON sales_salesorderheader(customerid, orderdate);


-- After optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales_salesorderheader
WHERE customerid = 11000
AND orderdate >= '2013-01-01';


-- Output : -> Filter: (sales_salesorderheader.orderdate >= TIMESTAMP'2013-01-01 00:00:00')  (cost=0.85 rows=1) (actual time=0.0372..0.0397 rows=3 loops=1)
    -> Index lookup on sales_salesorderheader using idx_salesorderheader_customerid (customerid=11000)  (cost=0.85 rows=3) (actual time=0.0359..0.038 rows=3 loops=1)



-- Test case 4

-- Before optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales_salesorderheader
ORDER BY orderdate DESC
LIMIT 100;

-- Output : -> Limit: 100 row(s)  (cost=3240 rows=100) (actual time=23..23 rows=100 loops=1)
    -> Sort: sales_salesorderheader.orderdate DESC, limit input to 100 row(s) per chunk  (cost=3240 rows=31358) (actual time=23..23 rows=100 loops=1)
        -> Table scan on sales_salesorderheader  (cost=3240 rows=31358) (actual time=0.159..14.8 rows=31465 loops=1)

-- Optimize : create index 

CREATE INDEX idx_salesorderheader_orderdate
ON sales_salesorderheader(orderdate DESC);

-- After optimization

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales_salesorderheader
ORDER BY orderdate DESC
LIMIT 100;

-- Output : -> Limit: 100 row(s)  (cost=0.364 rows=100) (actual time=0.0822..0.31 rows=100 loops=1)
    -> Index scan on sales_salesorderheader using idx_salesorderheader_orderdate  (cost=0.364 rows=100) (actual time=0.0814..0.305 rows=100 loops=1)


-- Test case 5

-- Before optimization 

EXPLAIN ANALYZE
SELECT productid,
       SUM(orderqty) AS total_qty
FROM sales_salesorderdetail
GROUP BY productid;

-- Output : -> Table scan on <temporary>  (actual time=96.2..96.2 rows=266 loops=1)
    -> Aggregate using temporary table  (actual time=96.1..96.1 rows=266 loops=1)
        -> Table scan on sales_salesorderdetail  (cost=12644 rows=124108) (actual time=0.264..49.8 rows=121317 loops=1)

-- Optimize : create index 

CREATE INDEX idx_salesorderdetail_productid_group
ON sales_salesorderdetail(productid);

-- After optimization

EXPLAIN ANALYZE
SELECT productid,
       SUM(orderqty) AS total_qty
FROM sales_salesorderdetail
GROUP BY productid;

-- Output : -> Group aggregate: sum(sales_salesorderdetail.orderqty)  (cost=25054 rows=280) (actual time=6.76..249 rows=266 loops=1)
    -> Index scan on sales_salesorderdetail using idx_salesorderdetail_productid_group  (cost=12644 rows=124108) (actual time=2.84..240 rows=121317 loops=1)
