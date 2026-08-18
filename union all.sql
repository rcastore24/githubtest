--UNION operator
--20 rows=>19 from employees and 1 from jobs(I added the job id DRIVER), all duplicates removed
select  job_id --, count(*), sum(count(*)) over () ttl_ct
from employees
group by job_id
union
select job_id
from jobs
group by job_id

--UNION ALL operator
--39 rows=>19 rows from employees and 20 rows from jobs, no duplicates removed
select  job_id --, count(*), sum(count(*)) over () ttl_ct
from employees
group by job_id
union all
select job_id
from jobs
group by job_id

--INTERSECT operator
--19 rows 
select  job_id
from employees
group by job_id
intersect
select job_id
from jobs
group by job_id

--MINUS operator
--1 row returned=>my new DRIVER record that I created and is unassigned to any employee
select  job_id
from jobs 
group by job_id
minus
select job_id
from employees
group by job_id


--below are me practicing subqueries
select j.job_id, nvl(e.ct, 0) ct
from jobs j
left outer join (
    select job_id, count(*) ct
    from employees 
    group by job_id) e on j.job_id = e.job_id
    
select j.job_id, (select count(*) from employees e where e.job_id = j.job_id) ct
from jobs j
    