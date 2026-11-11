-- Task 31: No-show rate in Q1
-- Requirement: FR-02
--
-- What was the no-show rate (%) in Q1 (April–June 2026)? Round to 2.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        CAST(appointment_date AS DATE) AS appointment_date,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
)
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS q1_no_show_rate
FROM cleaned
WHERE appointment_date BETWEEN DATE '2026-04-01' AND DATE '2026-06-30';
