-- Task 33: Q2 no-show rate by hospital
-- Requirement: FR-03
--
-- For Q2, return `hospital_name` and `noshow_pct` (rounded to 2) for each hospital.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        doctor_id,
        CAST(appointment_date AS DATE) AS appointment_date,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
),
hospital_data AS (
    SELECT
        h.hospital_name,
        c.status_clean
    FROM cleaned c
    JOIN doctors d
        ON c.doctor_id = d.doctor_id
    JOIN hospitals h
        ON d.hospital_id = h.hospital_id
    WHERE c.appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
)
SELECT
    hospital_name,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM hospital_data
GROUP BY hospital_name;
