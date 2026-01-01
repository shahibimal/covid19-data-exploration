/*
Project: COVID-19 Data Analysis
Author: Bimal Shahi
Tools: SQL Server, Tableau
Description:
This project analyzes COVID-19 cases, deaths, and vaccinations
using SQL queries and visualizes insights using Tableau.
*/

-- Just a quick check to see if the data imported correctly (filtering out the summaries)
select *
from portfoilioproject..CovidDeaths
where continent is not null
order by location, date;

-- Looking at cases vs deaths on a global timeline
  select date, total_cases, total_deaths
from portfoilioproject..CovidDeaths
order by date, total_cases;

-- Calculating death percentage per country per day
-- Note: Added NULLIF to handle cases where total_cases might be zero to avoid errors
select location, date, total_cases, total_deaths, (total_deaths * 100.0 / NULLIF(total_cases,0)) as death_percentage
from portfoilioproject..CovidDeaths
where continent IS NOT NULL
order by location, date desc;

-- looking what percentage of the population got infected daily
select location, date, population, total_cases, 
(total_cases * 100.0 / NULLIF(population,0)) AS population_infected_percentage
from portfoilioproject..CovidDeaths
where continent IS NOT NULL
order by location, date desc;

-- Which countries had the highest infection rates compared to their population?
select location, population, 
MAX(total_cases) as max_total_cases,
MAX(total_cases * 100.0 / NULLIF(population,0)) as  infection_percentage
from portfoilioproject..CovidDeaths
group by location, population
order by infection_percentage desc;

-- Which countries have the highest death rates per population?
SELECT location, population, 
 MAX(cast(total_deaths as int)) as max_total_deaths,
 MAX(cast(total_deaths as int) * 100.0 / NULLIF(population,0)) as death_percentage
from portfoilioproject..CovidDeaths
group by location, population
order by  death_percentage desc;

-- Breaking it down by Continent to see the total death impact
select continent, 
SUM(cast(total_deaths as int)) as continent_deaths
from portfoilioproject..CovidDeaths
where continent IS NOT NULL
group by continent
order by continent_deaths desc;

-- Getting global numbers per day to see the overall trend line
select date,
SUM(new_cases) AS total_new_cases,
SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(new_cases),0) AS death_percentage
from portfoilioproject..CovidDeaths
where continent IS NOT NULL
group by  date
order by date;

-- Bringing in the Vaccination data to compare with Deaths
select d.continent, d.location, d.date, d.population, v.new_vaccinations
from portfoilioproject..CovidDeaths d
join portfoilioproject..CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where  d.continent  is not null
order by d.location, d.date;

-- Using a Window Function to create a rolling sum of vaccinations per country
select d.continent, d.location, d.date, d.population, v.new_vaccinations
 ,SUM(CAST(v.new_vaccinations as int)) OVER (PARTITION BY d.location order by  d.date) as rolling_vaccinations
from portfoilioproject..CovidDeaths d
join portfoilioproject..CovidVaccinations v
 on d.location = v.location
 and d.date = v.date
where  d.continent is not null
order by  d.location, d.date;

-- Creating a CTE so I can use the newly created 'rolling_vaccinations' column for math
with VaccinationProgress as 
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
 SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location order by d.date) as rolling_vaccinations
 from portfoilioproject..CovidDeaths d
 join portfoilioproject..CovidVaccinations v
        on d.location = v.location
        and  d.date = v.date
    where d.continent is not null
)
select *,
       (rolling_vaccinations * 100.0 / NULLIF(population,0)) as rolling_vaccination_percentage
from VaccinationProgress
order by  location, date;

-- Temporary Table version (sometimes faster for large datasets or testing)
CREATE TABLE #TempVaccinationStats
(
    continent NVARCHAR(300),
    location NVARCHAR(300),
    date DATETIME,
    population FLOAT,
    new_vaccinations NUMERIC,
    rolling_vaccinations NUMERIC
);

INSERT INTO #TempVaccinationStats
select  d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.date) as rolling_vaccinations
from portfoilioproject..CovidDeaths d
join portfoilioproject..CovidVaccinations v
    on d.location = v.location
    AND d.date = v.date
where d.continent IS NOT NULL;

select *,
       (rolling_vaccinations * 100.0 / NULLIF(population,0)) as rolling_vaccination_percentage
from #TempVaccinationStats
order by  location, date;

-- Quick check on daily cases vs vaccinations
select d.location, d.date, d.new_cases, v.new_vaccinations
from portfoilioproject..CovidDeaths d
join portfoilioproject..CovidVaccinations v
	on d.location = v.location AND d.date = v.date
where d.continent IS NOT NULL
order by d.location, d.date;

-- Saving this as a View for my Tableau Dashboard visualizations later
CREATE VIEW PercentPopulationVaccinated as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
 SUM(CAST(v.new_vaccinations AS int)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_vaccinations
FROM portfoilioproject..CovidDeaths d
JOIN portfoilioproject..CovidVaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent IS NOT NULL;

