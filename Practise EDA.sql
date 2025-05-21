-- Exploratory Data Analysis

SELECT * 
FROM practise_staging2;

-- Checking the max number and percentage layoff done at once.
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM practise_staging2;

-- seeing which company laid off all the employee ordered to fund raised from the market
SELECT * 
FROM practise_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Show which company laid off how many employee through out the data set of 2020 - 23
-- seems like big tech MAANG company has laid of hundereds of employee
SELECT company, SUM(total_laid_off)
FROM practise_staging2
GROUP BY company
ORDER BY 2 DESC;

-- lets see what duration data we have checking min and max data of the data
SELECT MIN(`date`), MAX(`date`)
FROM practise_staging2;

-- which industry got hit hard during this layoff period
-- seems like consumer Retail Transportation 
SELECT industry, SUM(total_laid_off)
FROM practise_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- If we look over by country then we can see that United States, India, NetherLand has laid off quiet a lot people 
SELECT country, SUM(total_laid_off)
FROM practise_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Looking at the data to see which year the employee were laid off at what number
SELECT YEAR(`date`) YEARS, SUM(total_laid_off)
FROM practise_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Here we can see that POST IOP companies had laid off more people
SELECT stage, SUM(total_laid_off)
FROM practise_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- In this data the percentage_laid_off gives less information then total_laid_off
-- The data we get doesnot seem to convey the message easily
SELECT stage, AVG(percentage_laid_off)
FROM practise_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Lets see which month has more layoffs
-- The below query doesnot give us the month of which year. This data doesnot make any sense as we dont kow which year novemeber has second higest layoff
SELECT MONTH(`date`) months, SUM(total_laid_off)
FROM practise_staging2
GROUP BY months
ORDER BY 2 DESC;

-- seeing the date column to extract the month and year
SELECT `date`
FROM practise_staging2;

-- total laid off employee according the month of the years.
SELECT substr(`DATE`, 1,7) months, SUM(total_laid_off)
FROM practise_staging2
WHERE substr(`DATE`, 1,7) IS NOT NULL
GROUP BY months
ORDER BY 1 DESC;

-- We are calculating the rolling total which will give the insight like
WITH rolling_total AS (
SELECT substr(`DATE`, 1,7) months, SUM(total_laid_off) total_laidoff
FROM practise_staging2
WHERE substr(`DATE`, 1,7) IS NOT NULL
GROUP BY months
ORDER BY 1) 
SELECT months, total_laidoff,
SUM(total_laidoff) OVER(ORDER BY months) rolling_total
FROM rolling_total;

-- Grouping according to the company and in what year that company laid off how many employee
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM practise_staging2
group by 2,1
ORDER BY 3 DESC;

WITH company_year(Company_Name, `Year`, Total_laidoff) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM practise_staging2
group by 1,2
), ranking AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_laidoff DESC) ranking
FROM company_year
WHERE `Year` IS NOT NULL)
SELECT COUNT(*)
FROM ranking
WHERE ranking < 5;



