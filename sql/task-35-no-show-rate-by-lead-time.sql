-- Task 35: No-show rate by lead time
-- Requirement: FR-03
--
-- Group appointments by lead time band — '0-1', '2-7', '8-14', '15+' days (leave out negative lead times) — and return `lead_band`, `appointments` and `noshow_pct` (rounded to 2).

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        CAST(appointment_date AS DATE) AS appointment_date,
        CAST(booking_date AS DATE) AS booking_date,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
),
lead_data AS (
    SELECT
        appointment_date - booking_date AS lead_days,
        status_clean
    FROM cleaned
    WHERE booking_date <= appointment_date
),
banded AS (
    SELECT
        CASE
            WHEN lead_days BETWEEN 0 AND 1 THEN '0-1'
            WHEN lead_days BETWEEN 2 AND 7 THEN '2-7'
            WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
            WHEN lead_days >= 15 THEN '15+'
        END AS lead_band,
        status_clean
    FROM lead_data
)
SELECT
    lead_band,
    COUNT(*) AS appointments,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM banded
WHERE lead_band IS NOT NULL
GROUP BY lead_band;
