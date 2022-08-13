/*

data for dashboard 

*/

--1
-- GLOBAL NUMBERS
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from PortfolioProject1..CovidDeaths
where continent is not null
--where location like'%india%'
--group by date
order by 1,2


--2

--we take thses out as they are not include in the above quaries and want to stay consistent 
-- European Union is part of Europe

select location,sum(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject1..CovidDeaths
--where location like'%india%'
where continent is null
and location not in('World','European Union','International','Upper middle income','High income','Lower middle income','Low income')
group by location
order by totaldeathcount desc

--3
select location,population,MAX(total_cases) as highestinfectioncount,MAX((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject1..CovidDeaths
--where location like'%india%'
group by location,population
order by percentpopulationinfected desc

--4

select location,population,date,MAX(total_cases) as highestinfectioncount,MAX((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject1..CovidDeaths
--where location like'%india%'
group by location,population,date
order by percentpopulationinfected desc