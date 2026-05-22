# Task 4 — Performance Optimization

### Objective :
The objective of this task was to identify and resolve query performance regressions introduced after migrating the Microsoft SQL Server database to PostgreSQL. Since different database platforms use different query planners, indexing mechanisms, and execution strategies, several queries that performed efficiently in MSSQL required additional optimization in PostgreSQL to achieve comparable or improved execution performance.

The optimization process involved analyzing slow-running queries, evaluating execution plans using PostgreSQL EXPLAIN ANALYZE, identifying bottlenecks, and applying targeted improvements to reduce query execution time and resource consumption.

### Approach : 
The optimization workflow began by executing commonly used application queries against the migrated PostgreSQL database and measuring their execution times. Queries with higher execution times were analyzed using EXPLAIN ANALYZE to understand how PostgreSQL processed joins, filters, sorting operations, and index usage.
Several performance issues were identified during analysis, including sequential scans on large tables, inefficient nested loop joins, missing indexes, and unnecessary sorting operations. To resolve these issues, indexing strategies and query rewrites were applied based on PostgreSQL query planner behavior.

### Optimization Techniques Applied :
Query optimization included restructuring SQL queries to reduce execution cost and improve readability. Correlated subqueries were replaced with joins and Common Table Expressions wherever possible to improve execution efficiency. Unnecessary nested queries and redundant filtering logic were removed to simplify execution plans.

Index optimization focused on columns commonly used in WHERE clauses, JOIN conditions, and ORDER BY operations. Composite indexes were introduced for multi-column filtering patterns, and B-tree indexes were used to improve search and sorting performance.

Execution plans generated using EXPLAIN ANALYZE were used to identify sequential scans and high-cost operations. Queries performing full-table scans on large datasets were optimized by introducing appropriate indexing strategies.

### Challenges Faced : 
Several challenges were encountered during the optimization process due to differences between MSSQL and PostgreSQL query execution behavior. Queries that performed efficiently in MSSQL sometimes resulted in sequential scans or inefficient join strategies in PostgreSQL because the PostgreSQL planner uses different optimization heuristics.

Index behavior also differed across platforms, especially for clustered indexes, which required alternative implementations using PostgreSQL B-tree indexes. Some queries originally written for MSSQL relied heavily on procedural or nested logic, requiring query rewrites to achieve better PostgreSQL performance.

Another challenge involved ensuring that optimization changes did not alter query results or business logic. All optimized queries were validated against original MSSQL outputs to confirm result consistency after performance improvements.
