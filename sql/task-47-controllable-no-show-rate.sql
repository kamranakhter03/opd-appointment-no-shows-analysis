-- Task 47: Controllable no-show rate
-- Requirement: FR-06
--
-- What is the Q2 no-show rate (%) for appointments booked 1 to 14 days ahead that had a delivered reminder? Round to 2.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
reminder_delivery AS (
    SELECT
        appointment_id,
        BOOL_OR(LOWER(TRIM(delivery_status)) = 'delivered') AS was_delivered
    FROM sms_reminders
    GROUP BY appointment_id
),
eligible_appointments AS (
    SELECT
        a.appointment_id,
        LOWER(
            REGEXP_REPLACE(TRIM(a.status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated a
    LEFT JOIN reminder_delivery r
        ON a.appointment_id = r.appointment_id
    WHERE CAST(a.appointment_date AS DATE)
              BETWEEN DATE '2026-07-01' AND DATE '2026-09-30'
      AND CAST(a.appointment_date AS DATE)
              - CAST(a.booking_date AS DATE) BETWEEN 1 AND 14
      AND COALESCE(r.was_delivered, FALSE) = TRUE
)
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS controllable_noshow_pct
FROM eligible_appointments;
