
--correlated subquery examples below
--for all available jobs, find the number of employees with the job title
select j.job_id, j.job_title, e.ct
from jobs j, (
    select job_id, count(*) ct
    from employees 
    group by job_id) e
where j.job_id = e.job_id   --using old sql join technique
and j.job_id like 'S%'
order by 1

--different kind of correlated subquery with the subquery in the select clause
select j.job_id, j.job_title,  
    (select  count(*) ct
    from employees e
    where e.job_id = j.job_id ) ct
from jobs j 
where j.job_id like 'S%'
order by 1

--uses new sql join technique
select j.job_id, j.job_title, e.ct
from jobs j
inner join (
    select job_id, count(*) ct
    from employees 
    group by job_id) e
on j.job_id = e.job_id  
where j.job_id like 'S%'
order by 1

--how many employees are assigned to each department
select d.*, nvl(e.ct,0) ct
from departments d
left join (select department_id, count(*) ct
    from employees
    group by department_id) e
on d.department_id = e.department_id


select e.*, d.department_id, d.avg_sal
from employees e
inner join (select department_id, round(avg(salary),0) avg_sal
from employees
group by department_id) d
on e.department_id = d.department_id
where e.salary > d.avg_sal
    
