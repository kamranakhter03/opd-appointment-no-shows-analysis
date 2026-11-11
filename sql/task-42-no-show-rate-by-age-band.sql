-- Task 42: No-show rate by age band
-- Requirement: FR-03
--
-- Join to `patients` and return `age_band` ('0-14', '15-30', '31-45', '46-59', '60+') and `noshow_pct` (rounded to 2). Leave out patients with no age.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        patient_id,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
),
patient_ages AS (
    SELECT
        patient_id,
        TRY_CAST(age AS INTEGER) AS age
    FROM patients
),
age_data AS (
    SELECT
        CASE
            WHEN p.age BETWEEN 0 AND 14 THEN '0-14'
            WHEN p.age BETWEEN 15 AND 30 THEN '15-30'
            WHEN p.age BETWEEN 31 AND 45 THEN '31-45'
            WHEN p.age BETWEEN 46 AND 59 THEN '46-59'
            WHEN p.age >= 60 THEN '60+'
        END AS age_band,
        a.status_clean
    FROM cleaned a
    JOIN patient_ages p
        ON a.patient_id = p.patient_id
    WHERE p.age IS NOT NULL
)
SELECT
    age_band,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM age_data
WHERE age_band IS NOT NULL
GROUP BY age_band;
