-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. Total encounters each year
SELECT
    YEAR(START) AS year,
    COUNT(*) AS total_encounters
FROM encounters
GROUP BY YEAR(START)
ORDER BY year;

-- b. Percentage of encounters by encounter class, each year
SELECT
    YEAR(START) AS year,
    ENCOUNTERCLASS AS encounter_class,
    COUNT(*) AS total_encounters,
    ROUND(
        100 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY YEAR(START)),
        2
    ) AS percentage_of_year
FROM encounters
GROUP BY
    YEAR(START),
    ENCOUNTERCLASS
ORDER BY
    year,
    percentage_of_year DESC;

-- c. Encounters over vs. under 24 hours
SELECT
    CASE
        WHEN TIMESTAMPDIFF(HOUR, START, STOP) >= 24
            THEN '24 hours or more'
        ELSE 'Under 24 hours'
    END AS encounter_duration,
    COUNT(*) AS total_encounters,
    ROUND(
        100 * COUNT(*) / (SELECT COUNT(*) FROM encounters),
        2
    ) AS percentage
FROM encounters
GROUP BY
    CASE
        WHEN TIMESTAMPDIFF(HOUR, START, STOP) >= 24
            THEN '24 hours or more'
        ELSE 'Under 24 hours'
    END;