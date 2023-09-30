use covid_sql_project;

-- Removing unwanted columns from both tables
SELECT 
    *
FROM
    covid_vaccinations;
alter table covid_vaccinations drop column life_expectancy;
alter table covid_vaccinations drop column cardiovasc_death_rate;
alter table covid_vaccinations drop column diabetes_prevalence;

SELECT 
    *
FROM
    covid_deaths;
alter table covid_deaths drop column reproduction_rate;
alter table covid_deaths drop column icu_patients;

-- initializing the imported tables in the database 
SELECT 
    *
FROM
    covid_vaccinations;
SELECT 
    *
FROM
    covid_deaths;

-- checking for duplicates in both tables using CTEs
-- starting with covid_vaccinations table
with row_num_CTE as (select *, row_number() 
over(partition by 
     continent, location, date, 
	 total_tests, new_tests, total_vaccinations, 
     people_vaccinated, new_vaccinations, people_fully_vaccinated order by iso_code) as row_num 
     from covid_vaccinations)
     select * from row_num_CTE where row_num > 1;
     
-- covid_deaths table
SELECT 
    *
FROM
    covid_deaths;
with rowNumCTE as (select *, row_number() over(partition by continent, location, population, date, 
								total_cases, new_cases, total_deaths, 
                                new_deaths, 
                                hosp_patients order by iso_code ) 
                                as row_num from covid_deaths)
select * from rowNumCTE where row_num > 1;

-- Checking for null values in each table
-- starting with covid_deaths table
SELECT 
    *
FROM
    covid_deaths;
SELECT 
    'iso_code' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    iso_code IS NULL 
UNION SELECT 
    'continent' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    continent IS NULL 
UNION SELECT 
    'location' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    location IS NULL 
UNION SELECT 
    'population' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    population IS NULL 
UNION SELECT 
    'date' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    date IS NULL 
UNION SELECT 
    'total_cases' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    total_cases IS NULL 
UNION SELECT 
    'new_cases' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    new_cases IS NULL 
UNION SELECT 
    'total_deaths' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    total_deaths IS NULL 
UNION SELECT 
    'new_deaths' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    new_deaths IS NULL 
UNION SELECT 
    'hosp_patients' AS column_name, COUNT(*) AS null_count
FROM
    covid_deaths
WHERE
    iso_code IS NULL;

-- For covid vaccinations table
SELECT 
    *
FROM
    covid_vaccinations;
SELECT 
    'iso_code' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    iso_code IS NULL 
UNION SELECT 
    'continent' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    continent IS NULL 
UNION SELECT 
    'location' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    location IS NULL 
UNION SELECT 
    'date' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    date IS NULL 
UNION SELECT 
    'total_tests' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    total_tests IS NULL 
UNION SELECT 
    'new_tests' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    new_tests IS NULL 
UNION SELECT 
    'total_vaccinations' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    total_vaccinations IS NULL 
UNION SELECT 
    'peopl_vaccinated' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    people_vaccinated IS NULL 
UNION SELECT 
    'people_full_vaccinated' AS column_name,
    COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    people_fully_vaccinated IS NULL 
UNION SELECT 
    'total_boosters' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    total_boosters IS NULL 
UNION SELECT 
    'new_vaccinations' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    new_vaccinations IS NULL 
UNION SELECT 
    'population' AS column_name, COUNT(*) AS null_count
FROM
    covid_vaccinations
WHERE
    population IS NULL;

-- Removing data redundancy
SELECT DISTINCT
    continent
FROM
    covid_deaths;
DELETE FROM covid_deaths 
WHERE
    continent = ' ';

SELECT DISTINCT
    location
FROM
    covid_deaths;
DELETE FROM covid_deaths 
WHERE
    location = 'european union';
DELETE FROM covid_deaths 
WHERE
    location = 'oceania';
DELETE FROM covid_deaths 
WHERE
    location = 'high income';
DELETE FROM covid_deaths 
WHERE
    location = 'low income';
DELETE FROM covid_deaths 
WHERE
    location = 'North America';
DELETE FROM covid_deaths 
WHERE
    location = 'South America';


-- SQL Data Exploration
SELECT 
    *
FROM
    covid_deaths
ORDER BY 3 , 4;
SELECT 
    continent,
    location,
    population,
    date,
    total_cases,
    total_deaths
FROM
    covid_deaths
ORDER BY 1 , 2;

-- Generating the key covid indicators
-- 1.Total deaths in Kenya
SELECT 
    *
FROM
    covid_deaths;
SELECT 
    CAST(SUM(total_deaths) AS SIGNED) AS Death_totals
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
        AND location = 'Kenya';

