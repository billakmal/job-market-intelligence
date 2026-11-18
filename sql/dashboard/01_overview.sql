
-- 1. Total job postings and Data Analyst postings
CREATE OR REPLACE VIEW vw_dashboard_overview_kpi AS
SELECT
    COUNT(*) AS total_job_postings,
    COUNT(*) FILTER (
        WHERE job_title_short = 'Data Analyst'
    ) AS total_data_analyst_postings,
    COUNT(DISTINCT job_country) AS countries_count,
    COUNT(*) FILTER (
        WHERE job_work_from_home = TRUE
    ) AS remote_job_postings,
    MIN(job_posted_date::date) AS first_posting_date,
    MAX(job_posted_date::date) AS last_posting_date
FROM job_postings_fact;


-- 2. Job postings by job category
CREATE OR REPLACE VIEW vw_dashboard_job_category AS
SELECT
    job_title_short AS job_category,
    COUNT(*) AS total_postings
FROM job_postings_fact
WHERE job_title_short IS NOT NULL
GROUP BY job_title_short
ORDER BY total_postings DESC;


-- 3. Job postings by country
CREATE OR REPLACE VIEW vw_dashboard_country AS
SELECT
    job_country AS country,
    COUNT(*) AS total_postings
FROM job_postings_fact
WHERE job_country IS NOT NULL
GROUP BY job_country
ORDER BY total_postings DESC;


-- 4. Data Analyst employment type
CREATE OR REPLACE VIEW vw_dashboard_da_schedule AS
SELECT
    TRIM(job_schedule_type) AS employment_type,
    COUNT(*) AS total_postings
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND job_schedule_type IS NOT NULL
GROUP BY TRIM(job_schedule_type)
ORDER BY total_postings DESC;


-- 5. Data Analyst postings by month
CREATE OR REPLACE VIEW vw_dashboard_da_monthly AS
SELECT
    DATE_TRUNC('month', job_posted_date)::date AS posting_month,
    COUNT(*) AS total_postings
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND job_posted_date IS NOT NULL
GROUP BY DATE_TRUNC('month', job_posted_date)::date
ORDER BY posting_month;

