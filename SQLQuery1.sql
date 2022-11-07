select *from dbo.dataset1
select *from dbo.dataset1

select count(*) from dbo.dataset1
select count(*) from dbo.dataset2

--select dataset for jarkhand and bihar
select *from dbo.dataset1 where state in ('Jharkand','Bihar')

--population of india
select *from dbo.dataset2
select sum(Population) from dbo.dataset2

--The avaerage growth of india
select avg(Growth)*100 as average_growth from dbo.dataset1

select state, avg(Growth)*100 as average_growth from dbo.dataset1
group by State

--avg sex ratio
select avg(sex_ratio) from dbo.dataset1
select state,round(avg(sex_ratio),0) as avg_sex_ratio from dbo.dataset1 group by State
order by State

--avg literacy rate
select State, round(avg(Literacy),0) as avg_literacy from dbo.dataset1 group by State 
 having round(avg(literacy),0)>90 order by 
avg_literacy 

--top 3 state
select top 3 State,avg(Sex_Ratio)*100  as avg_growth from dbo.dataset1
group by state 

--bottom 3 state with lowest sex ration
select top 3 State,round(avg(Sex_Ratio),0)   avg_sex_ratio from dbo.dataset1
group by state order by avg_sex_ratio asc

--top and bottom 3 states in literacy rate

create table #topstates
(
state  varchar(255),
topstates float
)

insert into #topstates
select top 3 State,round(avg(sex_ratio),0) avg_sex_ratio
from dbo.dataset1 group by state order by avg_sex_ratio asc;

select *from #topstates


create table #topliteracyrate1
(
state varchar(255),
literacyrate float
)
select *from #topliteracyrate1

select *from dbo.dataset1
insert into #topliteracyrate1
select State,round(avg(Literacy),0) avg_literacy_rate from dbo.dataset1
group by State order by avg_literacy_rate desc

select distinct state from dbo.dataset1 where lower(State) like '%a'
or lower(State) like 'b%'

select *from #topliteracyrate1
select *from dbo.dataset1
select *from dbo.dataset2

--joining the tables
--total males and females in population

select d.State, sum(d.males) total_males,sum(d.females) total_females from
(select c.District,c.State,round(c.Population/(c.Sex_ratio+1),0) males,round((c.Population*c.Sex_ratio)/(c.Sex_ratio+1),0) females from

(select a.District,a.State,Sex_ratio/1000 sex_ratio,b.Population from dbo.dataset1 a inner join
dbo.dataset2 b  on a.District=b.District) c) d group by d.State;


--total literacy rate

select *from dbo.dataset1
select *from dbo.dataset2

select c.District,c.State,c.literacy_ratio*c.Population literate_people,(1-c.literacy_ratio)*c.Population illiterate_people
from
(select a.District,a.State,a.Literacy/100 literacy_ratio, Population from  dbo.dataset1 a
inner join dbo.dataset2 b on  b.District=a.District) c order by c.literacy_ratio

--total lieracy rate
select d.State, sum(literate_people) total_literate from 
(select c.District,c.State,round(c.literacy_ratio*c.Population,0) literate_people,round((1-c.literacy_ratio)*c.Population,0) illiterate_people
from
(select a.District,a.State,a.Literacy/100 literacy_ratio, Population from  dbo.dataset1 a
inner join dbo.dataset2 b on  b.District=a.District) c ) d group by d.State

--population in previous census

select d.District,d.State, round(d.Population/(1+d.Growth),0) previous_census_pupulation,d.Population current_poulation from 
(	
select a.District,a.State,a.Growth, Population from dbo.dataset1 a
inner join dbo.dataset2 b on b.District=a.District) d 


--sum of population
select sum(e.previous_census_pupulation+ e.current_poulation) as total_population  from(
select d.District,d.State, round(d.Population/(1+d.Growth),0) previous_census_pupulation,d.Population current_poulation from 
(	
select a.District,a.State,a.Growth, Population from dbo.dataset1 a
inner join dbo.dataset2 b on b.District=a.District) d ) e group by e.State