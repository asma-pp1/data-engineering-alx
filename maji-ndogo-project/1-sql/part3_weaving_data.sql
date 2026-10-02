-- Maji Ndogo Water Services | SQL Part 3
-- Weaving the data threads: joins, audit report, CTEs and views
-- Database: md_water_services

USE md_water_services;


-- 1. VALIDATE TABLE RELATIONSHIPS
-- Generate the ERD in MySQL Workbench.
-- Verify relationships.

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT record_id) AS unique_ids
FROM visits;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT record_id) AS unique_ids
FROM water_quality;


-- 2. IMPORT THE AUDITOR REPORT
-- Create the table, then import Auditor_report.csv

DROP TABLE IF EXISTS auditor_report;

CREATE TABLE auditor_report (
    location_id VARCHAR(32),
    type_of_water_source VARCHAR(64),
    true_water_source_score INT,
    statements VARCHAR(255)
);

SELECT COUNT(*) AS audited_sites
FROM auditor_report;


-- 3. COMPARE AUDITOR AND SURVEYOR SCORES
-- Keep only the first visit to avoid duplicate locations.

SELECT
    a.location_id,
    v.record_id,
    a.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS surveyor_score
FROM auditor_report AS a
JOIN visits AS v
    ON a.location_id = v.location_id
JOIN water_quality AS wq
    ON v.record_id = wq.record_id
WHERE v.visit_count = 1
  AND a.true_water_source_score != wq.subjective_quality_score;


-- 4. CHECK WATER-SOURCE TYPES
-- Confirm whether the auditor's source types match the original data.

SELECT
    a.location_id,
    a.type_of_water_source AS auditor_source,
    ws.type_of_water_source AS survey_source
FROM auditor_report AS a
JOIN visits AS v
    ON a.location_id = v.location_id
JOIN water_quality AS wq
    ON v.record_id = wq.record_id
JOIN water_source AS ws
    ON v.source_id = ws.source_id
WHERE v.visit_count = 1
  AND a.true_water_source_score != wq.subjective_quality_score;


-- 5. CREATE A VIEW OF INCORRECT RECORDS
-- Reuse this query to investigate score mismatches.

DROP VIEW IF EXISTS Incorrect_records;

CREATE VIEW Incorrect_records AS
SELECT
    a.location_id,
    v.record_id,
    e.employee_name,
    a.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS surveyor_score,
    a.statements
FROM auditor_report AS a
JOIN visits AS v
    ON a.location_id = v.location_id
JOIN water_quality AS wq
    ON v.record_id = wq.record_id
JOIN employee AS e
    ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1
  AND a.true_water_source_score != wq.subjective_quality_score;

SELECT COUNT(*) AS incorrect_records
FROM Incorrect_records;


-- 6. COUNT MISMATCHES PER EMPLOYEE

SELECT
    employee_name,
    COUNT(*) AS number_of_mistakes
FROM Incorrect_records
GROUP BY employee_name
ORDER BY number_of_mistakes DESC;


-- 7. IDENTIFY EMPLOYEES WITH ABOVE-AVERAGE MISMATCH COUNTS

WITH error_count AS (
    SELECT
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
)
SELECT *
FROM error_count
WHERE number_of_mistakes > (
    SELECT AVG(number_of_mistakes)
    FROM error_count
);


-- 8. REVIEW RECORDS AND STATEMENTS FOR FURTHER INVESTIGATION

WITH error_count AS (
    SELECT
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
suspect_list AS (
    SELECT employee_name
    FROM error_count
    WHERE number_of_mistakes > (
        SELECT AVG(number_of_mistakes)
        FROM error_count
    )
)
SELECT
    employee_name,
    location_id,
    statements
FROM Incorrect_records
WHERE employee_name IN (
    SELECT employee_name FROM suspect_list
);


-- 9. CHECK CASH-RELATED STATEMENTS OUTSIDE THE ABOVE-AVERAGE GROUP

WITH error_count AS (
    SELECT
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
suspect_list AS (
    SELECT employee_name
    FROM error_count
    WHERE number_of_mistakes > (
        SELECT AVG(number_of_mistakes)
        FROM error_count
    )
)
SELECT
    employee_name,
    location_id,
    statements
FROM Incorrect_records
WHERE employee_name NOT IN (
    SELECT employee_name FROM suspect_list
)
AND statements LIKE '%cash%';
