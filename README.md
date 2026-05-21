# Task 5 - Validation
The objective of this task was to verify that the migrated PostgreSQL and MySQL databases matched the original Microsoft SQL Server (MSSQL) source database accurately and completely.

Validation was performed after schema migration and data loading to ensure:
1. No data loss occurred during migration
2. Referential integrity was preserved
3. Numeric and financial values remained accurate
4. Constraints and relationships were maintained
5. Data consistency was identical across all platforms

-- Validation Strategy

The validation process included multiple verification techniques ranging from simple row-count checks to detailed aggregate comparisons and random record audits.

Each validation script was executed against:

1. MSSQL Source Database
2. PostgreSQL Target Database
3. MySQL Target Database
Results were compared to ensure exact consistency.

--Validation Checks Performed : 
1. Row Count Validation
2. Aggregate Validation
3. NULL Validation
4. Primary Key Validation
5. MAX/MIN Validation

--Validation Techniques :
1. Row Count Verification
   Purpose - Ensure every table contains the same number of records after migration.
2. Aggregate Validation
   Purpose - Validate that numeric data remained unchanged after migration.
3. NULL Value Validation
   Purpose - Ensure nullable columns preserved NULL values correctly.
4. Primary Key Validation
   Purpose : Verify uniqueness constraints were preserved
5. MAX/MIN Value Validation
   Purpose : Verify extreme numeric and datetime values migrated correctly.
   
--Validation Challenges Faced
1. Floating-point precision differences  -> 	Used NUMERIC/DECIMAL instead of FLOAT where applicable
2. Encoding inconsistencies  ->	Standardized UTF-8 encoding
3. Datetime precision mismatches  ->	Used TIMESTAMP(7) and DATETIME(6)
4. Binary data verification  -> 	Compared binary sizes and sample integrity
5. NULL handling differences	-> Explicitly validated nullable columns

--Validation Outcome
The validation process confirmed that:
1. Schema migration was successful
2. Data integrity was preserved
3. Constraints and relationships remained intact
4. No critical mismatches were found
5. PostgreSQL and MySQL databases accurately reflected the MSSQL source database

All validation checks completed successfully across the migrated environments.
