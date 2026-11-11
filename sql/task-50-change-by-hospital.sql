-- Task 50: Change by hospital
-- Requirement: FR-02
--
-- Return `hospital_name`, `q1_pct`, `q2_pct` (no-show rates, rounded to 2) and `change_pp` (q2 − q1 in percentage points, rounded to 2), biggest increase first.

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
hospital_rates AS (
    SELECT
        h.hospital_name,

        COUNT(*) FILTER (
            WHERE c.appointment_date BETWEEN DATE '2026-04-01' AND DATE '2026-06-30'
              AND c.status_clean = 'noshow'
        ) AS q1_noshow,

        COUNT(*) FILTER (
            WHERE c.appointment_date BETWEEN DATE '2026-04-01' AND DATE '2026-06-30'
              AND c.status_clean IN ('completed', 'noshow')
        ) AS q1_eligible,

        COUNT(*) FILTER (
            WHERE c.appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
              AND c.status_clean = 'noshow'
        ) AS q2_noshow,

        COUNT(*) FILTER (
            WHERE c.appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
              AND c.status_clean IN ('completed', 'noshow')
        ) AS q2_eligible

    FROM cleaned c
    JOIN doctors d
        ON c.doctor_id = d.doctor_id
    JOIN hospitals h
        ON d.hospital_id = h.hospital_id
    GROUP BY h.hospital_name
),
rates AS (
    SELECT
        hospital_name,
        ROUND(q1_noshow * 100.0 / NULLIF(q1_eligible, 0), 2) AS q1_pct,
        ROUND(q2_noshow * 100.0 / NULLIF(q2_eligible, 0), 2) AS q2_pct
    FROM hospital_rates
)
SELECT
    hospital_name,
    q1_pct,
    q2_pct,
    ROUND(q2_pct - q1_pct, 2) AS change_pp
FROM rates
ORDER BY change_pp DESC;
