-- Task 45: Repeat no-show patients
-- Requirement: FR-05
--
-- How many patients missed 3 or more appointments (standard status 'noshow') over the whole period?

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
patient_no_shows AS (
    SELECT
        patient_id,
        COUNT(*) AS no_show_count
    FROM cleaned
    WHERE status_clean = 'noshow'
    GROUP BY patient_id
)
SELECT
    COUNT(*) AS repeat_no_show_patients
FROM patient_no_shows
WHERE no_show_count >= 3;
