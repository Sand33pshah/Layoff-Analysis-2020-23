# Layoff Analysis 2020-23

Welcome to the **Layoff Analysis 2020-23** repository! This project provides a comprehensive SQL-driven exploration of company layoffs from 2020 to 2023, primarily using real-world layoff data. The repository is designed for data analysts, business professionals, and anyone interested in understanding layoff trends post-COVID-19.

## Repository Structure & Contents

- **layoffs.csv**  
  The core dataset containing detailed layoff records, including:  
  - `company`: Name of the company  
  - `location`: City/region  
  - `industry`: Business sector  
  - `total_laid_off`: Number of employees laid off  
  - `percentage_laid_off`: Percentage of workforce laid off  
  - `date`: Date of layoff event  
  - `stage`: Funding or company stage (e.g., Post-IPO, Series A, etc.)  
  - `country`: Country of operation  
  - `funds_raised_millions`: Total funds raised (if available)  

- **Practise Cleaning.sql**  
  SQL script for **data cleaning and preprocessing**. Key steps include:
  - Removing duplicates and standardizing fields (e.g., company, industry, country)
  - Handling null/blank values, correcting data types (e.g., converting date strings to DATE)
  - Creating staging tables for safe data manipulation
  - Ensuring consistency in categorical fields (e.g., merging "crypto" and "crypto currency" into "Crypto")
  - Populating missing values based on related entries

- **Practise EDA.sql**  
  SQL script for **Exploratory Data Analysis (EDA)**. Contains queries to:
  - Investigate maximum layoffs (both absolute and percentage)
  - Summarize layoffs by company, industry, country, and year
  - Analyze trends such as which companies or sectors were most affected
  - Explore time-based trends, including monthly and yearly breakdowns
  - Rank companies by total layoffs and examine patterns across different years and stages

- **marketSentiments.sql**  
  SQL script focusing on **business insights and advanced analysis**. Key questions addressed:
  - Which industries or countries were hit hardest?
  - How did layoffs trend over time? Are there seasonal patterns?
  - Which companies had the highest layoff percentages?
  - How do funding stage and funds raised correlate with layoff activity?
  - In-depth breakdowns for specific industries (e.g., Food) and funding rounds

- **README.md**  
  (This file) Explains the repository structure and guides users on what to expect and how to use each file.

## How to Use

1. **Data Preparation:**  
   Start with `Practise Cleaning.sql` to clean and standardize the raw data from `layoffs.csv`. This ensures accurate analysis downstream.

2. **Exploratory Analysis:**  
   Use `Practise EDA.sql` to run descriptive and diagnostic queries, yielding insights into layoff distribution, trends, and sectoral impacts.

3. **Business Insights & Deep Dives:**  
   Apply the queries in `marketSentiments.sql` for more nuanced questions (e.g., year-over-year changes, funding round analysis, geographic focus).

## Key Insights You Can Explore

- Total and percentage layoffs by company, industry, country, and year
- Identification of companies/industries most impacted by layoffs
- Time-based (monthly/yearly) trends and rolling totals
- Effects of funding stage and capital raised on layoff likelihood and magnitude
- Seasonal or cyclical layoff patterns
- Data-driven answers to specific business questions

## Who Is This For?

- Data analysts looking for real-world SQL practice
- Business professionals & HR analysts tracking market trends
- Academics and students studying COVID-19’s impact on employment
- Anyone interested in data-driven business intelligence using SQL

## Getting Started

- Load `layoffs.csv` into your preferred SQL or database platform.
- Run the scripts in order: start with cleaning, proceed with EDA, and finish with business insights.
- Modify or extend queries as needed for your own analysis.

---

**Explore the scripts and leverage this repo to gain a deep, data-driven understanding of global layoff trends from 2020 to 2023.**
