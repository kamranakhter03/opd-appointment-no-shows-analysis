-- Task 44: How far ahead people book
-- Requirement: FR-03
--
-- For Q2, return `booking_channel` and `avg_lead_days` (average lead time, rounded to 1), leaving out negative lead times.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        TRIM(booking_channel) AS booking_channel,
        CAST(appointment_date AS DATE) - CAST(booking_date AS DATE) AS lead_days,
        CAST(appointment_date AS DATE) AS appointment_date
    FROM deduplicated
)
SELECT
    booking_channel,
    ROUND(AVG(lead_days), 1) AS avg_lead_days
FROM cleaned
WHERE appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
  AND lead_days >= 0
GROUP BY booking_channel;
