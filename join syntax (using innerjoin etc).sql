--outdated, classic join style
select employee_id, first_name, last_name, e.job_id, j.job_title
from employees e, jobs j
where e.job_id = j.job_id
order by 1

--#1 inner join
select employee_id, first_name, last_name, e.job_id, j.job_title
from employees e
inner join jobs j on e.job_id = j.job_id
where employee_id < 109

#2 
select e.employee_id, e.job_id, j.job_title, d.department_name
from employees e
right outer join jobs j on e.job_id = j.job_id
left outer join departments d on d.department_id = e.department_id


--#4 full outer join
select e.employee_id, e.job_id, j.job_title,count(*) over () ttl_ct
from employees e
full outer join jobs j on e.job_id = j.job_id

--19 total rows
select *
from jobs
where not exists (select * from employees e where jobs.job_id = e.job_id)

insert into jobs values ('DRIVER','DRIVER',100,100000);

--below is example of a join with a using clause 
--both table must have a join column with the same name (job_id is common to both tables here)
select employee_id, first_name, last_name,job_id, job_title
from employees e
join jobs j
using (job_id)


--cross join - cross joins are the same as a cartesian product
select e.employee_id, d.department_name
from employees e
cross join departments d


select e.employee_id, e.department_id, d.department_name, e.job_id, j.job_title, count(*) over () ct
from employees e
left join departments d on e.department_id = d.department_id
left join jobs j on e.job_id = j.job_id
