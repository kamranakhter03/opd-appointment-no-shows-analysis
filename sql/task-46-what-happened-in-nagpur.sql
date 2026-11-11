-- Task 46: What happened in Nagpur
-- Requirement: FR-04
--
-- For the Nagpur hospital, return `month`, `delivered_pct` (% of appointments booked 1+ days ahead that had a delivered reminder, rounded to 1) and `noshow_pct` (rounded to 1) for every month, in month order.

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
appointment_data AS (
    SELECT
        a.appointment_id,
        STRFTIME(CAST(a.appointment_date AS DATE), '%Y-%m') AS month,
        CAST(a.booking_date AS DATE)
            <= CAST(a.appointment_date AS DATE) - INTERVAL '1 day'
            AS eligible_for_reminder,
        LOWER(
            REGEXP_REPLACE(TRIM(a.status), '[[:space:]-]+', '', 'g')
        ) AS status_clean,
        COALESCE(r.was_delivered, FALSE) AS was_delivered
    FROM deduplicated a
    JOIN doctors d
        ON a.doctor_id = d.doctor_id
    JOIN hospitals h
        ON d.hospital_id = h.hospital_id
    LEFT JOIN reminder_delivery r
        ON a.appointment_id = r.appointment_id
    WHERE LOWER(TRIM(h.city)) = 'nagpur'
)
SELECT
    month,
    ROUND(
        COUNT(*) FILTER (
            WHERE eligible_for_reminder AND was_delivered
        ) * 100.0 /
        NULLIF(
            COUNT(*) FILTER (WHERE eligible_for_reminder), 0
        ),
        1
    ) AS delivered_pct,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        1
    ) AS noshow_pct
FROM appointment_data
GROUP BY month
ORDER BY month;
