-- Task 34: No-show rate by department
-- Requirement: FR-03
--
-- For the whole period, return `department` and `noshow_pct` (rounded to 2), highest first.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        doctor_id,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
)
SELECT
    d.department,
    ROUND(
        COUNT(*) FILTER (WHERE c.status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE c.status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM cleaned c
JOIN doctors d
    ON c.doctor_id = d.doctor_id
GROUP BY d.department
ORDER BY noshow_pct DESC;