-- 3.Total covid cases recorded in Kenya up to 2023
SELECT 
    SUM(total_cases) AS Total_covid_cases
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
        AND location = 'Kenya';

SELECT 
    *
FROM
    covid_vaccinations;
desc covid_vaccinations;
-- 4. Total tests conducted across the globe
SELECT 
    CAST(SUM(total_tests) AS SIGNED) AS Total_tests_conducted
FROM
    covid_vaccinations
WHERE
    continent IS NOT NULL
        AND location = 'kenya';

-- 5. The total vacccinations given to the people in Kenya in 2021
SELECT 
    CONVERT( SUM(total_vaccinations) , SIGNED) AS Sum_total_vaccinations
FROM
    covid_vaccinations
WHERE
    continent IS NOT NULL
        AND location = 'Kenya'
        AND date BETWEEN '1/1/2021' AND '31/12/2021';

-- 6. Average population in Kenya
SELECT 
    *
FROM
    covid_deaths;
SELECT 
    location, AVG(population) AS Average_Population
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
        AND location = 'kenya'
GROUP BY continent
ORDER BY location;

-- Checking death percentage across all continents which shows the likelihood of dying after contacting covid
-- Total deaths vs total cases
SELECT 
    continent,
    location,
    population,
    date,
    total_cases,
    total_deaths,
    CONVERT( (total_deaths / total_cases) * 100 , DECIMAL (7 , 2 )) AS death_percentage
FROM
    covid_deaths
WHERE
    location = 'Kenya'
        AND total_cases IS NOT NULL
ORDER BY death_percentage DESC;

-- Creating va view
CREATE OR REPLACE VIEW total_death_cases AS
    SELECT 
        continent,
        location,
        population,
        date,
        total_cases,
        total_deaths,
        CONVERT( (total_deaths / total_cases) * 100 , DECIMAL (7 , 2 )) AS death_percentage
    FROM
        covid_deaths
    WHERE
        location = 'Kenya'
            AND total_cases IS NOT NULL
    ORDER BY death_percentage DESC;

-- Calling a view
SELECT 
    *
FROM
    covid_sql_project.total_death_cases;

-- Looking for percentage of new deaths on a daily basis due to covid
-- new deaths vs new cases
SELECT 
    continent,
    location,
    date,
    new_cases,
    new_deaths,
    CAST((new_deaths / new_cases) * 100 AS DECIMAL (7 , 2 )) AS new_death_percentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
        AND location = 'Kenya'
ORDER BY continent DESC;

 -- Creating view
CREATE OR REPLACE VIEW new_deaths_cases AS
    SELECT 
        continent,
        location,
        date,
        new_cases,
        new_deaths,
        CAST((new_deaths / new_cases) * 100 AS DECIMAL (7 , 2 )) AS new_death_percentage
    FROM
        covid_deaths
    WHERE
        continent IS NOT NULL
            AND location = 'Kenya'
    ORDER BY new_death_percentage DESC;

-- Calling the view you have created
SELECT 
    *
FROM
    covid_sql_project.new_deaths_cases;
 
 
-- The percentage population that got infected by covid 
-- Total cases vs population
SELECT 
    continent,
    location,
    population,
    total_cases,
    CAST((total_cases / population) * 100 AS DECIMAL (7 , 3 )) AS percenteg_infected
FROM
    covid_deaths
WHERE
    location LIKE '%Ken%'
        AND continent IS NULL
ORDER BY location;

-- The country with the highest rate of infection compared to its population
SELECT 
    *
FROM
    covid_deaths;
desc covid_deaths;
SELECT 
    continent,
    location,
    population,
    MAX(total_cases) AS highest_infection,
    CAST(MAX((total_cases) / population) * 100 AS DECIMAL (7 , 2 )) AS high_infections
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
        AND location = 'kenya'
GROUP BY continent , location , population
ORDER BY high_infections DESC;

-- Countries with the highest death rate
SELECT 
    *
FROM
    covid_deaths;
desc covid_deaths;
SELECT 
    location,
    population,
    CONVERT( MAX(total_deaths) , SIGNED) AS highInfections
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY highInfections DESC;

-- Creating a view
CREATE OR REPLACE VIEW high_death_rate AS
    SELECT 
        location,
        population,
        CONVERT( MAX(total_deaths) , SIGNED) AS highInfections
    FROM
        covid_deaths
    WHERE
        continent IS NOT NULL
    GROUP BY location , population
    ORDER BY highInfections DESC;

-- Calling a view
SELECT 
    *
FROM
    covid_sql_project.high_death_rate;

