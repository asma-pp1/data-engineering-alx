-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
SELECT
    YEAR(START) AS year,
    QUARTER(START) AS quarter,
    COUNT(DISTINCT PATIENT) AS unique_patients_admitted
FROM encounters
WHERE ENCOUNTERCLASS = 'inpatient'
GROUP BY
    YEAR(START),
    QUARTER(START)
ORDER BY
    year,
    quarter;

-- b. How many patients were readmitted within 30 days of a previous encounter?
WITH patient_encounters AS (
    SELECT
        PATIENT,
        START,
        STOP,
        ENCOUNTERCLASS,
        LAG(STOP) OVER (
            PARTITION BY PATIENT
            ORDER BY START
        ) AS previous_stop
    FROM encounters
)

SELECT
    COUNT(DISTINCT PATIENT) AS patients_readmitted_within_30_days
FROM patient_encounters
WHERE
    previous_stop IS NOT NULL
    AND TIMESTAMPDIFF(DAY, previous_stop, START) BETWEEN 0 AND 30
    AND ENCOUNTERCLASS = 'inpatient';

-- c. Which patients had the most readmissions?
WITH patient_encounters AS (
    SELECT
        PATIENT,
        START,
        STOP,
        ENCOUNTERCLASS,
        LAG(STOP) OVER (
            PARTITION BY PATIENT
            ORDER BY START
        ) AS previous_stop
    FROM encounters
),

readmissions AS (
    SELECT
        PATIENT,
        START,
        previous_stop
    FROM patient_encounters
    WHERE
        previous_stop IS NOT NULL
        AND TIMESTAMPDIFF(DAY, previous_stop, START) BETWEEN 0 AND 30
        AND ENCOUNTERCLASS = 'inpatient'
)

SELECT
    r.PATIENT,
    CONCAT(p.FIRST, ' ', p.LAST) AS patient_name,
    COUNT(*) AS readmission_count
FROM readmissions r
JOIN patients p
    ON r.PATIENT = p.Id
GROUP BY
    r.PATIENT,
    p.FIRST,
    p.LAST
ORDER BY
    readmission_count DESC;