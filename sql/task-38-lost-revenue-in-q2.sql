-- Task 38: Lost revenue in Q2
-- Requirement: FR-05
--
-- What consultation revenue (₹) was lost to no-shows in Q2 — the cleaned `fee` of every Q2 no-show?

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        CAST(appointment_date AS DATE) AS appointment_date,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean,
        CAST(
            REGEXP_REPLACE(TRIM(fee), '[^0-9.]', '', 'g')
            AS DECIMAL(12, 2)
        ) AS fee_clean
    FROM deduplicated
)
SELECT
    ROUND(SUM(fee_clean), 2) AS lost_revenue_q2
FROM cleaned
WHERE appointment_date BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
  AND status_clean = 'noshow';
