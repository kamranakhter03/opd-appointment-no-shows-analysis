-- Task 25: Overall no-show rate
-- Requirement: FR-02
--
-- Using the BRD rule (no-shows ÷ (completed + no-shows) × 100), what is the no-show rate (%) for the whole period? Round to 2.

WITH deduplicated AS (
    SELECT DISTINCT *
    FROM appointments
),
cleaned AS (
    SELECT
        LOWER(REGEXP_REPLACE(TRIM(status), '[[:space:]-]+', '', 'g')) AS status_clean
    FROM deduplicated
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
    ) AS no_show_rate
FROM cleaned;
