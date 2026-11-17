WITH da_postings AS (
    SELECT job_id
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
),
da_skill_coverage AS (
    SELECT COUNT(DISTINCT d.job_id) AS jobs_with_skills
    FROM da_postings d
    JOIN skills_job_dim sj
        ON d.job_id = sj.job_id
),
skill_demand AS (
    SELECT
        s.skill_id,
        s.skills AS skill_name,
        COUNT(DISTINCT sj.job_id) AS total_jobs
    FROM da_postings d
    JOIN skills_job_dim sj
        ON d.job_id = sj.job_id
    JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    GROUP BY s.skill_id, s.skills
)
SELECT
    sd.skill_name,
    sd.total_jobs,
    ROUND(
        100.0 * sd.total_jobs /
        (SELECT COUNT(*) FROM da_postings),
        2
    ) AS percentage_all_postings,
    ROUND(
        100.0 * sd.total_jobs /
        (SELECT jobs_with_skills FROM da_skill_coverage),
        2
    ) AS percentage_postings_with_skills
FROM skill_demand sd
ORDER BY sd.total_jobs DESC;

WITH category_jobs AS (
    SELECT
        job_title_short,
        COUNT(DISTINCT job_id) AS total_postings
    FROM job_postings_fact
    WHERE job_title_short IN (
        'Data Analyst',
        'Business Analyst',
        'Data Engineer',
        'Data Scientist'
    )
    GROUP BY job_title_short
),
category_jobs_with_skills AS (
    SELECT
        j.job_title_short,
        COUNT(DISTINCT j.job_id) AS postings_with_skills
    FROM job_postings_fact j
    JOIN skills_job_dim sj
        ON j.job_id = sj.job_id
    WHERE j.job_title_short IN (
        'Data Analyst',
        'Business Analyst',
        'Data Engineer',
        'Data Scientist'
    )
    GROUP BY j.job_title_short
),
skill_demand AS (
    SELECT
        j.job_title_short,
        s.skills AS skill_name,
        COUNT(DISTINCT j.job_id) AS total_jobs
    FROM job_postings_fact j
    JOIN skills_job_dim sj
        ON j.job_id = sj.job_id
    JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short IN (
        'Data Analyst',
        'Business Analyst',
        'Data Engineer',
        'Data Scientist'
    )
    GROUP BY
        j.job_title_short,
        s.skills
),
ranked_skills AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY total_jobs DESC
        ) AS skill_rank
    FROM skill_demand
)
SELECT
    r.job_title_short,
    r.skill_name,
    r.total_jobs,
    ROUND(
        100.0 * r.total_jobs / cj.total_postings,
        2
    ) AS percentage_all_postings,
    ROUND(
        100.0 * r.total_jobs / cws.postings_with_skills,
        2
    ) AS percentage_postings_with_skills
FROM ranked_skills r
JOIN category_jobs cj
    ON r.job_title_short = cj.job_title_short
JOIN category_jobs_with_skills cws
    ON r.job_title_short = cws.job_title_short
WHERE r.skill_rank <= 15
ORDER BY
    r.job_title_short,
    r.skill_rank;

SELECT
    s.skills AS skill_name,
    COUNT(DISTINCT j.job_id) AS total_jobs,
    ROUND(
        AVG(j.salary_year_avg)::numeric,
        2
    ) AS avg_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY j.salary_year_avg
        )::numeric,
        2
    ) AS median_salary
FROM job_postings_fact j
JOIN skills_job_dim sj
    ON j.job_id = sj.job_id
JOIN skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
GROUP BY s.skill_id, s.skills
HAVING COUNT(DISTINCT j.job_id) >= 100
ORDER BY median_salary DESC
LIMIT 20;

WITH da_salary AS (
    SELECT
        job_id,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
),
da_skills AS (
    SELECT DISTINCT
        job_id,
        skill_id
    FROM skills_job_dim
),
skill_comparison AS (
    SELECT
        s.skill_id,
        s.skills AS skill_name,

        COUNT(*) FILTER (
            WHERE dsj.job_id IS NOT NULL
        ) AS jobs_with_skill,

        COUNT(*) FILTER (
            WHERE dsj.job_id IS NULL
        ) AS jobs_without_skill,

        ROUND(
            PERCENTILE_CONT(0.5)
                WITHIN GROUP (ORDER BY d.salary_year_avg)
                FILTER (WHERE dsj.job_id IS NOT NULL)::numeric,
            2
        ) AS median_with_skill,

        ROUND(
            PERCENTILE_CONT(0.5)
                WITHIN GROUP (ORDER BY d.salary_year_avg)
                FILTER (WHERE dsj.job_id IS NULL)::numeric,
            2
        ) AS median_without_skill

    FROM da_salary d
    CROSS JOIN skills_dim s
    LEFT JOIN da_skills dsj
        ON d.job_id = dsj.job_id
       AND s.skill_id = dsj.skill_id
    GROUP BY s.skill_id, s.skills
)
SELECT
    skill_name,
    jobs_with_skill,
    jobs_without_skill,
    median_with_skill,
    median_without_skill,
    ROUND(
        100.0 * (
            median_with_skill - median_without_skill
        ) / NULLIF(median_without_skill, 0),
        2
    ) AS salary_difference_pct
