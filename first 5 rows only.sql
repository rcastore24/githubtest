--old school way to select first 5 rows 
--
select *
from (
select rownum, ct.*
from (
    select job_id,  count(*)
    from employees
    group by job_id
    having count(*) > 1
    order by count(*) desc) ct)
where rownum <= 5

--newer (12c or later) way to get the  first 5 rows
select *
from (
    select job_id,  count(*)
    from employees
    group by job_id
    having count(*) > 1
    order by count(*) desc) ct
fetch first 5 rows only

--used offset clause below to exclude first 3 rows then display the next 5 rows
select *
from (
select job_id,  count(*)
from employees
group by job_id
having count(*) > 1
order by count(*) desc) ct
offset 3 rows fetch first 5 rows only

select *
from emp
order by sal desc
fetch first 50 percent rows only

--fetch top 2 salaries
--use WITH TIES clause to pull additional duplicate value rows
select empno, sal
from emp
order by sal desc
fetch first 2 rows  with ties

select *
from employees
order by salary desc
fetch first 2 rows with ties

--another way to get this info is using analytic function dense_rank
select * from (
select employee_id, salary, dense_rank() over (order by salary desc) sal_rank
from employees )
where sal_rank = 4
