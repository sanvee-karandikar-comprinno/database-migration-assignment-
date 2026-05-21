
-- Optimization Approach (PostgreSQL)

-- Test cases before and after optimization 

-- Test case 1

-- Before optimization 

EXPLAIN ANALYZE
SELECT soh.salesorderid,
       soh.orderdate,
       soh.totaldue,
       c.customerid
FROM sales.salesorderheader soh
JOIN sales.customer c
ON soh.customerid = c.customerid
WHERE soh.customerid = 11000;

-- Output :
"Nested Loop  (cost=0.29..1150.64 rows=2 width=23) (actual time=0.051..6.251 rows=3 loops=1)"
"  ->  Index Only Scan using pk_customer on customer c  (cost=0.29..4.30 rows=1 width=4) (actual time=0.009..0.012 rows=1 loops=1)"
"        Index Cond: (customerid = 11000)"
"        Heap Fetches: 0"
"  ->  Seq Scan on salesorderheader soh  (cost=0.00..1146.31 rows=2 width=23) (actual time=0.041..6.234 rows=3 loops=1)"
"        Filter: (customerid = 11000)"
"        Rows Removed by Filter: 31462"
"Planning Time: 0.486 ms"
"Execution Time: 6.276 ms"

-- Optimize : create index
CREATE INDEX idx_salesorderheader_customerid
ON sales.salesorderheader(customerid);

-- After optimization 

EXPLAIN ANALYZE
SELECT soh.salesorderid,
       soh.orderdate,
       soh.totaldue,
       c.customerid
FROM sales.salesorderheader soh
JOIN sales.customer c
ON soh.customerid = c.customerid
WHERE soh.customerid = 11000;

-- Output : 
"Nested Loop  (cost=4.59..16.34 rows=2 width=23) (actual time=0.057..0.062 rows=3 loops=1)"
"  ->  Index Only Scan using pk_customer on customer c  (cost=0.29..4.30 rows=1 width=4) (actual time=0.014..0.015 rows=1 loops=1)"
"        Index Cond: (customerid = 11000)"
"        Heap Fetches: 0"
"  ->  Bitmap Heap Scan on salesorderheader soh  (cost=4.30..12.02 rows=2 width=23) (actual time=0.035..0.038 rows=3 loops=1)"
"        Recheck Cond: (customerid = 11000)"
"        Heap Blocks: exact=3"
"        ->  Bitmap Index Scan on idx_salesorderheader_customerid  (cost=0.00..4.30 rows=2 width=0) (actual time=0.032..0.032 rows=3 loops=1)"
"              Index Cond: (customerid = 11000)"
"Planning Time: 0.829 ms"
"Execution Time: 0.102 ms"


-- Test case 2

-- Before optimization

EXPLAIN ANALYZE
SELECT sod.salesorderid,
       p.name,
       sod.orderqty,
       sod.unitprice
FROM sales.salesorderdetail sod
JOIN production.product p
ON sod.productid = p.productid
WHERE p.productid = 707;

-- Output : 
"Nested Loop  (cost=0.27..3163.44 rows=3069 width=31) (actual time=0.028..20.852 rows=3083 loops=1)"
"  ->  Index Scan using pk_product on product p  (cost=0.27..8.29 rows=1 width=23) (actual time=0.006..0.012 rows=1 loops=1)"
"        Index Cond: (productid = 707)"
"  ->  Seq Scan on salesorderdetail sod  (cost=0.00..3124.46 rows=3069 width=16) (actual time=0.021..20.573 rows=3083 loops=1)"
"        Filter: (productid = 707)"
"        Rows Removed by Filter: 118234"
"Planning Time: 0.664 ms"
"Execution Time: 20.956 ms"

-- Optimize : create index 

CREATE INDEX idx_salesorderdetail_productid
ON sales.salesorderdetail(productid);

-- After optimization : 

EXPLAIN ANALYZE
SELECT sod.salesorderid,
       p.name,
       sod.orderqty,
       sod.unitprice
FROM sales.salesorderdetail sod
JOIN production.product p
ON sod.productid = p.productid
WHERE p.productid = 707;

-- Output : 
"Nested Loop  (cost=36.35..1738.96 rows=3069 width=31) (actual time=0.376..2.262 rows=3083 loops=1)"
"  ->  Index Scan using pk_product on product p  (cost=0.27..8.29 rows=1 width=23) (actual time=0.012..0.015 rows=1 loops=1)"
"        Index Cond: (productid = 707)"
"  ->  Bitmap Heap Scan on salesorderdetail sod  (cost=36.08..1699.98 rows=3069 width=16) (actual time=0.357..1.890 rows=3083 loops=1)"
"        Recheck Cond: (productid = 707)"
"        Heap Blocks: exact=1275"
"        ->  Bitmap Index Scan on idx_salesorderdetail_productid  (cost=0.00..35.31 rows=3069 width=0) (actual time=0.233..0.233 rows=3083 loops=1)"
"              Index Cond: (productid = 707)"
"Planning Time: 1.125 ms"
"Execution Time: 2.353 ms"


