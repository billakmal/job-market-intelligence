# Job Market Intelligence: Data Analyst Skills, Salary, and Job Demand

## Project Overview

This project analyzes job posting data to explore employment trends, salary distributions, and in-demand skills across different job categories, with a particular focus on Data Analyst roles.

The analysis uses SQL and Python to examine job market patterns, identify relevant skills, and understand how Data Analyst opportunities compare with other technology-related positions.

The project aims to provide insights into the skills and qualifications that are relevant to the Data Analyst job market.

## Dataset

The dataset consists of four relational tables:

| Table | Description |
|---|---|
| `job_postings_fact` | Contains job posting details, including job titles, locations, salaries, and posting dates. |
| `company_dim` | Contains company information. |
| `skills_dim` | Contains skill names and categories. |
| `skills_job_dim` | Connects job postings with their associated skills. |

**Dataset Overview:**
- Total job postings: 787,686
- Total skills: 259
- Total job-skill relationships: 3,669,604
- Date coverage: December 31, 2022 – December 31, 2023

## Data Quality Assessment

Before conducting the analysis, the dataset was examined to evaluate its integrity, completeness, and consistency.

### Data Integrity

- No duplicate primary keys were identified in the three tables checked: `job_postings_fact`, `company_dim`, and `skills_dim`.
- No unmatched foreign key references were found between job postings, companies, and skills.
- The dataset covers job postings from December 31, 2022, to December 31, 2023.

### Missing Values

Several columns contain missing values, particularly salary-related fields.

| Column | Missing Values |
|---|---:|
| `salary_year_avg` | 765,652 (97.20%) |
| `salary_hour_avg` | 777,021 (98.65%) |
| `job_location` | 1,053 |
| `job_schedule_type` | 12,705 |
| `job_country` | 52 |

### Salary Data Availability

Only 32,669 job postings (4.15%) contain at least one available annual or hourly salary value.

- Annual salary: 22,034 postings.
- Hourly salary: 10,665 postings.
- Monthly, weekly, and daily salary rates are present, but their corresponding numeric salary fields are unavailable.

### Data Handling Decisions

- Missing salary values will not be replaced with zero.
- Annual and hourly salary analyses will be conducted separately.
- Job demand and skill demand analyses will use the broader dataset rather than restricting records to postings with salary information.
- Salary-related conclusions will be interpreted cautiously because salary information is available for only a small proportion of job postings.
- The original dataset will remain unchanged; data transformations will be performed within analytical queries.

## Job Demand Analysis

This section examines job posting distribution across countries and employment types to identify patterns in the job market. The analysis considers both the overall job market and Data Analyst-specific opportunities.

### 1. Geographic Distribution

The geographic analysis identifies countries with the highest number of job postings across all job categories and compares them with the distribution of Data Analyst positions.

**Overall Job Market — Top 10 Countries**

| Country | Job Postings | Percentage |
|---|---:|---:|
| United States | 206,943 | 26.27% |
| India | 51,197 | 6.50% |
| United Kingdom | 40,439 | 5.13% |
| France | 40,028 | 5.08% |
| Germany | 27,782 | 3.53% |
| Spain | 25,123 | 3.19% |
| Singapore | 23,702 | 3.01% |
| Sudan | 21,519 | 2.73% |
| Netherlands | 20,673 | 2.62% |
| Italy | 17,073 | 2.17% |

**Data Analyst Job Market — Top 10 Countries**

| Country | Job Postings |
|---|---:|
| United States | 67,956 |
| France | 13,855 |
| United Kingdom | 10,509 |
| Germany | 7,141 |
| Singapore | 6,642 |
| India | 6,133 |
| Spain | 5,182 |
| Philippines | 4,770 |
| Italy | 4,570 |
| Netherlands | 4,126 |

**Key Findings:**

- The United States has the highest number of job postings in both the overall market and the Data Analyst category.
- The United States accounts for 26.27% of all postings with a reported country, while its share among Data Analyst postings is approximately 34.57%.
- France ranks fourth in the overall market but second among Data Analyst postings.
- India ranks second overall but sixth among Data Analyst postings.
- Singapore also has a relatively stronger position in the Data Analyst market compared with its overall ranking.

### Geographic Data Anomaly

