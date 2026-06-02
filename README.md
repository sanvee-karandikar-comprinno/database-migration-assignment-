# Database Modernization Assignment  
## Cross-Platform Database Migration & Optimization

This repository contains a complete implementation of a **cross-platform database modernization project** involving migration from **Microsoft SQL Server (MSSQL)** to **PostgreSQL and MySQL**.

The project demonstrates real-world enterprise database migration practices, including schema transformation, data movement, performance tuning, validation, and automation.

It simulates a production-grade modernization pipeline commonly used when moving from proprietary database systems to open-source relational databases.

---

#  Objective

The primary objective of this project was to perform a **full-scale database modernization** by migrating an enterprise-style **Microsoft SQL Server (MSSQL)** database into:

- PostgreSQL  
- MySQL  

The migration ensured:

- Schema integrity preservation  
- Accurate data transfer  
- Constraint and relationship mapping  
- Business logic conversion  
- Cross-platform compatibility  
- Performance optimization  
- Automated reprocessing and failure handling  

---

#  Project Scope

- Schema analysis and conversion from MSSQL  
- Data migration to PostgreSQL and MySQL  
- Stored procedure, view, and function conversion  
- Data type mapping and compatibility handling  
- Performance tuning and indexing  
- Data validation and reconciliation  
- Automation for retry and failure recovery  

---

#  Task Breakdown

##  Task 1: Schema & Data Migration

- Extracted schema from Microsoft SQL Server  
- Converted schema for PostgreSQL and MySQL compatibility  
- Created database structures in both target systems  
- Migrated data using ETL scripts  
- Ensured referential integrity across tables  

---

##  Task 2: Stored Procedure, View & Function Conversion

- Identified MSSQL stored procedures, views, and functions  
- Converted T-SQL logic into PostgreSQL (PL/pgSQL) and MySQL syntax  
- Rewritten procedural logic (loops, conditions, variables)  
- Replaced unsupported MSSQL-specific constructs  

---

##  Task 3: Data Type Mapping & Compatibility

- Mapped MSSQL data types to PostgreSQL and MySQL equivalents  
- Handled conversions for DATETIME, BIT, UNIQUEIDENTIFIER, TEXT, etc.  
- Standardized numeric precision and string encoding  
- Resolved truncation and type mismatch issues  

---

##  Task 4: Performance Optimization

- Created indexes on frequently queried columns  
- Analyzed query execution plans  
- Optimized joins and filtering conditions  
- Removed redundant indexes and constraints  
- Improved overall query performance  

---

##  Task 5: Data Validation & Reconciliation

- Performed row count validation across all databases  
- Verified schema consistency between source and targets  
- Checked null values, constraints, and relationships  
- Identified and resolved data mismatches  
- Ensured data integrity after migration  

---

##  Task 6: Automation (Failure Handling & Retry System)

- Built Python-based automation scripts for migration handling  
- Implemented retry mechanism for failed table loads  
- Added logging for failed and successful operations  
- Enabled batch-wise schema processing  
- Implemented checkpoint-based execution  
- Reduced manual intervention in migration pipeline  

---

#  Technologies Used

- Microsoft SQL Server (Source Database)  
- PostgreSQL (Target Database)  
- MySQL (Target Database)  
- Python (Automation & ETL scripts)  
- SQL (Schema & Query conversion)  
- PgAdmin / MySQL Workbench  

---

#  Key Achievements

- Successfully migrated enterprise MSSQL database  
- Converted schema and business logic across multiple database engines  
- Implemented full data validation framework  
- Built automated retry and recovery pipeline  
- Improved query performance through optimization  
- Ensured high data integrity and consistency  

---

#  Project Outcome

This project demonstrates a complete **end-to-end database modernization pipeline**, covering:

- Database migration engineering  
- Cross-platform compatibility handling  
- Data validation and reconciliation  
- Performance optimization  
- Automation and failure recovery  

It reflects real-world skills required in **data engineering, backend systems, and enterprise database modernization projects**.
