# Maji Ndogo — SQL Analysis

This project uses MySQL to analyse the Maji Ndogo water survey dataset and turn the data into actionable insights for improving water access.

The SQL work is divided into four parts, moving from **data exploration and cleaning → analysis → auditing → decision-making**.

## SQL Part 1 — Data Exploration & Cleaning

Explored the database, identified data quality issues, and corrected inaccurate records.

**Main SQL skills:**

* `SHOW TABLES`, `SELECT`, `LIMIT`
* `DISTINCT`
* Filtering with `WHERE`, `IN`, `LIKE`
* `AND` conditions
* `UPDATE`
* `CREATE TABLE ... AS`
* Data validation and testing before updates

**=>** Understanding the dataset and fixing data quality problems.

---

## SQL Part 2 — Data Analysis & Prioritisation

Grouped and summarised the survey data to understand water access, population coverage, water sources, and queue patterns.

**Main SQL skills:**

* `GROUP BY`, `ORDER BY`, `LIMIT`
* Aggregations: `COUNT`, `SUM`, `AVG`, `ROUND`
* `JOIN`
* Subqueries
* `RANK`, `DENSE_RANK`, `ROW_NUMBER`
* Window functions with `PARTITION BY`
* Date/time functions: `DATEDIFF`, `DAYNAME`, `TIME_FORMAT`
* `CASE` for conditional logic and pivot tables
* `NULLIF`

**=>** Finding patterns and prioritising the biggest water problems.

---

## SQL Part 3 — Data Auditing & Investigation

Loaded an independent audit report and compared it with the original survey data to identify inconsistent quality scores and investigate their sources.

**Main SQL skills:**

* Creating and importing tables
* Multi-table `JOIN`s
* Table aliases
* `CTE`s (Common Table Expressions)
* `VIEW`s
* Aggregations with `COUNT` and `GROUP BY`
* Subqueries
* `LIKE`
* Data validation after joins

**=>** Comparing datasets, tracing inconsistencies, and investigating data quality issues.

---

## SQL Part 4 — From Analysis to Action

Combined the analysed data into reusable views and created a project-tracking table to turn the findings into repair actions.

**Main SQL skills:**

* `JOIN` and `LEFT JOIN`
* `VIEW`s
* `CTE`s
* `CASE` statements
* Composite-key joins
* Temporary tables
* `CREATE TABLE`
* Primary and foreign keys
* `CHECK` and `DEFAULT` constraints
* `INSERT INTO ... SELECT`
* Conditional calculations with `FLOOR` and `CONCAT`

**=>** Transforming analysis into practical repair plans and a system for tracking improvements.

---

## Skills Demonstrated

* SQL data exploration
* Data cleaning and validation
* Filtering and aggregation
* Multi-table joins
* Subqueries and CTEs
* Window functions
* Views and temporary tables
* Data quality auditing
* Database constraints and relationships
* Turning data analysis into actionable decisions
**Tools:** MySQL, MySQL Workbench

## Dataset

The project uses the **Maji Ndogo water services dataset** provided as part of the ALX Data Engineering program.
The dataset is not included in this repository due to its size. To reproduce the project, obtain the dataset from the corresponding ALX course materials and import `md_water_services.sql` into MySQL before running the queries.
