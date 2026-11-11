-- Task 49: Worst department in each hospital
-- Requirement: FR-03
--
-- For Q2, find the department with the highest no-show rate in each hospital (departments with at least 100 completed + no-show appointments): `hospital_name`, `department`, `noshow_pct` (rounded to 2).

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
        ) AS status_clean,
        CAST(appointment_date AS DATE) AS appointment_date
    FROM deduplicated
),
department_rates AS (
    SELECT
        h.hospital_name,
        d.department,
        COUNT(*) FILTER (
            WHERE c.status_clean = 'noshow'
        ) AS no_shows,
        COUNT(*) FILTER (
            WHERE c.status_clean IN ('completed', 'noshow')
        ) AS eligible_appointments
    FROM cleaned c
    JOIN doctors d
        ON c.doctor_id = d.doctor_id
    JOIN hospitals h
        ON d.hospital_id = h.hospital_id
    WHERE c.appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
    GROUP BY h.hospital_name, d.department
    HAVING COUNT(*) FILTER (
        WHERE c.status_clean IN ('completed', 'noshow')
    ) >= 100
),
ranked AS (
    SELECT
        hospital_name,
        department,
        ROUND(no_shows * 100.0 / eligible_appointments, 2) AS noshow_pct,
        ROW_NUMBER() OVER (
            PARTITION BY hospital_name
            ORDER BY no_shows * 100.0 / eligible_appointments DESC
        ) AS department_rank
    FROM department_rates
)
SELECT
    hospital_name,
    department,
    noshow_pct
FROM ranked
WHERE department_rank = 1;
