-- Maji Ndogo Water Services | SQL Part 2
-- Clustering data to unveil the water crisis

USE md_water_services;


-- ============================================================
-- 1. CLEAN EMPLOYEE DATA
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

-- Create employee email addresses
UPDATE employee
SET email = CONCAT(
    LOWER(REPLACE(employee_name, ' ', '.')),
    '@ndogowater.gov'
);

-- Remove extra spaces from phone numbers
UPDATE employee
SET phone_number = TRIM(phone_number);


-- ============================================================
-- 2. ANALYSE EMPLOYEES
-- ============================================================

-- Employees per town
SELECT
    town_name,
    COUNT(*) AS num_employees
FROM employee
GROUP BY town_name
ORDER BY num_employees DESC;

-- Top 3 field surveyors by number of visits
SELECT
    assigned_employee_id,
    COUNT(*) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;

-- Get details of the top 3 surveyors
SELECT
    e.assigned_employee_id,
    e.employee_name,
    e.email,
    e.phone_number,
    v.number_of_visits
FROM employee e
JOIN (
    SELECT
        assigned_employee_id,
        COUNT(*) AS number_of_visits
    FROM visits
    GROUP BY assigned_employee_id
    ORDER BY number_of_visits DESC
    LIMIT 3
) v
ON e.assigned_employee_id = v.assigned_employee_id
ORDER BY v.number_of_visits DESC;


-- ============================================================
-- 3. ANALYSE LOCATIONS
-- ============================================================

-- Sources per town
SELECT
    town_name,
    COUNT(*) AS records_per_town
FROM location
GROUP BY town_name
ORDER BY records_per_town DESC;

-- Sources per province
SELECT
    province_name,
    COUNT(*) AS records_per_province
FROM location
GROUP BY province_name
ORDER BY records_per_province DESC;

-- Urban vs rural sources
SELECT
    location_type,
    COUNT(*) AS num_sources
FROM location
GROUP BY location_type;

-- Percentage of rural sources
SELECT
    ROUND(
        SUM(location_type = 'Rural') / COUNT(*) * 100,
        0
    ) AS pct_rural_sources
FROM location;


-- ============================================================
-- 4. ANALYSE WATER SOURCES
-- ============================================================

-- Total population surveyed
SELECT
    SUM(number_of_people_served) AS total_people_surveyed
FROM water_source;

-- Number of sources by type
SELECT
    type_of_water_source,
    COUNT(*) AS number_of_sources
FROM water_source
GROUP BY type_of_water_source
ORDER BY number_of_sources DESC;

-- Average people served per source type
SELECT
    type_of_water_source,
    ROUND(AVG(number_of_people_served)) AS avg_people_per_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY avg_people_per_source DESC;

-- Population served by each source type
SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS population_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY population_served DESC;

-- Percentage of population using each source type
SELECT
    type_of_water_source,
    ROUND(
        SUM(number_of_people_served) /
        (SELECT SUM(number_of_people_served) FROM water_source) * 100,
        0
    ) AS percentage_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY percentage_people DESC;


-- ============================================================
-- 5. PRIORITISE WATER SOURCES
-- ============================================================

-- Rank source types by population served
SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS people_served,
    RANK() OVER (
        ORDER BY SUM(number_of_people_served) DESC
    ) AS rank_by_population
FROM water_source
WHERE type_of_water_source != 'tap_in_home'
GROUP BY type_of_water_source;

-- Rank individual sources within each source type
SELECT
    source_id,
    type_of_water_source,
    number_of_people_served,
    RANK() OVER (
        PARTITION BY type_of_water_source
        ORDER BY number_of_people_served DESC
    ) AS priority_rank
FROM water_source
WHERE type_of_water_source != 'tap_in_home'
ORDER BY type_of_water_source, priority_rank;


-- ============================================================
-- 6. ANALYSE QUEUES
-- ============================================================

-- Survey period
SELECT
    MIN(time_of_record) AS survey_start,
    MAX(time_of_record) AS survey_end,
    DATEDIFF(
        MAX(time_of_record),
        MIN(time_of_record)
    ) AS days_survey_took
FROM visits;

-- Average queue time
SELECT
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS avg_queue_time
FROM visits;

-- Average queue time by day
SELECT
    DAYNAME(time_of_record) AS day_of_week,
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS avg_queue_time
FROM visits
GROUP BY day_of_week
ORDER BY FIELD(
    day_of_week,
    'Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday'
);

-- Average queue time by hour
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS avg_queue_time
FROM visits
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Queue times by hour and day
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Sunday'
        THEN time_in_queue END)) AS Sunday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Monday'
        THEN time_in_queue END)) AS Monday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Tuesday'
        THEN time_in_queue END)) AS Tuesday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Wednesday'
        THEN time_in_queue END)) AS Wednesday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Thursday'
        THEN time_in_queue END)) AS Thursday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Friday'
        THEN time_in_queue END)) AS Friday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Saturday'
        THEN time_in_queue END)) AS Saturday
FROM visits
WHERE time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;

SET SQL_SAFE_UPDATES = 1;