During the geographic analysis, Sudan appeared among the top 10 countries with 21,519 job postings. Further investigation revealed inconsistencies between `job_country` and `job_location`.

For example, some records classified under Sudan contained locations such as United States and Texas. This suggests potential geographic misclassification in the source data.

The following considerations apply:

- Country-level results may contain classification errors.
- The original country values have not been modified or removed.
- Sudan's posting count should not be interpreted as a reliable measure of actual job market demand without further validation.
- Geographic findings should be interpreted as distributions within the available dataset rather than definitive representations of global labor demand.

### 2. Employment Type Distribution

This analysis examines the distribution of employment types across selected job categories, including Data Analyst, Business Analyst, Data Engineer, Data Scientist, and other technology-related roles.

Employment types were normalized by splitting combined values into individual categories. For example, a posting labeled `Full-time and Part-time` is counted under both categories.

**Employment Type Distribution by Job Category**

| Job Category | Full-time | Contractor | Part-time | Internship |
|---|---:|---:|---:|---:|
| Business Analyst | 93.90% | 4.17% | 1.69% | 1.33% |
| Cloud Engineer | 95.78% | 3.20% | 1.17% | 0.36% |
| Data Analyst | 90.52% | 5.95% | 2.71% | 2.36% |
| Data Engineer | 91.68% | 7.05% | 1.46% | 0.93% |
| Data Scientist | 92.48% | 4.27% | 2.54% | 2.65% |
| Machine Learning Engineer | 94.70% | 3.52% | 1.28% | 1.53% |
| Senior Data Analyst | 95.52% | 3.82% | 1.48% | 0.07% |
| Senior Data Engineer | 94.59% | 5.11% | 1.40% | 0.04% |
| Senior Data Scientist | 97.24% | 2.34% | 1.26% | 0.08% |
| Software Engineer | 96.28% | 2.64% | 0.93% | 0.80% |

**Key Findings:**

- Full-time positions dominate all analyzed job categories, ranging from 90.52% to 97.24%.
- Data Analyst has the lowest Full-time proportion among the selected categories, at 90.52%.
- Data Analyst has the highest Part-time proportion, at 2.71%.
- Data Scientist has the highest Internship proportion, at 2.65%, followed by Data Analyst at 2.36%.
- In absolute numbers, Data Analyst has 4,532 internship postings, slightly higher than Data Scientist with 4,527 postings.
- Data Engineer has the highest Contractor proportion, at 7.05%.

**Methodology Notes:**

- Employment type values were separated into individual categories using SQL string operations.
- Each job posting is counted once per employment type using `COUNT(DISTINCT job_id)`.
- Percentages use postings with available employment type information as the denominator.
- A posting may belong to multiple employment type categories; therefore, percentages may add up to more than 100%.
- The analysis covers selected job categories rather than every job title in the dataset.

## Salary Analysis

This section examines annual salary distributions across different job categories, with a particular focus on Data Analyst positions.

### 1. Annual Salary Overview

Out of 787,686 job postings, only 22,034 contain an available annual salary value. Therefore, salary analysis is conducted using postings with non-null `salary_year_avg` values.

**Overall Annual Salary Statistics**

| Metric | Value |
|---|---:|
| Total postings with salary data | 22,034 |
| Average salary | $123,268.82 |
| Median salary | $115,000 |
| Q1 | $90,000 |
| Q3 | $150,000 |
| Standard deviation | $48,271.06 |

### 2. Data Analyst Annual Salary

Among the 22,034 postings with annual salary information, 5,463 belong to the Data Analyst category.

| Metric | Value |
|---|---:|
| Total postings | 5,463 |
| Average salary | $93,875.79 |
| Median salary | $90,000 |
| Q1 | $70,000 |
| Q3 | $111,175 |
| Standard deviation | $34,086.67 |

**Key Findings:**

- The median annual salary for Data Analyst positions is $90,000.
- The middle 50% of reported salaries fall between $70,000 and $111,175.
- The average salary ($93,875.79) is higher than the median, suggesting a right-skewed salary distribution.
- Data Analyst postings account for approximately 24.79% of all postings with available annual salary information.

### 3. Annual Salary Comparison Across Job Categories

