# Task 2 - Stored Procedure, View & Function Conversion

### Objective : 
The objective of this task was to convert Microsoft SQL Server (MSSQL) stored procedures, views, and functions into PostgreSQL PL/pgSQL and MySQL-compatible procedural syntax while preserving:
1. Business logic
2. Query behavior
3. Data integrity
4. Performance
5. Readability
6. Maintainability

The migration process focused on adapting MSSQL-specific features into equivalent PostgreSQL and MySQL implementations using platform-native syntax and optimization techniques.

### Components Converted
The following database objects were analyzed and migrated:
1. Stored Procedures	-> Business logic and transactional operations
2. Views	-> Virtual query-based tables
3. Scalar Functions	-> Functions returning single values
4. Table-Valued Functions	-> Functions returning result sets
5. XML-Based Views/Functions ->	MSSQL XML parsing logic

### Stored Procedure Conversion
#### PostgreSQL Conversion
Stored procedures written in T-SQL were rewritten using PL/pgSQL syntax.

##### Major Syntax Changes
1. GETDATE() -> 	NOW()
2. ISNULL()	-> COALESCE()
3. PRINT	-> RAISE NOTICE
4. TOP N -> LIMIT N
5. NEWID()	-> gen_random_uuid()
6. @@ROWCOUNT	-> GET DIAGNOSTICS
7. TRY...CATCH	-> EXCEPTION WHEN OTHERS
8. CONVERT()	-> CAST()/TO_CHAR()

#### MySQL Conversion
Procedures were adapted to MySQL procedural syntax using:
1. DELIMITER handling
2. BEGIN...END blocks
3. IF/ELSE logic
4. DECLARE statements

### Function Conversion
Objective :
MSSQL scalar and table-valued functions were converted into PostgreSQL and MySQL functions while preserving functionality and return behavior.

### View Conversion
Objective :
Views were migrated to PostgreSQL and MySQL while preserving:
1. Query logic
2. Joins
3. Aggregations
4. Filtering
5. XML transformations where applicable

### XML View & Function Handling
Challenge - MSSQL XML methods such as:
            1).value()
            2).nodes()
            3).query()

The above methods are not fully supported in MySQL and differ significantly in PostgreSQL.

#### Resolution :
##### PostgreSQL
       1.Used XML/XPath-compatible functions where possible
       2. Converted some XML logic into TEXT processing
##### MySQL
       1. Stored XML data as LONGTEXT
       2. Rewrote XML extraction logic manually

### Challenges Faced & Resolutions

1. T-SQL syntax incompatible with PostgreSQL/MySQL
   Resolution : Rewrote logic using native syntax
2. XML functions unsupported
   Resolution : Replaced XML logic using alternative methods
3. Cursor-heavy procedures caused poor performance
   Resolution : Converted to set-based queries
4. View dependencies blocked datatype changes
   Resolution : Dropped and recreated dependent views
5. Different string concatenation syntax
   Resolutiion : Used CONCAT() and || operators
6. Error handling differences
   Resolution : Used native exception blocks
7. Identity and UUID generation differences
   Resolution : Replaced with native equivalents

