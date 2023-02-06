
-- we have to tables covid_deaths and covid_vaccination

select* from covid_data..covid_deaths order by location,date

select* from covid_data..covid_vaccinations order by location ,date

--(1)-let's just select only those data which we will going to use

select continent, location, date, total_cases, new_cases,total_deaths,population from covid_data..covid_deaths
order by 1,2

--(2)- find out the total percentage of death againts total cases

select location,date,total_cases,cast(total_deaths as int) as total_deaths,(cast(total_deaths as int)/total_cases)*100 as total_death_percentage 
from covid_data..covid_deaths
order by 1,2


--(3)- finding the total cases VS population or percentage of infection

select location, date, total_cases, population, total_cases/population*100 as Per_of_infections from covid_data..covid_deaths
order by 1,2

--(4)- countries with higher infection percentage compare to population

select  location, max(total_cases) as max_cases , population, (max(total_cases)/population)*100 as per_of_infection
from covid_data..covid_deaths
where continent is not null
group by location, population
order by  4 desc


--(5)- continent with  max cases as per population

select continent, max(total_cases) as max_cases, max(population), (max(total_cases)/max(population))*100 as per_of_infection
from covid_data..covid_deaths
where continent is not null
group by continent
order by 3 desc

--(6)- countries with higher deaths percentage as per total cases

select location,max(cast(total_deaths as int)) as max_deaths, max(total_cases)  max_cases, (max(cast(total_deaths as int))/ max(total_cases))*100 as per_of_deaths
from covid_data..covid_deaths
where continent is not null
group by location
order by 4 desc

--(7)- continent with highest death percentage as per total cases

select continent, max(cast(total_deaths as int)) as max_deaths, max(total_cases) as max_cases,(max(cast(total_deaths as int))/max(total_cases))*100 as per_of_deaths
from covid_data..covid_deaths
where continent is not null
group by continent
order by 4 desc

--(8)- let's find the sum of cases, deaths and the Percentage of deaths date wise globally

select sum(new_cases) as total_cases, sum(cast(total_deaths as bigint)) as total_deaths, sum(cast(total_deaths as bigint))/sum(new_cases)*100 as per_of_deaths
from covid_data..covid_deaths

--(9)- now let's just join two table then Query them

select * 
from covid_data..covid_deaths as d join covid_data..covid_vaccinations as v
on d.location=v.location and d.date=v.date


--(10)- finding location and Date wise total vaccination and percentage of vaccination 

select d.continent,d.location,d.date,d.population, v.new_vaccinations, 
sum(cast(v.new_vaccinations as bigint)) over (partition by v.location  order by v.location,v.date) as rolling
from covid_data..covid_deaths as d join covid_data..covid_vaccinations as v
on d.location=v.location and d.date=v.date
order by d.location


--(11)- finding location wise total vaccination, population and percentage of vaccination

with popandvac( location, population, total_vaccination)
as
(
select d.location,d.population, sum(cast(v.new_vaccinations as bigint)) over (partition by d.location) as total_vaccinations
from covid_data..covid_deaths as d join covid_data..covid_vaccinations as v
on d.location=v.location and d.date=v.date
where d.continent is not null
group by d.location,d.population,v.new_vaccinations
)
select *, total_vaccination/population*100 as per_of_vaccination
from popandvac
group by location, population,total_vaccination


--(12)- we can also do the same thing by making a temperory table

create table covid_data..temp_table(
location nvarchar(255),
population numeric,
total_vaccinations numeric)

insert into covid_data..temp_table
select d.location,d.population, sum(cast(v.new_vaccinations as bigint)) over (partition by d.location) as total_vaccinations
from covid_data..covid_deaths as d join covid_data..covid_vaccinations as v
on d.location=v.location and d.date=v.date
where d.continent is not null
group by d.location,d.population,v.new_vaccinations

select *, (total_vaccinations/population)*100 as per_of_vaccinated from covid_data..temp_table
group by location, population,total_vaccinations

