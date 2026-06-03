# Task 4 — Performance Optimization

### Objective
The primary objective of this task was to systematically identify, analyze, and resolve query performance regressions introduced during the database migration from Microsoft SQL Server to PostgreSQL. Because different database platforms utilize entirely distinct query planners, indexing mechanisms, and execution strategies, several queries that performed efficiently in MSSQL suffered severe performance degradation in PostgreSQL.

The optimization process focused on:
* Analyzing slow-running queries across critical application paths.
* Evaluating detailed, low-level execution plans using the PostgreSQL `EXPLAIN ANALYZE` command.
* Isolating systemic processing bottlenecks such as excessive memory allocations and Disk I/O swapping.
* Applying targeted indexing modifications and structural query rewrites to drastically minimize query execution runtime and host resource consumption.

---

### Approach
The optimization workflow followed a structured, data-driven cycle designed to ensure measurable performance improvements without risking regressions in data accuracy:

1. **Baseline Measurement:** Commonly used application queries were executed against the freshly migrated PostgreSQL database to capture precise baseline execution times, establishing a performance benchmark.
2. **Execution Plan Inspection:** High-latency queries exceeding performance thresholds were dissected using the `EXPLAIN ANALYZE` utility. This allowed the engineering team to map out exactly how the PostgreSQL query planner processed joins, filter criteria, sorting operations, and index allocations.
3. **Bottleneck Identification:** The analysis successfully surfaced multiple critical performance barriers, including:
   * **Sequential Scans (Seq Scan):** High-cost full-table scans occurring on deeply populated tables because the query planner lacked appropriate structural indexes.
   * **Inefficient Join Strategies:** Excessive usage of nested loop joins on large datasets where hash joins or merge joins would drastically lower CPU overhead.
   * **Missing Secondary Targets:** Crucial lookup columns operating without proper structural support.
   * **Unnecessary Sort Operations:** Costly sorting operations (`Sort Method: quicksort`) occurring in memory or spilling onto temporary disk space due to unoptimized `ORDER BY` configurations.
4. **Resolution Implementation:** Indexing strategies and query rewrites were tailored directly to align with the PostgreSQL query planner's cost-based optimization heuristics.

---

### Optimization Techniques Applied

#### Query Restructuring and Modernization
* **Subquery Elimination:** Replaced resource-heavy, correlated subqueries with high-performance `JOIN` operations and Common Table Expressions (CTEs). This allowed the query planner to materialize intermediate datasets more efficiently and process data in a declarative, set-based manner.
* **Logic Simplification:** Stripped away redundant filtering conditions, duplicate nested select statements, and unnecessary type-casting functions to clean up execution plans and decrease compilation overhead.

#### Strategic Indexing Optimization
* **Targeted Filtering Support:** Engineered precise secondary indexes focusing primarily on foreign keys and columns heavily utilized in `WHERE` clauses, `JOIN` conditions, and `ORDER BY` operations.
* **Advanced Composite Layouts:** Introduced multi-column (composite) indexes to accelerate queries utilizing complex multi-variable filtering patterns, ensuring the query planner could isolate rows using index scans rather than reading the entire physical table.
* **B-Tree Sorting Alignment:** Leveraged optimized B-tree indexes natively to match data retrieval with requested application sorting orders, effectively bypassing expensive, runtime sorting steps.

#### Execution Cost Reduction
* **Sequential Scan Remediation:** Used the direct output of `EXPLAIN ANALYZE` to hunt down high-cost full-table scans on massive datasets, immediately resolving them with matching index additions or query hints that forced index usage.

---

### Challenges Faced and Overcome

Several challenges were encountered during the optimization process due to foundational differences between the MSSQL and PostgreSQL query execution engines:

* **Query Planner Heuristic Divergence:** Database systems use completely unique, proprietary cost estimation formulas. A query that ran perfectly in Microsoft SQL Server often triggered catastrophic slowness or fallback sequential scans when passed raw into PostgreSQL because the planner estimated row counts and data distributions differently.
* **Clustered Index Discrepancies:** Microsoft SQL Server relies heavily on clustered indexes to physically order table data on storage disks. Since PostgreSQL organizes physical table storage differently (using heap structures), alternative indexing architectures had to be mapped out from scratch using custom PostgreSQL B-tree configurations to achieve comparable physical data layout advantages.
* **Procedural-to-Declarative Rewrites:** Legacy queries originating from MSSQL frequently relied on heavy procedural syntax, temporary tables, or deeply nested structural logic. These code blocks had to be completely rewritten into set-based, declarative SQL logic to maximize PostgreSQL performance.
* **Data Integrity and Result Safeguards:** A major challenge was ensuring that extensive optimization passes never altered underlying business logic or accidentally modified raw dataset outcomes. 

#### Validation Protocol
To ensure absolute data fidelity throughout the optimization cycle, all modified queries went through strict regression validation checks. Their final outputs were cross-referenced directly against the original MSSQL master datasets to confirm 100% result consistency and matching schemas.
