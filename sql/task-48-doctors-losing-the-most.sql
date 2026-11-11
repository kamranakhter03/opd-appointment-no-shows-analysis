-- Task 48: Doctors losing the most
-- Requirement: FR-05
--
-- Return the top 5 doctors by Q2 lost revenue: `doctor_id`, `department`, `hospital_name`, `lost_revenue`, highest first.

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
        ) AS status_clean,
        TRY_CAST(
            REGEXP_REPLACE(TRIM(fee), '[^0-9.]', '', 'g')
            AS DECIMAL(12, 2)
        ) AS fee_clean
    FROM deduplicated
),
doctor_revenue AS (
    SELECT
        doctor_id,
        SUM(fee_clean) AS lost_revenue
    FROM cleaned
    WHERE appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
      AND status_clean = 'noshow'
    GROUP BY doctor_id
)
SELECT
    dr.doctor_id,
    d.department,
    h.hospital_name,
    ROUND(dr.lost_revenue, 2) AS lost_revenue
FROM doctor_revenue dr
JOIN doctors d
    ON dr.doctor_id = d.doctor_id
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
ORDER BY lost_revenue DESC
LIMIT 5;
