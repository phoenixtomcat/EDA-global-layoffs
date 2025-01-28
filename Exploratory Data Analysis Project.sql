-- Exploratory Data Analysis

select * 
from layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off) # percentage laid of of 1 is 100% ALL
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2; #first lay offs date, latest lay offs date 

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry 
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country 
order by 2 desc;

select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date` 
order by 1 desc;

select YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`) 
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select substring(`date`,1,7) as `MONTH`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc;

with rolling_total as
(
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
)
select `MONTH`, total_off,
sum(total_off) over(order by `MONTH`) as rolling_total
from rolling_total;

select company, sum(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by company asc;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 asc;


with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as 
(select *, 
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
)
select *
from company_year_rank
where ranking <= 5
;