-- Countries with highest deaths compared to their population
SELECT 
    continent,
    location,
    population,
    MAX(CONVERT( total_deaths , SIGNED)) AS high_death_rate
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY continent , location , population
ORDER BY high_death_rate DESC;

-- Total deaths of deaths per continent
-- Continents with the highest death rate
SELECT 
    continent,
    MAX(CONVERT( total_deaths , SIGNED)) AS total_death_count
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Total global death percentage by continents
desc covid_deaths;
SELECT 
    continent,
    total_deaths,
    SUM(CAST(total_deaths AS SIGNED)) AS global_deaths,
    SUM(CONVERT( total_cases , SIGNED)) AS global_cases,
    SUM(CAST(total_deaths AS SIGNED)) / SUM(CONVERT( total_cases , SIGNED)) * 100 AS global_percentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY continent , total_deaths
ORDER BY global_percentage DESC , continent DESC;

-- Getting the new global numbers of deaths
SELECT 
    continent,
    SUM(new_cases) AS world_cases,
    SUM(new_deaths) AS world_deaths,
    CONVERT( SUM(new_deaths) / SUM(new_cases) * 100 , DECIMAL (7 , 2 )) AS world_deaths_perctage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY world_deaths_perctage DESC;
 
-- The total vaccinations vs population
SELECT 
    *
FROM
    covid_vaccinations;
desc covid_vaccinations;
SELECT 
    continent,
    date,
    location,
    population,
    CAST(total_vaccinations AS SIGNED) AS total_vaccinations,
    (CAST(total_vaccinations AS SIGNED) / population) * 100 AS Vaccination_Percy
FROM
    covid_vaccinations
WHERE
    continent IS NOT NULL
        AND location = 'Kenya'
GROUP BY continent , date , location , total_vaccinations , population , (CAST(total_vaccinations AS SIGNED) / population) * 100
ORDER BY (CAST(total_vaccinations AS SIGNED) / population) DESC , total_vaccinations DESC;

SELECT 
    *
FROM
    covid_vaccinations;
describe covid_vaccinations;

-- People vaccinated vs total vaccines distributed
SELECT 
    continent,
    location,
    SUM(CAST(people_vaccinated AS SIGNED)) AS people_vaccintd,
    SUM(CAST(total_vaccinations AS SIGNED)) AS vaccines,
    SUM(CAST(people_vaccinated AS SIGNED)) / SUM(CAST(total_vaccinations AS SIGNED)) AS percent_of_ppl_vacc
FROM
    covid_vaccinations
WHERE
    continent IS NOT NULL
        AND location = 'Kenya'
GROUP BY continent , location
ORDER BY vaccines DESC;

-- The most affected country under each continent in 2021
SELECT 
    *
FROM
    covid_deaths;
select continent, location, date, total_deaths, first_value(location)
over(partition by continent order by total_deaths desc) 
as most_affected_country
from covid_deaths;

-- Top 3 countries from each continent with the highest deaths
SELECT 
    *
FROM
    covid_deaths;
select * from (select d.*, rank() 
over(partition by continent order by total_deaths desc) as rnk
from covid_deaths d) x where x.rnk<4;

create or replace view countries_affected as 
select * from (select d.*, rank() 
over(partition by continent order by total_deaths desc) as rnk
from covid_deaths d) x where x.rnk<4;

-- Calling this view
SELECT 
    *
FROM
    covid_sql_project.countries_affected;

-- the total cases vs total vaccinations
SELECT 
    d.location,
    d.total_cases,
    v.total_vaccinations,
    MAX(CAST(d.total_cases AS SIGNED)) / MAX(CAST(total_vaccinations AS SIGNED)) * 100 AS Covid_cases
FROM
    covid_deaths d
        JOIN
    covid_vaccinations v ON d.location = v.location
WHERE
    d.continent IS NOT NULL
GROUP BY d.location , d.date , d.total_cases , v.total_vaccinations;

-- Creating a view
CREATE OR REPLACE VIEW total_cases_vaccinations AS
    SELECT 
        d.location,
        d.total_cases,
        v.total_vaccinations,
        MAX(CAST(d.total_cases AS SIGNED)) / MAX(CAST(total_vaccinations AS SIGNED)) * 100 AS Covid_cases
    FROM
        covid_deaths d
            JOIN
        covid_vaccinations v ON d.location = v.location
    WHERE
        d.continent IS NOT NULL
    GROUP BY d.location , d.date , d.total_cases , v.total_vaccinations;

-- Calling the view
SELECT 
    *
FROM
    covid_sql_project.total_cases_vaccinations;