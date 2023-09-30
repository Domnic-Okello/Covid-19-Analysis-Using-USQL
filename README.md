# Covid-19-Analysis-Using-USQL
This is SQL data cleaning and manipulation of the covid-19 data.
Covid-19 Analysis in Kenya Using SQL
The first case of corona virus in Kenya was reported in March 2020. A few months later, the government asked the citizens to adhere to strict containment measures such as a social distance, washing their hands frequently, using hand-sanitizers and no gatherings.
This article provides a detailed analysis of covid-19 dataset from online platform. You can make some insights from the analysis and make your profound decisions regarding corona virus.

**Project Approach**
I downloaded this Corona virus pandemic (Covid-19) dataset from OurWorldindata. It contains all the information regarding corona virus. I subdivided the data to create two tables (covid-vaccinations and covid-deaths). 

**Data Cleaning in SQL**
Before you embark on any data analysis, it is imperative to ensure that your dataset is clean, readable and reliable. 
The process of data cleaning involves the process of removing unwanted columns, handling missing values, curating inconsistencies and formatting your data for comprehensive analysis. 
In this project, I carefully cleaned and transformed the dataset to align with the integrity and accuracy of your findings.

**Removing Unwanted Columns**
We start by removing the columns from the both tables that are 
_select * from covid_vaccinations;
alter table covid_vaccinations drop column life_expectancy;
alter table covid_vaccinations drop column cardiovasc_death_rate;
alter table covid_vaccinations drop column diabetes_prevalence;
select * from covid_deaths;
alter table covid_deaths drop column reproduction_rate;
alter table covid_deaths drop column icu_patients;_
This query removes all the unnecessary columns from both tables. For instance, in the covid deaths table the following columns were deleted, reproduction-rate and icu-patients. 
In addition, the following columns were dropped from covid vaccinations table such as life-expectancy, cardiovasc-death rate and diabetes prevalence.

**Initializing the Covid-SQL-Project**
After dropping all the unwanted columns, let’s initialize the covid deaths and covid vaccination tables for further proper data cleaning and later manipulation.
select * from covid_deaths;
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/71728530-29e9-4ced-b708-8a35aa721b9b)

select * from covid_vaccinations;
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/a42675cb-77fa-4b81-925d-d58dc5ddb7fe)

**Checking for Duplicates**
Let’s check for duplicates in the rows using common table expressions (CTEs) and row number.
_with rowNumCTE as (select *, row_number() over(partition by continent, location, population, date, 
		    total_cases, new_cases, total_deaths, 
                            new_deaths, 
                            hosp_patients order by iso_code ) 
                            as row_num from covid_deaths)
select * from rowNumCTE where row_num > 1;_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/4a7d32c3-9b00-40fc-ab88-fc90e4c7d58b)
 
_with row_num_CTE as (select *, row_number() 
over(partition by continent, location, date, total_tests, new_tests, total_vaccinations, people_vaccinated, new_vaccinations, people_fully_vaccinated order by iso_code) as         row_num from covid_vaccinations)
 select * from row_num_CTE where row_num > 1;_
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/287c1593-f37f-49fd-a855-f8ad900de696)
    
These queries return empty tables, an indication that there are no duplicate rows.

**Checking for Null Values**
Let’s find out the columns with null values from both tables. If there is any, then will find a way to replace it.

**Starting with covid_deaths table**
_select * from covid_deaths;
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
select 'total_deaths' as column_name, count (*) as null_count
from covid_deaths where total_deaths is null
union
select 'new_deaths' as column_name, count (*) as null_count
from covid_deaths where new_deaths is null
union
select 'hosp_patients' as column_name, count(*) as null_count
from covid_deaths where iso_code is null;_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/16abc9ea-c2bb-42fb-a078-3bbef9dd987d)

-- **For covid vaccinations table**
_select * from covid_vaccinations;
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
from covid_vaccinations where population is null;_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/63566caf-e6a8-4508-99fb-ddca1a06599d)

There are no null values from both tables and therefore the data is ready for comprehensive data manipulation.
The data is now clean and ready for exploration.

**Data Manipulation**
We are going to answer various questions related to covid-19 pandemic.

**1.	What is the number of total deaths in Kenya due to covid-19 as at 2023?**
_select cast(sum(total_deaths) as signed) as Death_totals 
from covid_deaths where continent is not null and location = 'Kenya';_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/a91f0392-ec24-441d-abb2-c02df21e9f2a)

 This indicates that a total number of 4751907 people lost their lives since March of 2020.
 