The analysis compares annual salary distributions across selected technology-related job categories. Only categories with at least 100 salary observations are included.

| Job Category | Postings | Average Salary | Median Salary |
|---|---:|---:|---:|
| Senior Data Scientist | 1,686 | $154,050.03 | $155,000 |
| Senior Data Engineer | 1,594 | $145,866.87 | $147,500 |
| Data Scientist | 5,926 | $135,929.48 | $127,500 |
| Data Engineer | 4,509 | $130,266.87 | $125,000 |
| Senior Data Analyst | 1,132 | $114,104.05 | $111,175 |
| Machine Learning Engineer | 573 | $126,785.91 | $106,000 |
| Software Engineer | 469 | $112,777.64 | $99,150 |
| Data Analyst | 5,463 | $93,875.79 | $90,000 |
| Business Analyst | 617 | $91,071.04 | $85,000 |

**Key Findings:**

- Senior Data Scientist has the highest median annual salary among the analyzed categories, at $155,000.
- Data Scientist and Data Engineer have relatively similar median salaries, at $127,500 and $125,000, respectively.
- Senior Data Analyst has a median salary approximately 23.53% higher than Data Analyst.
- Data Analyst has a higher median salary than Business Analyst, with a difference of $5,000.
- Data Analyst has the second-largest salary sample among the selected categories, providing a relatively substantial basis for comparison.

### 4. Hourly Salary Analysis

In addition to annual salaries, this analysis examines job postings that provide hourly compensation information.

**Hourly Salary Comparison Across Job Categories**

| Job Category | Postings | Average Hourly Salary | Median Hourly Salary |
|---|---:|---:|---:|
| Senior Data Engineer | 425 | $62.63 | $61.50 |
| Data Engineer | 2,296 | $57.26 | $58.59 |
| Senior Data Scientist | 324 | $54.09 | $47.62 |
| Software Engineer | 103 | $46.28 | $47.50 |
| Data Scientist | 2,573 | $49.39 | $47.50 |
| Senior Data Analyst | 354 | $47.37 | $47.30 |
| Business Analyst | 388 | $42.70 | $40.16 |
| Data Analyst | 4,135 | $38.15 | $32.72 |

**Key Findings:**

- Senior Data Engineer has the highest median hourly salary at $61.50.
- Data Engineer follows with a median of $58.59 per hour.
- Data Analyst has the lowest median hourly salary among the eight analyzed categories, at $32.72.
- Senior Data Analyst has a median hourly salary approximately 44.56% higher than Data Analyst.
- Data Analyst has the largest hourly salary sample, with 4,135 postings.
- The average hourly salary for Data Analyst ($38.15) is higher than its median ($32.72), suggesting a potential right-skewed distribution.

### 5. Salary Distribution and Outlier Analysis

The annual salary distribution for Data Analyst positions exhibits a strong positive skewness (2.33), indicating that a small number of high-paying postings extend the distribution's right tail.

Using the IQR method, 121 outliers (2.21% of 5,463 observations) were identified, with salaries ranging from $173,000 to $650,000.

A comparison between outliers and non-outliers revealed:

- Non-outlier median salary: $90,000.
- Outlier median salary: $194,500.
- Non-outlier average salary: $91,203.
- Outlier average salary: $211,857.

Although outliers represent only 2.21% of observations, they increase the overall average salary by approximately 2.93%.

Further investigation revealed that some high-paying postings were associated with senior, managerial, and director-level positions, while others retained the Data Analyst title.

**Data handling decision:** Outliers were retained because statistical extremity alone does not establish data invalidity. Median salary was prioritized when describing typical Data Analyst compensation due to the positively skewed distribution.

### 6. Salary Analysis Methodology and Limitations

- Annual and hourly salary analyses are conducted separately using `salary_year_avg` and `salary_hour_avg`.
- Missing salary values are excluded rather than replaced with zero.
- Median salary is used as the primary comparison metric because it is less sensitive to extreme values than the average.
- Q1 and Q3 are used to describe the middle 50% of salary observations.
- Job categories with fewer than 100 salary observations are excluded from category comparisons.
- Annual and hourly salary samples may overlap or contain different postings. They should not be treated as identical populations.
- Salary information is available for only a small proportion of all job postings, which may introduce selection bias.
- Salary differences may also be influenced by location, seniority, company characteristics, and other factors not controlled for in this descriptive analysis.

