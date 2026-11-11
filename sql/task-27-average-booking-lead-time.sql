-- Task 27: Average booking lead time
-- Requirement: FR-03
--
-- What is the average lead time (appointment_date − booking_date, in days) of de-duplicated appointments? Leave out rows where booking_date is after appointment_date. Round to 2.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
)
SELECT
    ROUND(
        AVG(appointment_date::DATE - booking_date::DATE),
        2
    ) AS avg_lead_time_days
FROM deduplicated
WHERE booking_date::DATE <= appointment_date::DATE;
