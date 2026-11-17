SELECT
    COUNT(*) AS total_jobs,
    COUNT(salary_year_avg) AS annual_salary_available,
    COUNT(salary_hour_avg) AS hourly_salary_available,
    COUNT(
        CASE
            WHEN salary_year_avg IS NOT NULL
              OR salary_hour_avg IS NOT NULL
            THEN 1
        END
    ) AS jobs_with_salary,
    COUNT(
        CASE
            WHEN salary_year_avg IS NULL
             AND salary_hour_avg IS NULL
            THEN 1
        END
    ) AS jobs_without_salary
FROM job_postings_fact;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT job_id) AS unique_job_ids
FROM job_postings_fact;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT company_id) AS unique_company_ids
FROM company_dim;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT skill_id) AS unique_skill_ids
FROM skills_dim;

-- Job tanpa perusahaan yang cocok
SELECT COUNT(*) AS unmatched_company
FROM job_postings_fact j
LEFT JOIN company_dim c
    ON j.company_id = c.company_id
WHERE j.company_id IS NOT NULL
  AND c.company_id IS NULL;

-- Skill-job tanpa job yang cocok
SELECT COUNT(*) AS unmatched_job
FROM skills_job_dim sj
LEFT JOIN job_postings_fact j
    ON sj.job_id = j.job_id
WHERE j.job_id IS NULL;

-- Skill-job tanpa skill yang cocok
SELECT COUNT(*) AS unmatched_skill
FROM skills_job_dim sj
LEFT JOIN skills_dim s
    ON sj.skill_id = s.skill_id
WHERE s.skill_id IS NULL;

SELECT
    salary_rate,
    COUNT(*) AS total_jobs,
    COUNT(salary_year_avg) AS annual_salary,
    COUNT(salary_hour_avg) AS hourly_salary
FROM job_postings_fact
GROUP BY salary_rate
ORDER BY total_jobs DESC;