### Skill Demand Across Job Categories

The skill demand analysis reveals distinct technical requirements across four job categories.

- **Data Analyst:** SQL (47.12%), Excel (34.10%), Python (29.16%), Tableau (23.68%), and Power BI (20.08%) are the most frequently requested skills.
- **Business Analyst:** SQL (35.34%) and Excel (34.85%) lead the demand, followed by Tableau (18.97%) and Power BI (18.82%).
- **Data Engineer:** SQL (60.73%) and Python (58.00%) dominate, alongside cloud and data processing technologies such as AWS, Azure, and Spark.
- **Data Scientist:** Python (66.01%), SQL (45.84%), and R (34.59%) are the most frequently requested skills, with additional demand for machine learning frameworks such as TensorFlow and PyTorch.

**Key findings:**
1. SQL is a widely requested skill across all four job categories.
2. Excel is more prominent in Data Analyst and Business Analyst roles.
3. Python is particularly important for Data Scientist and Data Engineer positions.
4. Data Engineer roles show stronger demand for cloud platforms and data processing technologies.

These percentages represent the proportion of job postings within each category that mention a particular skill. A posting may mention multiple skills, so percentages across different skills are not expected to sum to 100%.

### Skills Associated with Higher Salaries

A comparison of median annual salaries between Data Analyst postings that mention specific skills and those that do not revealed several notable differences.

The highest salary differences were associated with big data and data infrastructure technologies:

| Skill | Median with Skill | Median without Skill | Difference |
|---|---:|---:|---:|
| Spark | $111,175 | $90,000 | +23.53% |
| Hadoop | $111,175 | $90,000 | +23.53% |
| Snowflake | $110,240 | $90,000 | +22.49% |
| Databricks | $110,000 | $90,000 | +22.22% |
| Python | $98,500 | $85,000 | +15.88% |
| SQL | $92,500 | $85,000 | +8.82% |
| Tableau | $95,000 | $88,105 | +7.83% |

**Key findings:**
- Big data technologies such as Spark, Hadoop, Snowflake, and Databricks showed the largest median salary differences.
- Python was associated with a 15.88% higher median salary.
- SQL remained a widely requested skill, although its median salary difference was relatively modest.
- Salary differences represent associations rather than causal effects. Other factors, including seniority, location, company, and overlapping skill requirements, may influence the results.

A minimum threshold of 100 salary observations per skill group was applied to reduce the influence of very small samples.


Python Usage
### Skill Demand Across Job Categories

The comparison of skill requirements across four job categories reveals distinct technical profiles.

| Skill | Business Analyst | Data Analyst | Data Engineer | Data Scientist |
|---|---:|---:|---:|---:|
| SQL | 35.34% | 47.12% | 60.73% | 45.84% |
| Excel | 34.85% | 34.10% | 4.56% | 10.19% |
| Python | 16.47% | 29.16% | 58.00% | 66.01% |
| Tableau | 18.97% | 23.68% | 10.08% | 17.09% |
| Power BI | 18.82% | 20.08% | 10.12% | 9.12% |
| R | 8.21% | 15.30% | 6.80% | 34.59% |
| AWS | 3.71% | 4.61% | 33.31% | 15.23% |
| Azure | 5.16% | 5.57% | 32.58% | 12.56% |
| Spark | 1.52% | 2.56% | 28.81% | 14.10% |

**Key findings:**

1. SQL is widely requested across all four job categories, highlighting its importance as a foundational data skill.
2. Excel is more prominent in Business Analyst and Data Analyst roles, reflecting their emphasis on data analysis and business reporting.
3. Python is particularly important for Data Scientist and Data Engineer positions, with demand reaching 66.01% and 58.00%, respectively.
4. Data Engineer roles show stronger demand for cloud platforms and data processing technologies, particularly AWS, Azure, and Spark.
5. Data Scientist positions show substantially higher demand for R than the other categories.

These findings highlight differences in technical requirements across data-related roles. Percentages represent the proportion of job postings within each category that mention a particular skill. A posting may mention multiple skills, so percentages across skills are not expected to sum to 100%.