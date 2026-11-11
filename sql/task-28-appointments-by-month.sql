-- Task 28: Appointments by month
-- Requirement: FR-04
--
-- Return `month` ('YYYY-MM' of the appointment date) and `appointments` for de-duplicated appointments, in month order.

WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
)
SELECT
    STRFTIME(CAST(appointment_date AS DATE), '%Y-%m') AS month,
    COUNT(*) AS appointments
FROM deduplicated
GROUP BY month
ORDER BY month;
