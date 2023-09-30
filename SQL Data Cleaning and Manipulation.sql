use covid_sql_project;

-- Removing unwanted columns from both tables
select * from covid_vaccinations;
alter table covid_vaccinations drop column life_expectancy;
alter table covid_vaccinations drop column cardiovasc_death_rate;
alter table covid_vaccinations drop column diabetes_prevalence;

select * from covid_deaths;
alter table covid_deaths drop column reproduction_rate;
alter table covid_deaths drop column icu_patients;

-- initializing the imported tables in the database 
select * from covid_vaccinations;
select * from covid_deaths;

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
select * from covid_deaths;
with rowNumCTE as (select *, row_number() over(partition by continent, location, population, date, 
								total_cases, new_cases, total_deaths, 
                                new_deaths, 
                                hosp_patients order by iso_code ) 
                                as row_num from covid_deaths)
select * from rowNumCTE where row_num > 1; 

-- Checking for null values in each table
-- starting with covid_deaths table
select * from covid_deaths;
select 'iso_code' as column_name, count(*) as null_count
from covid_deaths where iso_code is null
union
select 'continent' as column_name, count(*) as null_count
from covid_deaths where continent is null
union
select 'location' as column_name, count(*) as null_count
from covid_deaths where location is null
union
select 'population' as column_name, count(*) as null_count
from covid_deaths where population is null
union
select 'date' as column_name, count(*) as null_count
from covid_deaths where date is null
union
select 'total_cases' as column_name, count(*) as null_count
from covid_deaths where total_cases is null
union
select 'new_cases' as column_name, count(*) as null_count
from covid_deaths where new_cases is null
union
select 'total_deaths' as column_name, count(*) as null_count
from covid_deaths where total_deaths is null
union
select 'new_deaths' as column_name, count(*) as null_count
from covid_deaths where new_deaths is null
union
select 'hosp_patients' as column_name, count(*) as null_count
from covid_deaths where iso_code is null;

-- For covid vaccinations table
select * from covid_vaccinations;
select 'iso_code' as column_name, count(*) as null_count
from covid_vaccinations where iso_code is null
union
select 'continent' as column_name, count(*) as null_count
from covid_vaccinations where continent is null
union
select 'location' as column_name, count(*) as null_count
from covid_vaccinations where location is null
union
select 'date' as column_name, count(*) as null_count
from covid_vaccinations where date is null
union
select 'total_tests' as column_name, count(*) as null_count
from covid_vaccinations where total_tests is null
union
select 'new_tests' as column_name, count(*) as null_count
from covid_vaccinations where new_tests is null
union
select 'total_vaccinations' as column_name, count(*) as null_count
from covid_vaccinations where total_vaccinations is null
union
select 'peopl_vaccinated' as column_name, count(*) as null_count
from covid_vaccinations where people_vaccinated is null
union
select 'people_full_vaccinated' as column_name, count(*) as null_count
from covid_vaccinations where people_fully_vaccinated is null
union
select 'total_boosters' as column_name, count(*) as null_count
from covid_vaccinations where total_boosters is null
union
select 'new_vaccinations' as column_name, count(*) as null_count
from covid_vaccinations where new_vaccinations is null
union
select 'population' as column_name, count(*) as null_count
from covid_vaccinations where population is null;

-- Removing data redundancy
select distinct continent from covid_deaths;
delete from covid_deaths
where continent = ' ';

select distinct location from covid_deaths;
delete from covid_deaths
where location = 'european union';
delete from covid_deaths where location = 'oceania';
delete from covid_deaths where location = 'high income';
delete from covid_deaths where location = 'low income';
delete from covid_deaths where location = 'North America';
delete from covid_deaths where location = 'South America';


-- SQL Data Exploration
select * from covid_deaths order by 3,4;
select continent, location, population, date, total_cases, total_deaths from covid_deaths
order by 1,2;

-- Generating the key covid indicators
-- 1.Total deaths in Kenya
select * from covid_deaths;
select cast(sum(total_deaths) as signed) as Death_totals 
from covid_deaths where continent is not null and location = 'Kenya';

-- 3.Total covid cases recorded in Kenya up to 2023
select sum(total_cases) as Total_covid_cases
from covid_deaths where continent is not null
and location = 'Kenya';

select * from covid_vaccinations;
desc covid_vaccinations;
-- 4. Total tests conducted across the globe
select cast(sum(total_tests) as signed) as Total_tests_conducted
from covid_vaccinations where continent is not null and location = 'kenya';

-- 5. The total vacccinations given to the people in Kenya in 2021
select convert(sum(total_vaccinations), signed) as Sum_total_vaccinations 
from covid_vaccinations where continent is not null and location = 'Kenya'
and date between '1/1/2021' and '31/12/2021';

-- 6. Average population in Kenya
select * from covid_deaths;
select location, avg(population) as Average_Population
from covid_deaths where continent is not null
and location = 'kenya' group by continent order by location;

-- Checking death percentage across all continents which shows the likelihood of dying after contacting covid
-- Total deaths vs total cases
select continent, location, population, 
date, total_cases, total_deaths, 
convert((total_deaths/total_cases) * 100, 
decimal(7,2))as death_percentage from covid_deaths 
where location = "Kenya"  and total_cases is not null 
order by death_percentage desc;

-- Creating va view
create or replace view total_death_cases as 
select continent, location, population, 
date, total_cases, total_deaths, 
convert((total_deaths/total_cases) * 100, 
decimal(7,2))as death_percentage from covid_deaths 
where location = "Kenya"  and total_cases is not null 
order by death_percentage desc;

