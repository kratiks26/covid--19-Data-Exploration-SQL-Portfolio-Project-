--1 globally people having at least 1 Vaccine

with sum_of_pop (location, population, people_vaccinated)
as(
select location, max(population) over(partition by location), max(cast(people_vaccinated as bigint)) from covid_data..covid_vaccinations
where continent is not null
group by location, population
)
select sum(population) as total_population, sum(people_vaccinated) as total_vaccination,
sum(people_vaccinated)/sum(population)*100 percentage_of_vaccination from sum_of_pop

--2 globally people fully vaccinated

with sum_of_pop (location, population, people_fully_vaccinated)
as(
select location, max(population) over(partition by location), max(cast(people_fully_vaccinated as bigint)) from covid_data..covid_vaccinations
where continent is not null
group by location, population
)
select sum(population) as total_population, sum(people_fully_vaccinated) as total_vaccination,
sum(people_fully_vaccinated)/sum(population)*100 percentage_of_vaccination from sum_of_pop


--3 continent wise vaccination_count

select continent,sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated
from covid_data..covid_vaccinations
where continent is not null
group by continent
order by people_fully_vaccinated desc
 

--4 country wise people fully vaccinated

with sum_of_pop (location, population, vaccination_count)
as(
select location, max(population), max(cast(people_fully_vaccinated as bigint))  from covid_data..covid_vaccinations
where continent is not null
group by location
)
select location, Population, vaccination_count, vaccination_count/population*100 as Percentage_of_vaccination_count 
from sum_of_pop
where vaccination_count is not null
order by location

--5 country and date wise people fully vaccinated

with sum_of_pop (location, date, population, vaccination_count)
as(
select location, date, max(population), max(cast(people_fully_vaccinated as bigint))  from covid_data..covid_vaccinations
where continent is not null
group by location, date
)
select location, date, Population, vaccination_count, vaccination_count/population*100 as Percentage_of_vaccination_count 
from sum_of_pop
where vaccination_count is not null
order by location




