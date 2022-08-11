select*
 from PortfolioProject..CovidDeaths
 where continent is not null
order by 3,4

--select*
-- from PortfolioProject..Covidvaccinations
--order by 3,4
-- select data that i'm going to be using

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths
-- shows likelihood of dying if contract covid in your country 
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null AND location like'%india%'

-- Looking at total cases vs population
-- shows what percentage of population get covid
select location,date,population,total_cases,(total_cases/population)*100 as percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population 
select location,population,MAX(total_cases) as highestinfectioncount,MAX((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
group by population,location
order by percentpopulationinfected desc

-- showing the country with the highest death count

select location,MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
group by location
order by totaldeathcount desc

-- let's break things down by continents

select continent,MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
group by continent
order by totaldeathcount desc

-- showing the continents with the highest death count per population
select continent,MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like'%india%'
where continent is not null
group by continent
order by totaldeathcount desc


-- GLOBAL NUMBERS
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null
--where location like'%india%'
--group by date
order by 1,2

--looking at total population vs vaccinations
select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
--select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- use cte
with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
--select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *,(rollingpeoplevaccinated/population)*100
from popvsvac

-- TEMP TABLE
drop table if exists #Percentpopulationvaccinated
create table #Percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #Percentpopulationvaccinated
select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
--select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *,(rollingpeoplevaccinated/population)*100
from #Percentpopulationvaccinated 

-- creating view to share data for later visualization
create view Percentpopulationvaccinated as
select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
--select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * 
from Percentpopulationvaccinated