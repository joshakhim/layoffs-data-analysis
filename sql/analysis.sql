-- NOW EXPLORATORY DATA ANALYSIS --

-- Looking at this Dataset --
SELECT *
FROM layoffs_cleaned
WHERE company LIKE 'blackba%'
;


-- Highest number of Lay off --
-- and the overall percentage --
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_cleaned;



-- Companies that completely laid off all thier employees --
SELECT *
FROM layoffs_cleaned
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;


-- Total number of Lay off --
-- from highest to Lowest --
SELECT company, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company
ORDER BY 2 DESC
;

-- Looking at the Date range --
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_cleaned
;

-- Total number of laid off By Year --
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY YEAR(`date`)
ORDER BY 1  DESC
;

-- Total number of laid off By Month --
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) 
FROM layoffs_cleaned
GROUP BY `MONTH`
ORDER BY 1  ASC;


-- The progression of Layoffs --
WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) total_off
FROM layoffs_cleaned
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
, SUM(total_off) OVER(ORDER BY `MONTH`) rolling_total
FROM Rolling_total;


SELECT company, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company
ORDER BY 2 DESC
;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;


-- Ranking top companies with the highest layoffs --
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
;

WITH Company_Year (company, years, total_laid_off)  AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
),Company_year_rank AS
( 
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) ranking
FROM Company_Year
)
SELECT *
FROM Company_year_rank
WHERE ranking <= 5
;


-- Monthly Layoff Trend --
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs
GROUP BY month
ORDER BY month;


-- Funding vs Layoffs --
SELECT company,
       funds_raised_millions,
       total_laid_off
FROM layoffs
ORDER BY funds_raised_millions DESC;
