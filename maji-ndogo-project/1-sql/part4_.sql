-- =====================================================================
-- Maji Ndogo Water Services | SQL Part 4
-- Charting the course for Maji Ndogo's water future
-- =====================================================================
USE md_water_services;


-- 1. COMBINE DATA

DROP VIEW IF EXISTS combined_analysis_table;

CREATE VIEW combined_analysis_table AS
SELECT
    ws.type_of_water_source AS source_type,
    l.town_name,
    l.province_name,
    l.location_type,
    ws.number_of_people_served AS people_served,
    v.time_in_queue,
    wp.results
FROM visits v
LEFT JOIN well_pollution wp
    ON wp.source_id = v.source_id
JOIN location l
    ON l.location_id = v.location_id
JOIN water_source ws
    ON ws.source_id = v.source_id
WHERE v.visit_count = 1;


-- 2. WATER ACCESS BY PROVINCE

WITH province_totals AS (
    SELECT province_name, SUM(people_served) AS total_people
    FROM combined_analysis_table
    GROUP BY province_name
)
SELECT
    ct.province_name,
    ROUND(SUM(CASE WHEN source_type = 'river'
        THEN people_served ELSE 0 END) * 100.0 / pt.total_people, 0) AS river,
    ROUND(SUM(CASE WHEN source_type = 'shared_tap'
        THEN people_served ELSE 0 END) * 100.0 / pt.total_people, 0) AS shared_tap,
    ROUND(SUM(CASE WHEN source_type = 'tap_in_home'
        THEN people_served ELSE 0 END) * 100.0 / pt.total_people, 0) AS tap_in_home,
    ROUND(SUM(CASE WHEN source_type = 'tap_in_home_broken'
        THEN people_served ELSE 0 END) * 100.0 / pt.total_people, 0) AS tap_in_home_broken,
    ROUND(SUM(CASE WHEN source_type = 'well'
        THEN people_served ELSE 0 END) * 100.0 / pt.total_people, 0) AS well
FROM combined_analysis_table ct
JOIN province_totals pt
    ON ct.province_name = pt.province_name
GROUP BY ct.province_name
ORDER BY ct.province_name;


-- 3. WATER ACCESS BY TOWN

DROP TEMPORARY TABLE IF EXISTS town_aggregated_water_access;

CREATE TEMPORARY TABLE town_aggregated_water_access AS
WITH town_totals AS (
    SELECT
        province_name,
        town_name,
        SUM(people_served) AS total_people
    FROM combined_analysis_table
    GROUP BY province_name, town_name
)
SELECT
    ct.province_name,
    ct.town_name,
    ROUND(SUM(CASE WHEN source_type = 'river'
        THEN people_served ELSE 0 END) * 100.0 / tt.total_people, 0) AS river,
    ROUND(SUM(CASE WHEN source_type = 'shared_tap'
        THEN people_served ELSE 0 END) * 100.0 / tt.total_people, 0) AS shared_tap,
    ROUND(SUM(CASE WHEN source_type = 'tap_in_home'
        THEN people_served ELSE 0 END) * 100.0 / tt.total_people, 0) AS tap_in_home,
    ROUND(SUM(CASE WHEN source_type = 'tap_in_home_broken'
        THEN people_served ELSE 0 END) * 100.0 / tt.total_people, 0) AS tap_in_home_broken,
    ROUND(SUM(CASE WHEN source_type = 'well'
        THEN people_served ELSE 0 END) * 100.0 / tt.total_people, 0) AS well
FROM combined_analysis_table ct
JOIN town_totals tt
    ON ct.province_name = tt.province_name
    AND ct.town_name = tt.town_name
GROUP BY ct.province_name, ct.town_name;


-- Towns with the highest river-water use
SELECT *
FROM town_aggregated_water_access
ORDER BY river DESC;

-- Towns with the highest percentage of broken home taps
SELECT
    province_name,
    town_name,
    ROUND(
        tap_in_home_broken /
        (tap_in_home_broken + tap_in_home) * 100, 0
    ) AS Pct_broken_taps
FROM town_aggregated_water_access
ORDER BY Pct_broken_taps DESC;


-- 4. CREATE PROJECT PROGRESS TABLE

DROP TABLE IF EXISTS Project_progress;

CREATE TABLE Project_progress (
    Project_id SERIAL PRIMARY KEY,
    source_id VARCHAR(20) NOT NULL,
    Address VARCHAR(100),
    Town VARCHAR(30),
    Province VARCHAR(30),
    Source_type VARCHAR(50),
    Improvement VARCHAR(50),
    Source_status VARCHAR(50) DEFAULT 'Backlog'
        CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
    Date_of_completion DATE,
    Comments TEXT,
    FOREIGN KEY (source_id) REFERENCES water_source(source_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- 5. INSERT SOURCES THAT NEED IMPROVEMENTS

INSERT INTO Project_progress
    (source_id, Address, Town, Province, Source_type, Improvement)
SELECT
    ws.source_id,
    l.address,
    l.town_name,
    l.province_name,
    ws.type_of_water_source,
    CASE
        WHEN wp.results = 'Contaminated: Biological'
            THEN 'Install UV and RO filter'
        WHEN wp.results = 'Contaminated: Chemical'
            THEN 'Install RO filter'
        WHEN ws.type_of_water_source = 'river'
            THEN 'Drill well'
        WHEN ws.type_of_water_source = 'shared_tap'
             AND v.time_in_queue >= 30
            THEN CONCAT('Install ', FLOOR(v.time_in_queue / 30),
                        ' taps nearby')
        WHEN ws.type_of_water_source = 'tap_in_home_broken'
            THEN 'Diagnose local infrastructure'
    END AS Improvement
FROM water_source ws
LEFT JOIN well_pollution wp
    ON ws.source_id = wp.source_id
JOIN visits v
    ON ws.source_id = v.source_id
JOIN location l
    ON l.location_id = v.location_id
WHERE v.visit_count = 1
  AND (
      wp.results != 'Clean'
      OR ws.type_of_water_source IN ('tap_in_home_broken', 'river')
      OR (
          ws.type_of_water_source = 'shared_tap'
          AND v.time_in_queue >= 30
      )
  );


-- 6. VALIDATE RESULTS

SELECT COUNT(*) AS total_projects
FROM Project_progress; -- result: 25398

SELECT COUNT(*) AS rows_without_improvement
FROM Project_progress
WHERE Improvement IS NULL; -- result: 0

SELECT Improvement, COUNT(*) AS num_projects
FROM Project_progress
GROUP BY Improvement
ORDER BY num_projects DESC;