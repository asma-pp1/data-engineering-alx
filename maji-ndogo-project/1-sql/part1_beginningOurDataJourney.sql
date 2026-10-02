-- Maji Ndogo Water Services | SQL Part 1
-- Beginning our data-driven journey
-- Database: md_water_services

USE md_water_services;


-- ============================================================
-- 1. GET TO KNOW THE DATA
-- ============================================================

SHOW TABLES;

SELECT * FROM data_dictionary LIMIT 5;
SELECT * FROM employee LIMIT 5;
SELECT * FROM global_water_access LIMIT 5;
SELECT * FROM location LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM water_quality LIMIT 5;
SELECT * FROM water_source LIMIT 5;
SELECT * FROM well_pollution LIMIT 5;

SELECT * FROM data_dictionary;


-- ============================================================
-- 2. EXPLORE WATER SOURCES
-- ============================================================

SELECT DISTINCT
    type_of_water_source
FROM water_source;


-- ============================================================
-- 3. INVESTIGATE LONG QUEUES
-- ============================================================

SELECT *
FROM visits
WHERE time_in_queue > 500;

-- Long queues are associated with shared taps.
SELECT *
FROM water_source
WHERE source_id IN (
    'AkKi00881224',
    'SoRu37635224',
    'SoRu36096224',
    'AkRu05234224',
    'HaZa21742224'
);


-- ============================================================
-- 4. CHECK WATER QUALITY DATA
-- ============================================================

-- Identify suspicious repeat visits with a perfect quality score.
SELECT *
FROM water_quality
WHERE subjective_quality_score = 10
  AND visit_count = 2;


-- ============================================================
-- 5. INVESTIGATE AND CLEAN POLLUTION DATA
-- ============================================================

-- Identify incorrect pollution results.
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;

-- Identify incorrect descriptions.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%';


-- Create a copy before making changes.
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE well_pollution_copy AS
SELECT *
FROM well_pollution;


-- Apply corrections to the copy.
UPDATE well_pollution_copy
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution_copy
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

UPDATE well_pollution_copy
SET results = 'Contaminated: Biological'
WHERE biological > 0.01
  AND results = 'Clean';


-- Validate the corrections.
SELECT *
FROM well_pollution_copy
WHERE description LIKE 'Clean_%'
   OR (results = 'Clean' AND biological > 0.01);


-- Apply the verified corrections to the real table.
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01
  AND results = 'Clean';


-- Final validation.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%'
   OR (results = 'Clean' AND biological > 0.01);

-- Delete the copy
DROP TABLE well_pollution_copy;

SET SQL_SAFE_UPDATES = 1;