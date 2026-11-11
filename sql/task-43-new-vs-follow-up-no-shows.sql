-- Task 43: New vs follow-up no-shows
-- Requirement: FR-03
--
-- Return `visit_type` and `noshow_pct` (rounded to 2) for the whole period.

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        TRIM(visit_type) AS visit_type,
        LOWER(
            REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')
        ) AS status_clean
    FROM deduplicated
)
SELECT
    visit_type,
    ROUND(
        COUNT(*) FILTER (WHERE status_clean = 'noshow') * 100.0 /
        NULLIF(
            COUNT(*) FILTER (
                WHERE status_clean IN ('completed', 'noshow')
            ), 0
        ),
        2
    ) AS noshow_pct
FROM cleaned
GROUP BY visit_type;
