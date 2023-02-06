
--1 finding the total_case, total_deaths and total_deaths_percentage

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths ,sum(cast(new_deaths as int))/sum(total_cases)*100 as total_deaths_percentage
from covid_data.dbo.covid_deaths


--2 finding continent wise total Deaths

select continent, sum(cast(new_deaths as int)) as total_deaths from covid_data.dbo.covid_deaths
where continent is not null
group by continent
order by total_deaths desc

--3 finding Location wise Percentage_of_infection

Select continent, Location, Population, sum(new_cases) as total_cases, ( sum(new_cases)/max(population))*100 as Percentage_of_infection
From  covid_data.dbo.covid_deaths
where continent is not null
Group by Location, Population, continent
order by continent,Percentage_of_infection desc

--4 finding percentage of infection date_wise

Select Location, Population, date, sum(new_cases) as total_cases , ( sum(new_cases)/max(population))*100 as Percentage_of_infection
From  covid_data.dbo.covid_deaths
where continent is not null
Group by Location, Population, date
order by Percentage_of_infection desc