-- Calling a view
select * from covid_sql_project.total_death_cases;

-- Looking for percentage of new deaths on a daily basis due to covid
-- new deaths vs new cases
select continent, location, date, new_cases, new_deaths, 
cast((new_deaths/new_cases) *100 as decimal(7, 2)) as new_death_percentage
from covid_deaths where continent is not null and location = 'Kenya'
order by continent desc;

 -- Creating view
 create or replace view new_deaths_cases as
 select continent, location, date, new_cases, new_deaths, 
cast((new_deaths/new_cases) *100 as decimal(7, 2)) as new_death_percentage
from covid_deaths where continent is not null and location = 'Kenya'
order by new_death_percentage desc;

-- Calling the view you have created
select * from covid_sql_project.new_deaths_cases;
 
 
-- The percentage population that got infected by covid 
-- Total cases vs population
select continent, location, population, total_cases, 
cast((total_cases/population)*100 as decimal (7,3)) as percenteg_infected
from covid_deaths where location like "%Ken%" 
and continent is null order by location;

-- The country with the highest rate of infection compared to its population
select * from covid_deaths;
desc covid_deaths;
select continent, location, population, 
max(total_cases) as highest_infection, 
cast(max((total_cases)/population) * 100 as decimal(7,2)) as high_infections
from covid_deaths where continent is not null and location = 'kenya'
 group by continent, location, population 
 order by high_infections desc;

-- Countries with the highest death rate
select * from covid_deaths;
desc covid_deaths;
select location, population, 
convert(max(total_deaths), signed) as highInfections
from covid_deaths 
where continent is not null
group by location, population 
order by highInfections desc;

-- Creating a view
create or replace view high_death_rate as
select location, population, 
convert(max(total_deaths), signed) as highInfections
from covid_deaths 
where continent is not null
group by location, population 
order by highInfections desc;

-- Calling a view
select * from covid_sql_project.high_death_rate;

-- Countries with highest deaths compared to their population
select continent, location, population, 
max(convert(total_deaths, signed)) as high_death_rate
from covid_deaths where continent is not null 
group by continent, location, population
order by high_death_rate desc;

-- Total deaths of deaths per continent
-- Continents with the highest death rate
select continent, max(convert(total_deaths, signed)) 
as total_death_count
from covid_deaths
where continent is not null group by continent
order by total_death_count desc;

-- Total global death percentage by continents
desc covid_deaths;
select continent, total_deaths, sum(cast(total_deaths as signed)) as global_deaths,
sum(convert(total_cases, signed)) as global_cases, 
sum(cast(total_deaths as signed))/sum(convert(total_cases, signed)) * 100 as global_percentage
from covid_deaths
where continent is not null
group by continent, total_deaths order by global_percentage desc, continent desc;

-- Getting the new global numbers of deaths
select continent, sum(new_cases) as world_cases, 
sum(new_deaths) as world_deaths,
convert(sum(new_deaths)/sum(new_cases) * 100, decimal(7,2)) 
as world_deaths_perctage
from covid_deaths where continent is not null
group by continent order by world_deaths_perctage desc;
 
-- The total vaccinations vs population
select * from covid_vaccinations;
desc covid_vaccinations;
select continent, date, location, population, cast(total_vaccinations as signed) as total_vaccinations, 
(cast(total_vaccinations as signed)/population) * 100 as Vaccination_Percy
from covid_vaccinations where continent is not null and location = 'Kenya'
group by continent, date, location, total_vaccinations, population,
(cast(total_vaccinations as signed)/population) * 100
order by (cast(total_vaccinations as signed)/population) desc, total_vaccinations desc;

select *  from covid_vaccinations;
describe covid_vaccinations;

-- People vaccinated vs total vaccines distributed
select continent, location, sum(cast(people_vaccinated as signed)) as people_vaccintd,
sum(cast(total_vaccinations as signed)) as vaccines,
sum(cast(people_vaccinated as signed))/sum(cast(total_vaccinations as signed)) as percent_of_ppl_vacc
from covid_vaccinations
where continent is not null and location = 'Kenya'
group by continent, location order by vaccines desc;

-- The most affected country under each continent in 2021
select * from covid_deaths;
select continent, location, date, total_deaths, first_value(location)
over(partition by continent order by total_deaths desc) 
as most_affected_country
from covid_deaths;

-- Top 3 countries from each continent with the highest deaths
select * from covid_deaths;
select * from (select d.*, rank() 
over(partition by continent order by total_deaths desc) as rnk
from covid_deaths d) x where x.rnk<4;

create or replace view countries_affected as 
select * from (select d.*, rank() 
over(partition by continent order by total_deaths desc) as rnk
from covid_deaths d) x where x.rnk<4;

-- Calling this view
select * from covid_sql_project.countries_affected;

-- the total cases vs total vaccinations
select d.location, d.total_cases, v.total_vaccinations,
max(cast(d.total_cases as signed) )/max(cast(total_vaccinations as signed)) * 100 as Covid_cases 
from covid_deaths d join covid_vaccinations v 
on d.location = v.location where d.continent is not null
group by d.location, d.date, d.total_cases, v.total_vaccinations;

-- Creating a view
create or replace view total_cases_vaccinations as 
select d.location, d.total_cases, v.total_vaccinations,
max(cast(d.total_cases as signed) )/max(cast(total_vaccinations as signed)) * 100 as Covid_cases 
from covid_deaths d join covid_vaccinations v 
on d.location = v.location where d.continent is not null
group by d.location, d.date, d.total_cases, v.total_vaccinations;

-- Calling the view
select * from covid_sql_project.total_cases_vaccinations;