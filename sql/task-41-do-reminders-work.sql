-- Task 41: Do reminders work?
-- Requirement: FR-04
--
-- For Q2 appointments booked at least 1 day ahead, return `reminder` ('Delivered' or 'Not delivered') and `noshow_pct` (rounded to 2).

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
eligible_appointments AS (
    SELECT
        appointment_id,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
    WHERE CAST(appointment_date AS DATE)
              BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
      AND CAST(booking_date AS DATE)
              <= CAST(appointment_date AS DATE) - INTERVAL '1 day'
),
reminder_delivery AS (
    SELECT
        appointment_id,
        BOOL_OR(LOWER(TRIM(delivery_status)) = 'delivered') AS was_delivered
    FROM sms_reminders
    GROUP BY appointment_id
),
classified AS (
    SELECT
        CASE
            WHEN COALESCE(r.was_delivered, FALSE)
                THEN 'Delivered'
            ELSE 'Not delivered'
        END AS reminder,
        a.status_clean
    FROM eligible_appointments a
    LEFT JOIN reminder_delivery r
        ON a.appointment_id = r.appointment_id
)
SELECT
    reminder,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM classified
GROUP BY reminder;
