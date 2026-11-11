-- Task 29: Appointments by weekday
-- Requirement: FR-04
--
-- Return `weekday` (full day name, e.g. 'Monday') and `appointments` for de-duplicated appointments.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
)
SELECT
    STRFTIME(CAST(appointment_date AS DATE), '%A') AS weekday,
    COUNT(*) AS appointments
FROM deduplicated
GROUP BY weekday;