FROM skill_comparison
WHERE jobs_with_skill >= 100
  AND jobs_without_skill >= 100
ORDER BY salary_difference_pct DESC
LIMIT 20;

WITH da_jobs AS (
    SELECT
        job_id,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
),

da_skills AS (
    SELECT DISTINCT
        j.job_id,
        LOWER(TRIM(s.skills)) AS skill_name
    FROM job_postings_fact j
    JOIN skills_job_dim sj
        ON j.job_id = sj.job_id
    JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
),

skill_combinations AS (
    SELECT
        a.job_id,
        a.skill_name AS skill_1,
        b.skill_name AS skill_2,
        c.skill_name AS skill_3
    FROM da_skills a
    JOIN da_skills b
        ON a.job_id = b.job_id
       AND a.skill_name < b.skill_name
    JOIN da_skills c
        ON a.job_id = c.job_id
       AND b.skill_name < c.skill_name
),

top_combinations AS (
    SELECT
        skill_1,
        skill_2,
        skill_3,
        COUNT(*) AS total_jobs
    FROM skill_combinations
    GROUP BY skill_1, skill_2, skill_3
    ORDER BY total_jobs DESC
    LIMIT 20
),

combination_comparison AS (
    SELECT
        tc.skill_1,
        tc.skill_2,
        tc.skill_3,
        tc.total_jobs,

        COUNT(*) FILTER (
            WHERE sc.job_id IS NOT NULL
        ) AS jobs_with_combination,

        COUNT(*) FILTER (
            WHERE sc.job_id IS NULL
        ) AS jobs_without_combination,

        COUNT(dj.salary_year_avg) FILTER (
            WHERE sc.job_id IS NOT NULL
        ) AS salary_count_with,

        COUNT(dj.salary_year_avg) FILTER (
            WHERE sc.job_id IS NULL
        ) AS salary_count_without,

        -- TAMBAHKAN ::numeric DI SINI
        PERCENTILE_CONT(0.5)
            WITHIN GROUP (
                ORDER BY dj.salary_year_avg
            ) FILTER (
                WHERE sc.job_id IS NOT NULL
            )::numeric AS median_with,

        -- TAMBAHKAN ::numeric DI SINI JUGA
        PERCENTILE_CONT(0.5)
            WITHIN GROUP (
                ORDER BY dj.salary_year_avg
            ) FILTER (
                WHERE sc.job_id IS NULL
            )::numeric AS median_without

    FROM top_combinations tc
    CROSS JOIN da_jobs dj
    LEFT JOIN skill_combinations sc
        ON sc.job_id = dj.job_id
       AND sc.skill_1 = tc.skill_1
       AND sc.skill_2 = tc.skill_2
       AND sc.skill_3 = tc.skill_3

    GROUP BY
        tc.skill_1,
        tc.skill_2,
        tc.skill_3,
        tc.total_jobs
)

SELECT
    skill_1,
    skill_2,
    skill_3,
    total_jobs,
    salary_count_with,
    salary_count_without,
    ROUND(median_with, 2) AS median_with,
    ROUND(median_without, 2) AS median_without,
    ROUND(
        100.0 * (median_with - median_without) /
        NULLIF(median_without, 0),
        2
    ) AS salary_difference_pct

FROM combination_comparison
WHERE salary_count_with >= 50
  AND salary_count_without >= 50
ORDER BY salary_difference_pct DESC;

WITH job_skill_count AS (
    SELECT
        sj.job_id,
        COUNT(DISTINCT LOWER(TRIM(s.skills))) AS total_skills
    FROM skills_job_dim sj
    JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    GROUP BY sj.job_id
),

da_jobs AS (
    SELECT
        j.job_id,
        j.job_title_short,
        COALESCE(jsc.total_skills, 0) AS total_skills,
        j.salary_year_avg
    FROM job_postings_fact j
    LEFT JOIN job_skill_count jsc
        ON j.job_id = jsc.job_id
    -- WHERE j.job_title_short = 'Data Analyst'
    WHERE j.job_title_short IN (
        'Data Analyst',
        'Senior Data Analyst'
    )
),

grouped_jobs AS (
    SELECT
        *,
        CASE
            WHEN total_skills = 0 THEN '0 - No skill data'
            WHEN total_skills BETWEEN 1 AND 3 THEN '1-3 Skills'
            WHEN total_skills BETWEEN 4 AND 6 THEN '4-6 Skills'
            WHEN total_skills BETWEEN 7 AND 9 THEN '7-9 Skills'
            ELSE '10+ Skills'
        END AS skill_group,
        CASE
            WHEN total_skills = 0 THEN 0
            WHEN total_skills BETWEEN 1 AND 3 THEN 1
            WHEN total_skills BETWEEN 4 AND 6 THEN 2
            WHEN total_skills BETWEEN 7 AND 9 THEN 3
            ELSE 4
        END AS sort_order
    FROM da_jobs
)

SELECT
    job_title_short,
    skill_group,
    COUNT(*) AS total_postings,
    COUNT(salary_year_avg) AS postings_with_salary,
    ROUND(AVG(salary_year_avg)::numeric, 2) AS avg_salary,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_year_avg)::numeric,
        2
    ) AS median_salary
FROM grouped_jobs
GROUP BY job_title_short, skill_group, sort_order
ORDER BY job_title_short, sort_order;