USE hospital_db;

-- 1. Number of patients
SELECT COUNT(*) AS total_patients
FROM patients;


-- 2. Number of encounters
SELECT COUNT(*) AS total_encounters
FROM encounters;


-- 3. Number of procedures
SELECT COUNT(*) AS total_procedures
FROM procedures;


-- 4. Date range
SELECT
    MIN(START) AS first_encounter,
    MAX(START) AS last_encounter
FROM encounters;


-- 5. Encounter types
SELECT
    ENCOUNTERCLASS,
    COUNT(*) AS number_of_encounters
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY number_of_encounters DESC;


-- 6. Patients by gender
SELECT
    GENDER,
    COUNT(*) AS patients
FROM patients
GROUP BY GENDER;


-- 7. Patients by race
SELECT
    RACE,
    COUNT(*) AS patients
FROM patients
GROUP BY RACE;


-- 8. Patients by ethnicity
SELECT
    ETHNICITY,
    COUNT(*) AS patients
FROM patients
GROUP BY ETHNICITY;


-- 9. Insurance providers
SELECT
    p.NAME AS insurance_provider,
    COUNT(*) AS encounters
FROM encounters e
JOIN payers p
    ON e.PAYER = p.Id
GROUP BY p.NAME
ORDER BY encounters DESC;