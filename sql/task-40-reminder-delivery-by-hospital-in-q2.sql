-- Task 40: Reminder delivery by hospital in Q2
-- Requirement: FR-04
--
-- For Q2 appointments booked at least 1 day ahead, return `hospital_name` and `delivered_pct` — the % of appointments with at least one 'Delivered' reminder (rounded to 2).

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
eligible_appointments AS (
    SELECT
        appointment_id,
        doctor_id
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
)
SELECT
    h.hospital_name,
    ROUND(
        COUNT(*) FILTER (WHERE COALESCE(r.was_delivered, FALSE)) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS delivered_pct
FROM eligible_appointments a
JOIN doctors d
    ON a.doctor_id = d.doctor_id
JOIN hospitals h
    ON d.hospital_id = h.hospital_id
LEFT JOIN reminder_delivery r
    ON a.appointment_id = r.appointment_id
GROUP BY h.hospital_name;
