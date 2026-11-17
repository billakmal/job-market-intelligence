SELECT
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_year_avg)::numeric, 2) AS avg_salary,
    ROUND(PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2) AS median_salary,
    ROUND(PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2) AS q3,
    ROUND(STDDEV(salary_year_avg)::numeric, 2) AS std_deviation
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
--   AND job_title_short = 'Data Analyst';

SELECT
    job_title_short,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_year_avg)::numeric, 2) AS avg_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2
    ) AS median_salary,
    ROUND(
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2
    ) AS q1,
    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric, 2
    ) AS q3
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
HAVING COUNT(*) >= 100
ORDER BY median_salary DESC;

SELECT
    job_title_short,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_hour_avg)::numeric, 2) AS avg_hourly_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_hour_avg)::numeric, 2
    ) AS median_hourly_salary,
    ROUND(
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY salary_hour_avg)::numeric, 2
    ) AS q1,
    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY salary_hour_avg)::numeric, 2
    ) AS q3
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
GROUP BY job_title_short
HAVING COUNT(*) >= 100
ORDER BY median_hourly_salary DESC;

SELECT
    job_title_short,
    COUNT(*) AS total_jobs,
    MAX(salary_year_avg) AS max_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric,
        2
    ) AS median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
ORDER BY max_salary DESC;

WITH salary_stats AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY salary_year_avg) AS q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY salary_year_avg) AS q3
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
),
outlier_bounds AS (
    SELECT
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM salary_stats
)
SELECT
    j.job_id,
    j.job_title,
    j.job_location,
    j.job_country,
    c.name AS company_name,
    j.salary_year_avg
FROM job_postings_fact j
LEFT JOIN company_dim c
    ON j.company_id = c.company_id
CROSS JOIN outlier_bounds b
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
  AND (
      j.salary_year_avg < b.lower_bound
      OR j.salary_year_avg > b.upper_bound
  )
ORDER BY j.salary_year_avg DESC
LIMIT 20;

WITH salary_stats AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY salary_year_avg) AS q1,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY salary_year_avg) AS q3
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
),
salary_bounds AS (
    SELECT
        q1,
        q3,
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM salary_stats
),
classified_salary AS (
    SELECT
        j.salary_year_avg,
        CASE
            WHEN j.salary_year_avg < b.lower_bound
              OR j.salary_year_avg > b.upper_bound
            THEN 'Outlier'
            ELSE 'Non-Outlier'
        END AS salary_group
    FROM job_postings_fact j
    CROSS JOIN salary_bounds b
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
)
SELECT
    salary_group,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_year_avg)::numeric, 2) AS avg_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric,
        2
    ) AS median_salary,
    ROUND(MIN(salary_year_avg)::numeric, 2) AS min_salary,
    ROUND(MAX(salary_year_avg)::numeric, 2) AS max_salary
FROM classified_salary
GROUP BY salary_group
ORDER BY salary_group;