**2.	What is the total number of corona virus infection cases recorded up to 2023**
_select sum(total_cases) as Total_covid_cases
from covid_deaths where continent is not null
and location = 'Kenya';_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/2a7aea0f-ff96-4426-aca5-152596171101)

 This query shows that a total number of 271093945 people were infected with corona virus since 2020.
 
**3.	What was the total number of covid-19 tests conducted in Kenya for the past three years?**
_select cast(sum(total_tests) as signed) as Total_tests_conducted
from covid_vaccinations where continent is not null and location = 'kenya';_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/de00f92d-0cd2-4c50-ab3f-5404ca1d24d5)

 The query above shows that the government of Kenya conducted approximately 255448353 tests in 3 years.
 
**4.	What is the total number of vaccinations were given to people of Kenya in 2021?**
_select convert(sum(total_vaccinations), signed) as Sum_total_vaccinations 
from covid_vaccinations where continent is not null and location = 'Kenya'
and date between '1/1/2021' and '31/12/2021';_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/be9c3b87-42fe-4ae9-8547-60c86e1c3865)

 In 2021, the government provided a total of 1536387074 vaccinations to the people against covid-19 virus.
 
**5.	What is the percentage likelihood of dying from covid infection in Kenya?**
_select continent, location, population, 
date, total_cases, total_deaths, 
convert((total_deaths/total_cases) * 100, 
decimal (7,2)) as death_percentage from covid_deaths 
where location = "Kenya" and total_cases is not null 
order by death_percentage desc;_
![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/fb26b650-334b-4835-8398-37cf4c17b331)

 According to this query, it shows that in 27th April 2020 a total case of covid-19 tests conducted were 28 and 4 people died on that day. This is an indication that possibility of dying was at 14.29 percent.
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/559f5179-e43e-4271-a37a-6aac8f7caa56)

 In 2023, the possibility of dying of covid-19 is 1.65 percent.
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/c19b5602-bead-4c58-91a7-5d30c1d7751e)

Moreover, at the beginning of 2020, the possibility of dying of covid was at 0.00 percent.

**6.	Which country has the highest rate of covid-19 infection?**
_select continent, location, population, 
max(total_cases) as highest_infection, 
cast(max((total_cases)/population) * 100 as decimal (7,2)) as high_infections
from covid_deaths where continent is not null
 group by continent, location, population 
 order by high_infections desc;_
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/ed8febcf-64e8-4907-bd6e-68938a81202a)

 According to this data and query, Cyprus had the highest infection rate at 73.76 percent while North Korea and Turkmenistan had the lowest infection rate of 0.00 percent.
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/8de979df-8b55-43f9-8888-2dc9e322fb60)
 
_select continent, location, population, 
max(total_cases) as highest_infection, 
cast(max((total_cases)/population) * 100 as decimal(7,2)) as high_infections
from covid_deaths where continent is not null and location = 'kenya'
 group by continent, location, population 
 order by high_infections desc;_
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/e8bfd746-d426-412f-8727-39c9e08eb384)

 Kenya had infection of 0.64 percent.
 
**7.	What was the new global deaths rate in each continent on daily basis?**
_select continent, sum(new_cases) as world_cases, 
sum(new_deaths) as world_deaths,
convert(sum(new_deaths)/sum(new_cases) * 100, decimal(7,2)) 
as world_deaths_perctage
from covid_deaths where continent is not null
group by continent order by world_deaths_perctage desc;_
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/87e6263c-dc89-44cd-b72e-cf2753cd2e48)

In the query above, it shows that Africa was highly affected by corona virus, where the death rate was at 1.98 percent, followed by South America. 
Least affected continent was Oceania where the death rate was at 0.20 percent.

**8.	Which were the top 3 countries affected by covid-19 under each continent?**
_select * from covid_deaths;
select * from (select d.*, rank() 
over(partition by continent order by total_deaths desc) as rnk
from covid_deaths d) x where x.rnk<4;_
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/a32bef59-de23-4bb1-89d5-8f4cf6f9c115)

In this query, it shows that South Africa was greatly affected by corona virus pandemic in African continent. In Asia, Azerbaijan and Israel countries were highly affected, as in European continent, Belgium, Switzerland and Bosnia were the top three countries to be affected by covid-19 pandemic.
 ![image](https://github.com/Domnic-Okello/Covid-19-Analysis-Using-USQL/assets/122968992/644bb840-610d-47e2-af73-15c98cdb5986)

Moreover, United States was highly affected by covid-19 than other countries in North American continent., while in South America, the top 3 countries that were highly affected were Colombia, Bolivia and Guyana.
Lastly, Australia and New Zealand were the countries in Oceania that were mostly affected by this deadly pandemic.
