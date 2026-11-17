SELECT
    job_country,
    COUNT(*) AS total_jobs,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM job_postings_fact
WHERE job_country IS NOT NULL
-- AND job_title_short = 'Data Analyst'
GROUP BY job_country
ORDER BY total_jobs DESC
LIMIT 20;

SELECT
    COALESCE(job_schedule_type, 'Unknown') AS schedule_type,
    COUNT(*) AS total_jobs,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_schedule_type
ORDER BY total_jobs DESC;

WITH normalized_schedule AS (
    SELECT
        COALESCE(job_title_short, 'Unknown') AS job_category,
        job_id,
        REGEXP_REPLACE(
            job_schedule_type,
            '(,\s*and\s+|\s+and\s+|,)',
            ',',
            'gi'
        ) AS schedule_type
    FROM job_postings_fact
    WHERE job_schedule_type IS NOT NULL
    -- AND job_title_short = 'Data Analyst'
),

schedule_expanded AS (
    SELECT
        job_category,
        job_id,
        TRIM(schedule) AS schedule_type
    FROM normalized_schedule
    CROSS JOIN LATERAL
        UNNEST(STRING_TO_ARRAY(schedule_type, ',')) AS schedule
),

category_totals AS (
    SELECT
        job_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM normalized_schedule
    GROUP BY job_category
),

schedule_counts AS (
    SELECT
        job_category,
        schedule_type,
        COUNT(DISTINCT job_id) AS total_schedule_jobs
    FROM schedule_expanded
    WHERE schedule_type <> ''
    GROUP BY job_category, schedule_type
)


-- SELECT
--     number_of_schedules,
--     COUNT(*) AS total_jobs
-- FROM schedule_count
-- GROUP BY number_of_schedules
-- ORDER BY number_of_schedules

SELECT
    sc.job_category,
    sc.schedule_type,
    sc.total_schedule_jobs,
    ct.total_jobs,
    ROUND(
        100.0 * sc.total_schedule_jobs / ct.total_jobs,
        2
    ) AS percentage
FROM schedule_counts sc
JOIN category_totals ct
    ON sc.job_category = ct.job_category
ORDER BY
    sc.job_category,
    sc.total_schedule_jobs DESC;

SELECT
    -- job_title_short,
    job_location,
    COUNT(*) AS total_jobs
FROM job_postings_fact
WHERE job_country = 'Sudan'
-- GROUP BY job_title_short
GROUP BY job_location
ORDER BY total_jobs DESC;