SELECT * 
FROM covid19death.`covid19  deaths`
WHERE continent is not null
ORDER BY 3;

SELECT *
FROM covid_vaccination.`covid19 vaccination`
WHERE continent is not null
ORDER BY 3;




-- Select data that we are going to be using

SELECT location,date,new_cases,total_cases,total_deaths,population
FROM covid19death.`covid19  deaths`
ORDER BY 1;




-- Looking at Total Deaths vs Total Cases

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM covid19death.`covid19  deaths`
ORDER BY 1;




-- Looking at Total Cases vs Population

SELECT location,date,population,total_cases,(total_cases/population)*100 AS Population_Percentage
FROM covid19death.`covid19  deaths`
ORDER BY 1;




-- Looking at Countries with Highest infections rate compared to the population

SELECT location,population,MAX(CAST(total_cases AS UNSIGNED)) AS Highest_Infection_count,MAX((CAST(total_cases AS UNSIGNED)/population))*100 AS Percent_Population_infected
FROM covid19death.`covid19  deaths`
GROUP BY location,population
ORDER BY Percent_Population_infected DESC;




-- Looking at Countries with Highest death rate compared to the population

SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS Total_death_count
FROM covid19death.`covid19  deaths`
WHERE continent IS NOT NULL
    AND location NOT IN ('Europe', 'High income', 'Low income','European Union')
GROUP BY location
ORDER BY Total_death_count DESC;




-- Looking at continent with highest death rate compared to the population

SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS Total_death_count
FROM covid19death.`covid19  deaths`
WHERE continent IS NOT NULL
    AND TRIM(continent) != ''  -- Exclude rows where continent is an empty string
GROUP BY continent
ORDER BY Total_death_count DESC;




-- Global Numbers 

SELECT date,sum(new_cases) as total_cases,sum(CAST(new_deaths AS UNSIGNED))as total_deaths,SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_cases)*100 AS Death_Percentage
FROM covid19death.`covid19  deaths`
WHERE continent IS NOT NULL
    AND TRIM(continent) != ''  -- Exclude rows where continent is an empty string 
GROUP BY date;




-- Looking at Total Population vs Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM covid19death.`covid19  deaths` AS dea
JOIN covid_vaccination.`covid19 vaccination` as vac
 ON dea.location=vac.location
 AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
    AND TRIM(dea.continent) != ''  -- Exclude rows where continent is an empty string 
ORDER BY 3;


SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER ( PARTITION BY dea.location ORDER BY dea.location,dea.date ) as Rolling_people_vaccinated
FROM covid19death.`covid19  deaths` AS dea
JOIN covid_vaccination.`covid19 vaccination` as vac
 ON dea.location=vac.location
 AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
    AND TRIM(dea.continent) != ''  -- Exclude rows where continent is an empty string 
ORDER BY 3,2;




-- Use CTE

With PopvsVac (Continent,Location,Date,Population,New_Vaccinations,Rolling_people_vaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(vac.new_vaccinations) OVER ( PARTITION BY dea.location ORDER BY dea.location,dea.date ) as Rolling_people_vaccinated
FROM covid19death.`covid19  deaths` AS dea
JOIN covid_vaccination.`covid19 vaccination` as vac
 ON dea.location=vac.location
 AND dea.date=vac.date
WHERE dea.continent is not null
-- ORDER BY 2,3
)
Select *,(Rolling_people_vaccinated/Population)*100 AS Vaccinated
FROM PopvsVac;




-- Temp Table

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    Rolling_people_vaccinated NUMERIC
);
INSERT INTO PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    STR_TO_DATE(dea.date, '%m-%d-%Y') AS Date, -- Convert the date to the correct format
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
FROM
    covid19death.`covid19  deaths` AS dea
JOIN covid_vaccination.`covid19 vaccination` AS vac
ON
    dea.location = vac.location
    AND STR_TO_DATE(dea.date, '%m-%d-%Y') = STR_TO_DATE(vac.date, '%m-%d-%Y') -- Convert the date to the correct format
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2, 3;
SELECT *, (Rolling_people_vaccinated / Population) * 100 AS Vaccinated
FROM
    PercentPopulationVaccinated;
    
    
    

-- Creating view to store data for later visualization

-- DROP TABLE IF EXISTS PercentPopulationVaccinated;
Create View PercentPopulationVaccinated as
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
FROM
    covid19death.`covid19  deaths` AS dea
JOIN covid_vaccination.`covid19 vaccination` AS vac
ON
    dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;
-- ORDER BY
 --   2, 3;
 
 SELECT *
 FROM PercentPopulationVaccinated
 ORDER BY location
