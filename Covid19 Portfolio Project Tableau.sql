-- Tableau Portfolio

--1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.Covid_deaths
where continent is not null 
order by 1,2


--2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From dbo.Covid_deaths
Where continent is null 
and location not in ('World', 'European Union', 'Low income', 'Upper middle income', 'Lower middle income', 'High income')
Group by location
order by TotalDeathCount desc


--3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.Covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc


--4

Select Location,Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.Covid_deaths
Where location like '%philippines%'
Group by Location, Population, date
order by PercentPopulationInfected desc

--5

Select location, date, SUM(cast(new_deaths as int)) as TotalDeathCount, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.Covid_deaths
Where continent is null
and location not in ('World', 'European Union', 'Low income', 'Upper middle income', 'Lower middle income', 'High income')
Group by location, date
order by PercentPopulationInfected desc, Date desc



SELECT
    Continent,
    SUM(Population) AS TotalPopulation
FROM
    dbo.Covid_Deaths
WHERE
    Continent IN ('Asia', 'Africa', 'Europe', 'Oceania', 'North America', 'South America') 
GROUP BY
    Continent;

