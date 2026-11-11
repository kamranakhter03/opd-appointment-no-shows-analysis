-- Task 37: Q2 no-show rate by channel
-- Requirement: FR-03
--
-- For Q2, return `booking_channel`, `appointments` and `noshow_pct` (rounded to 2).

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        TRIM(booking_channel) AS booking_channel,
        CAST(appointment_date AS DATE) AS appointment_date,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
)
SELECT
    booking_channel,
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
FROM cleaned
WHERE appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
GROUP BY booking_channel;
