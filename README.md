# Task 6 — Automation

### Project Overview
This project establishes a fully automated, end-to-end data modernization and cross-database migration pipeline designed to extract operational data from a MySQL source environment and synchronize it into a PostgreSQL cluster. Powered by a modular architecture of Python-based ETL (Extract, Transform, Load) engines, the system isolates, sanitizes, and streams complex datasets while maintaining absolute structural fidelity.

The pipeline natively orchestrates:
1. Schema conversion and relational namespace initialization.
2. Advanced data cleansing, text sanitization, and data transformation routines.
3. High-performance chunked bulk data loading to mitigate runtime memory caps.
4. An autonomous retry engine built to resolve failed table migrations dynamically.
5. In-flight handling of heterogeneous data type mismatches and database integrity constraints.

The pipeline architecture is purpose-built to navigate highly complex, multi-schema relational environments (such as the AdventureWorks dataset), seamlessly mapping isolated legacy tiers into standardized PostgreSQL schema namespaces including `dbo`, `person`, `production`, and `sales`.

---

### Objectives
To achieve true production-grade automation, the pipeline operates under strict technical parameters:
* **End-to-End Automation:** Seamlessly automate the entire migration lifecycle from MySQL to PostgreSQL, requiring zero manual developer intervention following initial configuration.
* **Relational Topology Preservation:** Enforce and protect transactional integrity, relational constraints, foreign key mappings, and schema-level isolation across the destination environment.
* **Heterogeneous Type Translation:** Intercept and normalize incompatible, platform-specific data fields into compliant native formats such as `TEXT`, `NUMERIC`, `BYTEA`, and `UUID`.
* **Conflict Resolution Management:** Programmatically detect and resolve schema-level syntax collisions, such as engine-reserved SQL keywords and platform-specific naming conventions.
* **Fault-Tolerant Execution:** Implement a robust retry framework that catches execution exceptions, addresses underlying structural failures, and re-runs table deployments automatically.

---

### Technical Infrastructure Stack
The foundational technologies powering this modernization toolset include:
1. **Python 3.x Engine:** The core runtime hosting the execution scripts and connection managers.
2. **MySQL Database Instance:** The legacy source dataset repository.
3. **PostgreSQL Database Target:** The optimized destination database cluster.
4. **Pandas & NumPy Libraries:** The high-performance data processing framework used for vectorized in-memory data normalization and cleansing.
5. **Psycopg2 Client Driver:** The multi-threaded connection pooling interface utilizing native PostgreSQL C-extensions for raw data streaming.

---

### ETL Pipeline Workflow Architecture

#### 1. Extraction Phase
The pipeline initiates a connection to the source MySQL server and queries active base tables across target schemas. Data is exported sequentially in structured blocks and staged locally as compressed CSV assets inside the `exported_data/` directory. Staging the data as physical files decouples the extraction and ingestion phases, protecting production database connections from extended query lockouts.

#### 2. Transformation Phase
The staged records are loaded into vectorized data structures where the transformation engine scrubs the data layer before wire transfer:
* **Column Canonicalization:** Cleanses text attributes, strips whitespace anomalies, and sanitizes character encoding configurations into universal UTF-8 streams.
* **Null Pointer Normalization:** Intercepts system NaN markers and re-maps them to explicit `NULL` database variables to prevent target parser crashes.
* **Type Conversion Matrices:** Encodes raw binary inputs into safe Base64 text representations to safely construct PostgreSQL `BYTEA` records.
* **Namespace Collision Override:** Automatically intercepts columns leveraging SQL reserved keywords and appends descriptive namespaces to avoid parsing errors.

#### 3. Loading Phase
The normalized datasets are pushed into the target PostgreSQL cluster via optimized bulk data streams. The loader engine interprets the target schema mappings, initiates transaction blocks per database schema, and streams records concurrently into their corresponding destination namespaces (`dbo`, `person`, `sales`).

#### 4. Automated Retry Engine
Any table configuration that trips a database exception during the initial bulk load is systematically cataloged and handed off to a secondary isolation layer. The retry framework analyzes the root cause of the deployment failure, alters row boundaries dynamically using safe transactional insertion syntax (`ON CONFLICT DO NOTHING`), rewires missing constraints on-the-fly, and pushes the data back to disk to guarantee data completeness.

---

### Critical Operational Challenges Overcome
* **Reserved Word Collisions:** Prevented critical execution failures caused by columns using reserved database words (such as `group` or `primary`) by rewriting query mappings programmatically during the migration loop.
* **Binary Data Transport Deficiencies:** Solved PostgreSQL stream truncation bugs when processing raw binary data blocks by passing inputs through strict Base64 serialization algorithms.
* **Primary Key Ingestion Deadlocks:** Eliminated pipeline rollbacks caused by duplicate constraint violations by injecting conditional upsert expressions into the loading stream.
* **Schema Topology Mismatches:** Standardized MySQL's flat table layouts into PostgreSQL's strictly isolated multi-schema architectures, preventing name collisions across different operational modules.
* **Volume Load Performance Bottlenecks:** Optimized host memory footprints when handling multi-million-row tables by implementing dynamic cursor chunking and parameterized array data streaming.

---

### Step-by-Step Pipeline Execution Guide

#### Step 1: Initialize the Isolated Virtual Environment
Open your system terminal, navigate directly to your project root folder, and execute the built-in virtual environment constructor:

```cmd
python -m venv venv
```

#### Step 2: Activate the Working Environment Context
Route your system terminal execution commands into the newly created environment based on your current host operating system:

**For Windows Systems:**
```cmd
venv\Scripts\activate
```
**For Linux and macOS Systems:**

```cmd
source venv/bin/activate
```

#### Step 3: Install the requirements
Upgrade your internal package management systems and trigger a batch compilation of required database connectors and calculation utilities:
```cmd
pip install pyodbc mysql-connector-python psycopg2
```
#### Step 4: Configure Database Connection Parameters
Open the central configuration file config.py in your development environment and update the authentication maps to reflect your specific database endpoints.

#### Step 5 : Run the project files.

### Final Project Deliverables & What We Achieved

* **Successful Database Move:** We successfully moved the entire database from the old system into a modern, fully working MySQL and PostgreSQL setup where all information is organized cleanly.
* **Works Across Different Databases:** We built a system that understands different database languages (dialects). This means it can safely translate and move data between completely different database types without breaking anything.
* **Fully Automated Pipeline:** We replaced slow, manual copying methods with an automatic, hands-free data pipeline (ETL). Once it is set up, the system runs completely on its own without needing a human to click buttons or monitor it.
* **Perfect Data Accuracy:** The system keeps all original data perfectly intact. It preserves your exact data history, matches up all tracking IDs, and ensures no information is lost, modified, or corrupted during the move.
* **Built-in Error Recovery:** We built a smart cleanup engine to handle unexpected errors. If a complex file or weirdly formatted piece of data fails on the first try, this backup engine automatically steps in, fixes the issue on-the-fly, and finishes loading the data safely.
