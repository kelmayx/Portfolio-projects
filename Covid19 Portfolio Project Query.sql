--DATA EXPLORATION COVID 19

--JOINS, CTE, TEMP TABLE, WINDOWS FUNCTION, AGGREGATE FUNCTIONS, CREATING VIEWS, DATA TYPE CONVERTION

-- Basic SELECT

Select *
From dbo.Covid_deaths

Select continent, location
From dbo.Covid_deaths

Select *
From dbo.Covid_deaths
Where continent is not null 


--Selecting multiple columns

Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.Covid_deaths
Where continent is not null 
order by 1,2


-- Total Cases and Total Deaths AVG (PHILIPPINES)
-- Shows death percentage of people got infected

Select Location, date, total_cases,total_deaths, ROUND((cast(total_deaths as float))/(cast(total_cases as float))*100, 2) as DeathPercentage
From dbo.Covid_deaths
Where location like '%Philippines'
order by 2



-- Total Cases and Population AVG (PHILIPPINES)
-- Shows percentage of population who got infected with Covid

Select Location, date, Population, total_cases, ROUND((total_cases/population)*100, 3) as PercentPopulationInfected
From dbo.Covid_deaths
Where location like '%Philippines'
order by 2


-- PHILIPPINES highest infection number and infection rate

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.Covid_deaths
Where location like '%Philippines'
Group by Location, Population


-- PH total death count

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.Covid_deaths
Where location like '%Philippines'  
Group by Location


-- Death Count BY CONTINENT
-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.Covid_deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL death percentage from total cases

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.Covid_deaths
where continent is not null 
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.Covid_deaths dea
Join dbo.Covid_vaccs vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.continent
	, dea.Date) as RollingPeopleVaccinated
From dbo.Covid_deaths dea
Join dbo.Covid_vaccs vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.Covid_deaths dea
Join dbo.Covid_vaccs vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select distinct continent, population, new_vaccinations, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.Covid_deaths dea
Join dbo.Covid_vaccs vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From dbo.Covid_deaths dea
Join dbo.Covid_vaccs vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and vac.new_vaccinations is not null
--and dea.location not in ('World', 'European Union', 'Low income', 'Upper middle income', 'Lower middle income', 'High income')
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated

