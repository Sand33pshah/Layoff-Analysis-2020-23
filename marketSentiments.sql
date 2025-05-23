-- Business Questions
SELECT *
FROM practise_staging2 WHERE country = 'Lithuania';

-- Which industry have the highest number of layoffs
SELECT industry, SUM(total_laid_off)
FROM practise_staging2
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;

-- how do layoffs vary across different locations and countries
WITH ranking_location AS (
SELECT country, location, SUM(total_laid_off) total_layoffs,
DENSE_RANK() OVER(PARTITION BY country ORDER BY SUM(total_laid_off)) as location_rank
FROM practise_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY 1,2
ORDER BY 2,3 DESC
)
SELECT * FROM ranking_location WHERE location_rank < 5 ORDER BY 1,4;

-- What is the trend of layoffs over time? Are layoff increasing or decreasing?

-- COALESCE treats null value as 0 and does the accurate calculations like sum avg and diff
WITH yearly_layoff AS (
SELECT YEAR(`date`) years, SUM(COALESCE(total_laid_off,0)) total_laidoff 
FROM practise_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1
) SELECT *, total_laidoff - LAG(total_laidoff) OVER(ORDER BY years) as year_over_year_difference,
ROUND(
    100.0 * (total_laidoff - LAG(total_laidoff) OVER (ORDER BY years)) / NULLIF(LAG(total_laidoff) OVER (ORDER BY years), 0),
    2
  ) AS percent_change
FROM yearly_layoff
;

-- Are there seasonal patterns in layoff (e.g. certain months with higher layoffs)?
-- the below query shows all the highest laidoff months from the data and we can see near the financial year the lay offs are happening.

WITH monthly_layoff(years, months, total_laidofff) AS (
SELECT YEAR(`date`), MONTH(`date`), SUM(total_laid_off) 
FROM practise_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY 1,2),
ranked_monthly AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laidofff DESC) ranks
FROM monthly_layoff
ORDER BY 1)
SELECT *
FROM ranked_monthly
WHERE ranks < 3;

-- which company have laid off the higest percentage of employee
-- this query really gives better understanding of the market trends I can see all the industry that did the massive layoff also 
-- I can see at which stage. 
SELECT company,industry, stage, SUM(total_laid_off), ROUND(AVG(percentage_laid_off)*100,2)
FROM practise_staging2
GROUP BY 1,2,3
ORDER BY 5 DESC, 2,3;

-- With the help of above query lets analyze the food industry for better understanding the layoffs
-- the below query shows the funding round wise layoff to understang the if early growth stage lays the more employee or the later.
WITH percentage_layoff(company,industry, stage,total_layoff, percentage_layoff) AS(
SELECT company,industry, stage, SUM(total_laid_off), ROUND(AVG(percentage_laid_off)*100,2)
FROM practise_staging2
GROUP BY 1,2,3
ORDER BY 5 DESC, 2,3
)SELECT stage, COUNT(*), ROUND(AVG(percentage_layoff),2), SUM(total_layoff)
FROM percentage_layoff
WHERE industry = 'FOOD'
GROUP BY 1
ORDER BY 1;

--  see how many industry has laid more or less than 50 % employee.
WITH percentage_layoff(company,industry, stage,total_layoff, percentage_layoff) AS(
SELECT company,industry, stage, SUM(total_laid_off), ROUND(AVG(percentage_laid_off)*100,2)
FROM practise_staging2
GROUP BY 1,2,3
ORDER BY 5 DESC, 2,3
)SELECT COUNT(*)
FROM percentage_layoff
WHERE industry = 'FOOD'AND percentage_layoff < 50;

-- AND stage = 'Acquired'  similarly like above we can filter data on different stage
-- AND percentage_layoff IS NULL -- we can see how many company data is null.


-- How does funding stage correlate with layoff
-- Are startup more likely to lay off employee compared to well funded companies.
WITH percentage_layoff(company,industry, stage,total_layoff, percentage_layoff) AS(
SELECT company,industry, stage, SUM(total_laid_off), ROUND(AVG(percentage_laid_off)*100,2)
FROM practise_staging2
GROUP BY 1,2,3
ORDER BY 5 DESC, 2,3
)SELECT stage, COUNT(*), ROUND(AVG(percentage_layoff),2), SUM(total_layoff)
FROM percentage_layoff
GROUP BY 1
ORDER BY 1;

-- Is there any relationship between the amount of funds raised and the percentage of layoffs?
SELECT company, industry, stage, ROUND(AVG(percentage_laid_off)*100,2), SUM(funds_raised_millions)
FROM practise_staging2
GROUP BY 1,2,3
ORDER BY 1,3;

WITH funding_and_layoff AS(
SELECT company, industry, stage, ROUND(AVG(percentage_laid_off)*100,2), SUM(funds_raised_millions)
FROM practise_staging2
GROUP BY 1,2,3
)SELECT *
FROM funding_and_layoff
WHERE COMPANY = 'Brex'
ORDER BY 1,3;



