# Task 6 - Automation
### Project Overview

This project implements an automated cross-database migration pipeline that migrates data from MySQL to PostgreSQL using Python-based ETL scripts.

It handles:

1.Schema conversion

2.Data cleaning and transformation

3.Bulk data loading

4.Retry mechanism for failed tables

5.Handling data type mismatches and constraints


The system is built for AdventureWorks-style relational datasets with multiple schemas like dbo, person, production, sales, etc.

### Objectives
1.Automate migration from MySQL → PostgreSQL

2.Preserve relational integrity across schemas

3.Handle data type mismatches (TEXT, NUMERIC, BYTEA, UUID, etc.)

4.Fix schema-level conflicts (reserved keywords, naming issues)

5.Retry failed table loads automatically

6.Ensure zero manual intervention after setup


#### Tech Stack used
1.Python 3.x

2.MySQL

3.PostgreSQL

4.Pandas

5.NumPy

6.Psycopg2


#### ETL Workflow
1. Extract
   
   -> Data exported from MySQL tables

   -> Stored as CSV files in exported_data/

2. Transform
     -> Column normalization

     -> Null handling

     -> Data type corrections:

     -> BYTEA → Base64 encoded binary

     -> NaN → NULL

     -> Reserved keywords renamed

3. Load
   
   -> Bulk insert into PostgreSQL

   -> Schema-based insertion per table

   -> Schema-separated design (dbo, person, sales, etc.)

4. Retry Engine
Automatically retries failed tables

Fixes:

1.duplicate keys

2.missing constraints

3.type mismatches

4.Uses ON CONFLICT DO NOTHING

#### Key Challenges Solved

1.Reserved keyword conflicts (group, primary)

2.BYTEA binary conversion issues

3.Duplicate primary key handling

4.Missing NOT NULL values

5.Schema mismatch between MySQL and PostgreSQL

6.Large dataset bulk insertion optimization
