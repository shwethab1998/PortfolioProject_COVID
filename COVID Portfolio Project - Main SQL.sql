SELECT *
FROM PorfolioProject..CovidDeaths
Where continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PorfolioProject..CovidVaccines
--ORDER BY 3,4

-- Selecting the data that we will be using:

Select location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject..CovidDeaths
Order By location;

-- Total Covid Cases v/s Total Deaths: Shows the liklihood of death on contracting covid in specific countries

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percenatage
From PorfolioProject..CovidDeaths
Where location LIKE '%India%' --location name can be altered based on need
Order By location

-- Looking into Total Cases with respect to population: Shows % of population affected by COVID

Select location, date, total_cases, population, (total_deaths/population)*100 AS InfectedPercentage
From PorfolioProject..CovidDeaths
Where location LIKE '%India%' --location name can be altered based on need
Order By location

-- Countries with highest infection rate with respect to population

Select location, MAX(total_cases) AS HighestInfectionCount, population, MAX(total_cases/population)*100 AS InfectedPercentage	
From PorfolioProject..CovidDeaths
Group By location,population
Order by InfectedPercentage Desc

-- Countries with highest death rate with respect to population

Select location, MAX(cast(total_deaths AS INT)) AS HighestDeathRate
From PorfolioProject..CovidDeaths
Where continent IS NOT NULL  --To remove the locations which took the name of the continent since it was NULL
Group By location
Order by HighestDeathRate desc

-- Continents with the highest death rate with respect to population

Select continent, MAX(cast(total_deaths AS INT)) AS HighestDeathRate
From PorfolioProject..CovidDeaths
Where continent IS NOT NULL  --To remove the locations which took the name of the continent since it was NULL
Group By continent
Order by HighestDeathRate desc

-- Global Numbers

Select SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
From PorfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- Total Population v/s Vaccinations: Population% that has received atleast 1 vaccine dose

Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.date) AS RollingPeopleVaccinated
From PorfolioProject..CovidDeaths dea
Join
	PorfolioProject..CovidVaccines vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent IS NOT NULL
order by 2,3


-- Creating View to store data for later visualizations


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PorfolioProject..CovidDeaths dea
Join
PorfolioProject..CovidVaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

