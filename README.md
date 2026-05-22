# Task 1 - Schema and data migration 
### Objective :
The objective of this task was to migrate the complete Microsoft SQL Server (MSSQL) database schema and data to PostgreSQL and MySQL while preserving:
1. Table structures
2. Constraints
3. Relationships
4. Indexes
5. Nullability
6. Default values
7. Referential integrity
The migration process ensured that the target databases behaved functionally equivalent to the original MSSQL source database.

### Migration Overview
The migration process was divided into two major phases:
1.Schema Migration
2.Data Migration

Both PostgreSQL and MySQL target platforms required syntax adaptation and datatype compatibility handling because MSSQL-specific features are not directly supported in open-source databases.

### Schema Migration
#### PostgreSQL Migration
##### Approach
The MSSQL schema was converted into PostgreSQL-compatible DDL scripts by modifying:

1.MSSQL-specific datatypes
2.Constraint syntax
3.Identity column definitions
4.Index definitions
5.XML-related functionality
6.Major Datatype Conversions

##### Key PostgreSQL Adjustments
1. Replaced GETDATE() with NOW()
2. Replaced NEWID() with gen_random_uuid()
3. Replaced clustered indexes with PostgreSQL B-tree indexes
4. Used GENERATED AS IDENTITY for identity columns
5. Converted XML logic where supported


#### MySQL Migration Approach

The MSSQL schema was adapted to MySQL-compatible syntax while preserving structural integrity.

##### Major Datatype Conversions
1. UNIQUEIDENTIFIER	 -> CHAR(50)
2. BIT ->	TINYINT(1)
3. IMAGE ->	LONGBLOB
4. MONEY ->	DECIMAL(19,4)
5. XML -> LONGTEXT


##### Key MySQL Adjustments
1. Used AUTO_INCREMENT for identity columns
2. Replaced unsupported XML functionality
3. Configured UTF8MB4 character encoding
4. Adapted index syntax for MySQL compatibility


### Data Migration
#### Migration Process

The data migration process included:

1. Exporting data from MSSQL
2. Converting encoding to UTF-8
3. Loading parent tables before child tables
4. Preserving foreign key relationships
5. Verifying row counts after migration


#### Referential Integrity Handling

To maintain referential integrity:

1. Parent tables were loaded first
2. Child tables were loaded afterward
3. Foreign key constraints were validated after import

Migration order followed dependency hierarchy to avoid constraint violations.


### Challenges Faced & Resolutions

1. MSSQL XML functions unsupported in PostgreSQL/MySQL
   Resolution : Replaced XML parsing logic using platform-compatible alternatives
2. View dependency issues during datatype modification
   Resolution : Dropped dependent views temporarily and recreated them later
3. Clustered index behavior differs across platforms
   Resolution : Recreated indexes using equivalent B-tree indexes
4. Encoding mismatches between MSSQL and targets
   Resolution : Standardized exports to UTF-8
5. Identity column syntax differences
   Resolution : Used GENERATED AS IDENTITY and AUTO_INCREMENT
6. UUID handling differences
   Resolution : Used PostgreSQL UUID and MySQL CHAR(50)
7. Binary IMAGE migration issues
   Resolution : Converted IMAGE data to BYTEA/LONGBLOB
8. Reserved keyword conflicts
   Resolution : Escaped identifiers appropriately
9. Datetime precision mismatches
    Resolution : Used TIMESTAMP(7) and DATETIME(6)


