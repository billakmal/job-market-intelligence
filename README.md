# Job Market Intelligence
### Data Analyst Skills, Salary, and Job Demand

An exploratory data analysis project examining the 2023 global job market for data-related roles. This project uses SQL, Python, PostgreSQL, and Power BI to investigate job demand, salary distributions, and technical skill requirements across different data professions.

---

## Project Overview

The data analytics industry includes several related roles, such as Business Analyst, Data Analyst, Data Engineer, and Data Scientist. Although these positions share some technical requirements, their job demand, salary levels, and required skills can differ.

This project analyzes job postings to identify these differences and provide insights into the skills and qualifications commonly requested by employers.

**Key Objectives**
- Analyze job demand across different data-related professions and countries.
- Explore annual and hourly salary distributions.
- Identify the most frequently requested skills for Data Analyst positions.
- Compare skill requirements across related data professions.
- Examine whether salary distributions differ significantly between selected job categories.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Data storage and SQL analysis |
| SQL | Data validation, transformation, and aggregation |
| Python | Exploratory data analysis and statistical testing |
| Pandas & NumPy | Data manipulation |
| Matplotlib & Seaborn | Data visualization |
| SciPy & Statsmodels | Hypothesis testing and multiple-comparison correction |
| Power BI | Interactive dashboard development |
| VS Code & Jupyter Notebook | Development environment |

## Dataset

The project uses the 2023 job-postings dataset provided by Luke Barousse.

The database consists of four primary tables:

| Table | Description |
|---|---|
| `job_postings_fact` | Job posting details, including title, location, salary, and schedule |
| `company_dim` | Company information |
| `skills_dim` | Skill names and identifiers |
| `skills_job_dim` | Relationship between job postings and required skills |

**Dataset overview:**
- Approximately 788,000 job postings.
- 140,033 company records.
- 259 skill identifiers.
- More than 3.6 million job-skill relationships.

The dataset covers job postings from 2023 and should be interpreted as a historical snapshot rather than a representation of the current job market.

## Project Structure

```text
job-market-intelligence/
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_job_demand.sql
│   ├── 03_salary_analysis.sql
│   ├── 04_skill_analysis.sql
│   │
│   └── dashboard/
│       ├── 01_overview.sql
│       ├── 02_skills.sql
│       └── 03_salary.sql
│
├── notebooks/
│   ├── 01_exploratory_data_analysis.ipynb
│   └── 02_statistical_analysis.ipynb
│
├── dashboard/
│   └── job_market_intelligence.pbix
│
├── images/
│
├── .env
├── .gitignore
├── requirements.txt
└── README.md
```

## Analysis & Methodology

### 1. Data Validation

The initial analysis evaluates:
- Missing values and duplicate records.
- Primary-key uniqueness.
- Referential integrity between relational tables.
- Salary data availability.
- Potential inconsistencies in geographic information.

Missing salary values are not replaced with zero because an undisclosed salary is not equivalent to a zero salary.

### 2. Job Demand Analysis

This section investigates:
- Job posting volume across job categories.
- Geographic distribution of job postings.
- Remote and non-remote job opportunities.
- Employment schedule distributions.
- Monthly Data Analyst job posting trends.

### 3. Salary Analysis

Annual and hourly salary information is analyzed separately.

The analysis includes:
- Mean, median, quartiles, and standard deviation.
- Salary distributions across job categories.
- Data Analyst annual and hourly salary distributions.
- Outlier identification using the Interquartile Range (IQR).

The median is emphasized when describing typical salary levels because salary distributions are positively skewed.

### 4. Skill Demand Analysis

The analysis identifies:
- The most frequently requested skills for Data Analyst positions.
- Skill demand across Business Analyst, Data Analyst, Data Engineer, and Data Scientist roles.
- Common skill combinations appearing in Data Analyst job postings.
- Salary patterns associated with selected skill combinations.

