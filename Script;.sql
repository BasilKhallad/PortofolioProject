-- Select Data to be used

select Location, date, total_Cases, New_cases, total_deaths, population
from coviddeaths 
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania',
'Lower middle income', 'European Union', 'Africa')
order by 1, 2;

-- Looking at Death Percentage
-- Shows Likelihood of Death upon contraction of COVID within a country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from coviddeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
order by 1, 2;

-- Contraction Percentage based on population

select Location, date, total_cases, population, (total_cases/population) * 100 as ContractionPercentage
from coviddeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
order by 1, 2;

-- Countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as ContractionPercentage
From CovidDeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania',
'Lower middle income', 'European Union', 'Africa')
Group by Location, Population
order by ContractionPercentage desc;

-- Countries with Highest Death Count per Population

Select Location, population, MAX(total_deaths) as TotalDeaths
From CovidDeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Lower middle income', 'European Union', 
'Africa', 'Oceania')
Group by Location, population 
order by TotalDeaths desc;

-- Continents with Highest Death Count per Population

Select location, population, MAX(total_deaths) as TotalDeaths
From CovidDeaths
WHERE Location IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Lower middle income', 'European Union',
'Africa', 'Oceania')
Group by Location, population 
order by TotalDeaths desc;

-- GLOBAL NUMBERS --
-- Total Deaths/Cases and Death Percentage of Each Country

SELECT Location, MAX(total_cases) AS TotalCases, MAX(total_deaths) AS TotalDeaths, (MAX(total_deaths)/MAX(total_cases)) * 100 AS DeathPercentage
FROM coviddeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
AND total_cases IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY Location
ORDER BY Location;

-- Deaths Per Date

select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths
from coviddeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
-- and total_cases is not null and total_deaths is not null
group by `date` 
order by 1, 2;

-- Deaths Per Date with Death Percentage

Select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths,
SUM(new_deaths)/SUM(New_Cases) *100 as DeathPercentage
From CovidDeaths
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
Group By date
order by 1, 2;

-- Percentage of Vaccination compared to total population

select deaths.location, deaths.`date`, deaths.population, vax.new_vaccinations
from coviddeaths Deaths
join covidvaccinations Vax 
on deaths.location = vax.location 
and deaths.`date` = vax.`date` 
WHERE deaths.Location IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
-- group by deaths.location, deaths.`date`, Deaths.population ,vax.new_vaccinations
order by 1, 2, 3;

-- Total Population compared to Total Vaccinations

Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (Partition by deaths.Location order by deaths.location, deaths.date)
as RollingVaccinationsPerLocation
From CovidDeaths deaths
Join CovidVaccinations vax
On deaths.location = vax.location
and deaths.date = vax.date
WHERE deaths.Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
order by 1, 2;

-- Vaccination Per Location Percentage (CTE)

With PopVac (location, date, Population, New_vaccinations, RollingVaccinationsPerLocation)
as 
(
Select deaths.location, deaths.date, deaths.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (Partition by deaths.Location order by deaths.location, deaths.date)
as RollingVaccinationsPerLocation
From CovidDeaths deaths
Join CovidVaccinations vax
On deaths.location = vax.location
and deaths.date = vax.date
WHERE deaths.Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania', 
'Lower middle income', 'European Union', 'Africa')
order by 1, 2
)
select *, (RollingVaccinationsPerLocation)/population * 100 as RollingVaccinationsPerLocationPercentage
from PopVac;

-- Views for visualizations

-- General Data

Create view GeneralData as
select Location, date, total_Cases, New_cases, total_deaths, population
from coviddeaths 
WHERE Location not IN ('World', 'High Income',
'Upper middle income','Europe', 
'Asia', 'North America', 
'South America', 'Oceania',
'Lower middle income', 'European Union', 'Africa')
order by 1, 2;
Select * from GeneralData


