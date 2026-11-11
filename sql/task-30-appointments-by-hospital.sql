-- Task 30: Appointments by hospital
-- Requirement: FR-01
--
-- Return `hospital_name` and `appointments` for de-duplicated appointments.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
)
SELECT
    h.hospital_name,
    COUNT(*) AS appointments
FROM deduplicated a
JOIN doctors d
    ON a.doctor_id = d.doctor_id
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
GROUP BY h.hospital_name;