### 5. Statistical Analysis

The second notebook investigates salary differences across four job categories:

- Business Analyst
- Data Analyst
- Data Engineer
- Data Scientist

Statistical methods:
- Descriptive statistics.
- Kruskal-Wallis H test.
- Pairwise Mann-Whitney U tests.
- Holm correction for multiple comparisons.
- Rank-biserial correlation for effect size.

## Key Findings

### Job Market Demand

- The dataset contains approximately 788K job postings.
- Data Analyst positions account for approximately 196.6K postings.
- The United States has the largest posting volume among the countries analyzed.
- Full-time employment accounts for approximately 88.4% of Data Analyst postings with a known schedule type.

### Salary Insights

| Job Category | Median Annual Salary |
|---|---:|
| Data Scientist | $127,500 |
| Data Engineer | $125,000 |
| Data Analyst | $90,000 |
| Business Analyst | $85,000 |

Data Analyst salary observations:
- Annual salary mean: $93,875.79.
- Annual salary median: $90,000.
- Hourly salary mean: $38.15.
- Hourly salary median: $32.72.

Salary statistics are based only on postings with available salary information.

### Most Requested Data Analyst Skills

| Skill | Job Postings | Share of DA Postings |
|---|---:|---:|
| SQL | 92,628 | 47.12% |
| Excel | 67,031 | 34.10% |
| Python | 57,326 | 29.16% |
| Tableau | 46,554 | 23.68% |
| Power BI | 39,468 | 20.08% |
| R | 30,075 | 15.30% |

SQL is the most frequently requested skill among Data Analyst postings, followed by Excel and Python.

### Statistical Findings

The Kruskal-Wallis test identified statistically significant differences in salary distributions across the four job categories.

- H-statistic: 3530.8072.
- p-value: p < 0.001.
- Epsilon-squared: 0.2137.

All six pairwise comparisons were statistically significant after Holm correction. However, effect sizes indicate that the magnitude of differences varies between category pairs.

These findings describe associations in the dataset and do not establish that job category alone determines salary.

## Dashboard

The Power BI dashboard presents the main findings through interactive visualizations.

**Dashboard pages:**
1. Overview — job posting volume, geographic distribution, and employment trends.
2. Skills Analysis — most requested skills and comparisons across job categories.
3. Salary Analysis — salary distributions and comparisons across roles.

Dashboard screenshots will be available in the `images/` directory.

## How to Run the Project

### 1. Clone the Repository

```bash
git clone https://github.com/billakmal/job-market-intelligence
cd job-market-intelligence
```

### 2. Set Up the Python Environment

```bash
python -m venv .venv
```

Activate the environment:

**Windows**
```bash
.venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

### 3. Configure Database Connection

Create a `.env` file in the project root:

```env
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database
```

Make sure the PostgreSQL database has been populated with the required dataset tables.

### 4. Run the Notebooks

Run the notebooks in the following order:

1. `01_exploratory_data_analysis.ipynb`
2. `02_statistical_analysis.ipynb`

### 5. Explore the Dashboard

Open `dashboard/job_market_intelligence.pbix` using Power BI Desktop.

## Limitations

- The dataset represents job postings from 2023, not current market conditions.
- Most job postings do not disclose salary information.
- Salary comparisons do not control for country, seniority, experience, or company characteristics.
- Geographic inconsistencies exist in some source records.
- Job postings may request multiple skills, so skill percentages are not mutually exclusive.
- Statistical significance does not necessarily imply a large practical difference.

## Conclusion

This project provides an overview of the 2023 data-related job market by examining job demand, salary distributions, and skill requirements.

The findings highlight the importance of SQL, Excel, and Python for Data Analyst positions, while also showing how salary levels and technical skill requirements vary across related professions.

By combining SQL-based analysis, Python statistical methods, and Power BI visualization, this project demonstrates an end-to-end analytical workflow from data validation to business-oriented insights.