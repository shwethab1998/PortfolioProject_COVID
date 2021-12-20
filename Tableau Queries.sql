-- Queries taken from project portfolio specifically to be used on Tableau

-- Tableau Query 1

Select SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
From PorfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- Tableau Query 2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Tableau Query 3

Select location, MAX(total_cases) AS HighestInfectionCount, population, MAX(total_cases/population)*100 AS InfectedPercentage	
From PorfolioProject..CovidDeaths
Group By location,population
Order by InfectedPercentage Desc

-- Tableau Query 4

Select location, date, MAX(total_cases) AS HighestInfectionCount, population, MAX(total_cases/population)*100 AS InfectedPercentage	
From PorfolioProject..CovidDeaths
Group By location,population, date
Order by InfectedPercentage Desc