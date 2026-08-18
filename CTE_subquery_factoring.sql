--CTE, 
with job_ct as (
    select job_id, count(*) ct
    from employees 
    group by job_id) 
select j.job_id, j.job_title, job_ct.ct
from jobs j
inner join job_ct on j.job_id = job_ct.job_id
where j.job_id like 'S%'
order by 1

--CTE with recursive query
--below shows employees and their manager name

WITH cteEmp (employee_id, first_name, manager_id, emplevel) AS (
  SELECT employee_id, first_name, manager_id, 1
  FROM employees
  WHERE manager_id IS NULL
  union all
SELECT e.employee_id, e.first_name, e.manager_id, r.emplevel + 1
  FROM employees e
  INNER JOIN cteEmp r
  ON e.manager_id = r.employee_id
  )
SELECT employee_id,first_name,manager_id,emplevel
FROM cteEmp
ORDER BY emplevel;


--show every employee along with the number of emps in their department
with dept_ct as (
    select d.department_id, d.location_id, l.city,l.state_province, count(*) ct
    from departments d
    inner join locations l on d.location_id = l.location_id
    group by d.department_id, l.location_id, l.city, l.state_province)
select e.department_id, dept_ct.location_id, dept_ct.ct
from employees e
inner join dept_ct on e.department_id = dept_ct.department_id

with job_ct as (
    select job_id, count(*) ct
    from employees 
    group by job_id) 
select j.job_title, job_ct.ct
from jobs j
inner join job_ct 
on j.job_id = job_ct.job_id;

--select all departments and number of employees for each department
with
    d_ct as (
        select department_id, count(*) ct
        from employees
        group by department_id
        )
select d.department_id, d.department_name, nvl(d_ct.ct,0) ct
from departments d
left join d_ct on d.department_id = d_ct.department_id
order by ct desc

--below is an example of how to use nulls first/last in an order by clause
--note:only 1 employee is not assigned to a department
select e.employee_id, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
order by e.department_id nulls first


with d_ct as (
    select department_id, count(*) dept_ct
    from employees 
    group by department_id)
select e.*, d.department_name, nvl(d_ct.dept_ct,0) dept_ct
from employees e
inner join d_ct on e.department_id = d_ct.department_id
inner join departments d on e.department_id = d.department_id
order by e.department_id nulls first


select e.employee_id, d.department_name, j.job_title, count(*) over ()
from employees e,departments d, jobs j
where e.department_id = d.department_id
and e.job_id = j.job_id


with emp_ct as (
    select department_id, count(*) ct
    from employees 
    group by department_id
)
select e.employee_id, e.last_name, e.department_id, d.department_name, emp_ct.ct dept_ct, count(*) over () ttl_ct
from employees e
left join departments d on e.department_id = d.department_id
left join emp_ct on e.department_id = emp_ct.department_id
order by e.department_id nulls first

--subquery factoring from memory (it works)
with job_ct as (
    select job_id, count(*) ct
    from employees
    group by job_id)
select e.employee_id, first_name,e.last_name, e.job_id, jc.ct, count(*) over () ttl_ct
from employees e
inner join job_ct jc on e.job_id = jc.job_id
