-- Data Cleaning

SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. null values or blank values (populate or delete them)
-- 4. Remove any columns and rows

-- Creating a new table so that we still have raw data available as a back up in case something goes wrong
-- Also if your table is fetching data directly from the web then  deleting rows and columns might raise an error
CREATE TABLE practise_staging LIKE layoffs;

-- Inserting all the values as it is in the duplicate table
INSERT INTO practise_staging
SELECT * from layoffs;

-- Viewing second table
SELECT * FROM practise_staging;

-- since there is no unique column that will help us identify unique row we will use
-- ROW NUMBER() FUNCTION to see if we have any duplicates

-- first we checked the duplicate data using main key columns, however some unique rows were also filtered out.
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)
FROM practise_staging;

-- Using CTE (Common Table Expression) to create row_num column with count of duplicate rows and filter it.
-- CTE is used to deal with hierarchical data, complex aggregation, and recursive queries.
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location ,industry, total_laid_off, percentage_laid_off,`date`,stage, country, funds_raised_millions) row_num
FROM practise_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Checking if the CTE which filtered duplicates are actually correct.
SELECT * FROM practise_staging WHERE company = 'casper';

-- deleting the the data with row_number > 2 which indicates the duplicate number of rows.
-- However the deletion wont happen because there is no unique column in this table to give the reference to
-- AND CTE table cannot reference and update to itself.
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location ,industry, total_laid_off, percentage_laid_off,`date`,stage, country, funds_raised_millions) row_num
FROM practise_staging
)
DELETE FROM duplicate_cte WHERE row_num > 1;

-- Deleting any table if ever existed.
DROP TABLE practise_staging2;

-- creating a new table where we will have row number column attached to remove duplicates and perform further operations
CREATE TABLE `practise_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM practise_staging2;

-- Inserting the data from practise_staging2 along with row number created over partition.
INSERT INTO practise_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location ,industry, 
total_laid_off, percentage_laid_off,`date`,stage, country, funds_raised_millions) row_num
FROM practise_staging;

-- Selected all the rows who have row_num greater than 1 which indicates duplicate rows.
SELECT * FROM practise_staging2 WHERE row_num > 1;

-- 5 rows deleted
DELETE FROM practise_staging2 WHERE row_num > 1;

-- Just seeing what to do next
SELECT * FROM practise_staging2;

-- Step 2 Standardization

-- We can see some unwanted spaces in compnay name so lets remove that first. 
SELECT company, TRIM(company) FROM practise_staging2;

-- Setting the compnay name to new trimmed version
UPDATE practise_staging2
SET company = TRIM(COMPANY);

-- Checking Other column for necessary standardization
SELECT DISTINCT INDUSTRY
FROM practise_staging2
ORDER BY 1;

-- We can see that crypto and crypto currencies are looking kinda same
SELECT *
FROM practise_staging2
WHERE industry LIKE 'Crypto%';

-- updating the crypto and crypto currency to sole category i.e Crypto
UPDATE practise_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Date is in Text format right now but we are changing it into the date type
SELECT `date`, str_to_date(`date`, '%m/%d/%Y') AS 'formatted_date'
FROM practise_staging2;

-- updated the entries to the date format but the column itself is in text so next we will do
UPDATE practise_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- is we modify the column date from text to date
ALTER TABLE practise_staging2
MODIFY COLUMN `date` DATE;

-- Checking the further columns for standardrization

-- we found that the one couontry entry has 
SELECT DISTINCT country
FROM practise_staging2
ORDER BY 1;

-- Viewing the entire table to see the more information before applying the changes
SELECT *
FROM practise_staging2
WHERE country LIKE 'United State%';

-- Changes applied changed country united states. to united states
UPDATE practise_staging2
SET country = 'United States'
WHERE country LIKE 'United State%';

-- Since all the data we had are standardrized then we will remove the null values from the table that are not important to do EDA

-- we have few blank and null cells in the industry column
SELECT DISTINCT industry
FROM practise_staging2
ORDER BY 1;

-- seeing rows which has the blank or null cell to see if we can repopulate them or delete them.
SELECT *
FROM practise_staging2
WHERE industry = '' OR industry IS NULL;

-- since we have found that the multi
UPDATE practise_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM practise_staging2
WHERE company LIKE 'Bally%';

UPDATE practise_staging2 ps1
	JOIN practise_staging2 ps2
	ON ps1.company = ps2.company
SET ps1.industry = ps2.industry
WHERE ps1.industry IS NULL AND ps2.industry IS NOT NULL;


SELECT *
FROM practise_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM practise_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE practise_staging2
DROP COLUMN row_num;

SELECT *
FROM practise_staging2;



