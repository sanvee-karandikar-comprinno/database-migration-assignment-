# Task 1 - Schema and data migration 
Objective :
The objective of this task was to migrate the complete Microsoft SQL Server (MSSQL) database schema and data to PostgreSQL and MySQL while preserving:
1. Table structures
2. Constraints
3. Relationships
4. Indexes
5. Nullability
6. Default values
7. Referential integrity
The migration process ensured that the target databases behaved functionally equivalent to the original MSSQL source database.

--Migration Overview
The migration process was divided into two major phases:
1.Schema Migration
2.Data Migration

Both PostgreSQL and MySQL target platforms required syntax adaptation and datatype compatibility handling because MSSQL-specific features are not directly supported in open-source databases.

--Schema Migration
--PostgreSQL Migration
--Approach
The MSSQL schema was converted into PostgreSQL-compatible DDL scripts by modifying:

MSSQL-specific datatypes
Constraint syntax
Identity column definitions
Default value expressions
Index definitions
XML-related functionality
Major Datatype Conversions
MSSQL	PostgreSQL
DATETIME	TIMESTAMP
DATETIME2	TIMESTAMP(7)
UNIQUEIDENTIFIER	UUID
BIT	BOOLEAN
MONEY	NUMERIC(19,4)
IMAGE	BYTEA
NVARCHAR	VARCHAR
ROWVERSION	BYTEA
Key PostgreSQL Adjustments
Replaced GETDATE() with NOW()
Replaced NEWID() with gen_random_uuid()
Replaced clustered indexes with PostgreSQL B-tree indexes
Used GENERATED AS IDENTITY for identity columns
Converted XML logic where supported
MySQL Migration
Approach

The MSSQL schema was adapted to MySQL-compatible syntax while preserving structural integrity.

Major Datatype Conversions
MSSQL	MySQL
UNIQUEIDENTIFIER	CHAR(36)
BIT	TINYINT(1)
IMAGE	LONGBLOB
MONEY	DECIMAL(19,4)
DATETIME2	DATETIME(6)
XML
