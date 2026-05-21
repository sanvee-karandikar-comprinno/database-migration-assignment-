
-- Other validation techniques 

-- Aggregate validation

--MS-SQL

SELECT
    SUM(subtotal) AS total_subtotal,
    SUM(taxamt) AS total_tax,
    SUM(freight) AS total_freight,
    SUM(totaldue) AS total_due
FROM sales.SalesOrderHeader;

-- Output : 109846381.4039	10186974.4602	3183430.2518	123216786.1159

--MySQL

SELECT
    SUM(subtotal) AS total_subtotal,
    SUM(taxamt) AS total_tax,
    SUM(freight) AS total_freight,
    SUM(totaldue) AS total_due
FROM sales_salesorderheader;

-- Output : 109846381.4039	10186974.4602	3183430.2518	123216786.1159

--PostgreSQL

SELECT
    SUM(subtotal) AS total_subtotal,
    SUM(taxamt) AS total_tax,
    SUM(freight) AS total_freight,
    SUM(totaldue) AS total_due
FROM sales.salesorderheader;

-- Output : 109846381.4039	10186974.4602	3183430.2518	123216786.1159


-- Null validation 

--MS-SQL 

SELECT
    COUNT(*) AS null_ship_date
FROM sales.SalesOrderHeader
WHERE shipdate IS NULL;

-- Output : 0

--MySQL 

SELECT
    COUNT(*) AS null_ship_date
FROM sales_salesorderheader
WHERE shipdate IS NULL;

-- Output : 0

--PostgreSQL

SELECT
    COUNT(*) AS null_ship_date
FROM sales.salesorderheader
WHERE shipdate IS NULL;

-- Output : 0

--MS-SQL 

SELECT
    COUNT(*) AS null_end_date
FROM sales.SalesTerritoryHistory
WHERE enddate IS NULL;

-- Output : 13

--MySQL

SELECT
    COUNT(*) AS null_end_date
FROM sales_salesterritoryhistory
WHERE enddate IS NULL;

-- Output : 13

--PostgreSQL

SELECT
    COUNT(*) AS null_end_date
FROM sales.salesterritoryhistory
WHERE enddate IS NULL;

-- Output : 13

--Primary key validation

SELECT
    customerid,
    COUNT(*)
FROM sales_customer
GROUP BY customerid
HAVING COUNT(*) > 1;

-- The output should be blank in all the three databases.

--Min/Max validation 

--MS-SQL

SELECT
    MIN(orderdate) AS min_order_date,
    MAX(orderdate) AS max_order_date
FROM sales.SalesOrderHeader;

-- Output : 2022-05-30 00:00:00.000	2025-06-29 00:00:00.000

--MySQL
SELECT
    MIN(orderdate) AS min_order_date,
    MAX(orderdate) AS max_order_date
FROM sales_salesorderheader;

--PostgreSQL
SELECT
    MIN(orderdate) AS min_order_date,
    MAX(orderdate) AS max_order_date
FROM sales.salesorderheader;

-- Output : "2022-05-30 00:00:00"	"2025-06-29 00:00:00"