-- Test case 3 

-- Before optimization

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales.salesorderheader
WHERE customerid = 11000
AND orderdate >= '2013-01-01';

-- Output : 
"Bitmap Heap Scan on salesorderheader  (cost=4.30..12.02 rows=2 width=19) (actual time=0.026..0.031 rows=3 loops=1)"
"  Recheck Cond: (customerid = 11000)"
"  Filter: (orderdate >= '2013-01-01 00:00:00'::timestamp without time zone)"
"  Heap Blocks: exact=3"
"  ->  Bitmap Index Scan on idx_salesorderheader_customerid  (cost=0.00..4.30 rows=2 width=0) (actual time=0.019..0.019 rows=3 loops=1)"
"        Index Cond: (customerid = 11000)"
"Planning Time: 0.163 ms"
"Execution Time: 0.059 ms"

-- Optimize : create index 

CREATE INDEX idx_customer_orderdate
ON sales.salesorderheader(customerid, orderdate);

-- After optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales.salesorderheader
WHERE customerid = 11000
AND orderdate >= '2013-01-01';

-- Output 
"Bitmap Heap Scan on salesorderheader  (cost=4.30..12.02 rows=2 width=19) (actual time=0.013..0.017 rows=3 loops=1)"
"  Recheck Cond: (customerid = 11000)"
"  Filter: (orderdate >= '2013-01-01 00:00:00'::timestamp without time zone)"
"  Heap Blocks: exact=3"
"  ->  Bitmap Index Scan on idx_salesorderheader_customerid  (cost=0.00..4.30 rows=2 width=0) (actual time=0.008..0.008 rows=3 loops=1)"
"        Index Cond: (customerid = 11000)"
"Planning Time: 0.815 ms"
"Execution Time: 0.047 ms"


-- Test case 4

-- Before optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales.salesorderheader
ORDER BY orderdate DESC
LIMIT 100;

-- Output :
"Limit  (cost=2270.22..2270.47 rows=100 width=19) (actual time=12.831..12.838 rows=100 loops=1)"
"  ->  Sort  (cost=2270.22..2348.88 rows=31465 width=19) (actual time=12.829..12.832 rows=100 loops=1)"
"        Sort Key: orderdate DESC"
"        Sort Method: top-N heapsort  Memory: 39kB"
"        ->  Seq Scan on salesorderheader  (cost=0.00..1067.65 rows=31465 width=19) (actual time=0.011..6.848 rows=31465 loops=1)"
"Planning Time: 0.122 ms"
"Execution Time: 12.858 ms"

-- Optimize : create index 
CREATE INDEX idx_salesorderheader_orderdate
ON sales.salesorderheader(orderdate DESC);

-- After optimization 

EXPLAIN ANALYZE
SELECT salesorderid,
       orderdate,
       totaldue
FROM sales.salesorderheader
ORDER BY orderdate DESC
LIMIT 100;

-- Output 
"Limit  (cost=0.29..4.58 rows=100 width=19) (actual time=0.029..0.061 rows=100 loops=1)"
"  ->  Index Scan using idx_salesorderheader_orderdate on salesorderheader  (cost=0.29..1352.30 rows=31465 width=19) (actual time=0.028..0.056 rows=100 loops=1)"
"Planning Time: 0.687 ms"
"Execution Time: 0.074 ms"


-- Test case 5 

-- Before optimization 

EXPLAIN ANALYZE
SELECT productid,
       SUM(orderqty) AS total_qty
FROM sales.salesorderdetail
GROUP BY productid;

-- Output 
"HashAggregate  (cost=3427.76..3430.39 rows=264 width=12) (actual time=26.729..26.758 rows=266 loops=1)"
"  Group Key: productid"
"  Batches: 1  Memory Usage: 61kB"
"  ->  Seq Scan on salesorderdetail  (cost=0.00..2821.17 rows=121317 width=6) (actual time=0.014..6.820 rows=121317 loops=1)"
"Planning Time: 0.174 ms"
"Execution Time: 26.821 ms"

-- Optimize : create index 

CREATE INDEX idx_salesorderdetail_productid_group
ON sales.salesorderdetail(productid);

-- After optimization 
EXPLAIN ANALYZE
SELECT productid,
       SUM(orderqty) AS total_qty
FROM sales.salesorderdetail
GROUP BY productid;

-- Output 
"HashAggregate  (cost=3427.76..3430.39 rows=264 width=12) (actual time=25.806..25.835 rows=266 loops=1)"
"  Group Key: productid"
"  Batches: 1  Memory Usage: 61kB"
"  ->  Seq Scan on salesorderdetail  (cost=0.00..2821.17 rows=121317 width=6) (actual time=0.012..6.302 rows=121317 loops=1)"
"Planning Time: 0.930 ms"
"Execution Time: 25.868 ms"

