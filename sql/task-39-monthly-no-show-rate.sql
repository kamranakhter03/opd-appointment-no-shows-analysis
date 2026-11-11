-- Task 39: Monthly no-show rate
-- Requirement: FR-04
--
-- Return `month` ('YYYY-MM') and `noshow_pct` (rounded to 2) for every month, in month order.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        STRFTIME(CAST(appointment_date AS DATE), '%Y-%m') AS month,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
)
SELECT
    month,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM cleaned
GROUP BY month
ORDER BY month;
