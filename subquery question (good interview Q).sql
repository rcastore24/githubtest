select *
from employees
where salary > (select avg(salary) from employees)
order by salary desc


interview question: How to display employee records who gets more salary than the average salary in the department?
--where department_id is null --1 row
select x.*, rownum
from (
Select employees.employee_id, employees.salary, employees.department_id, dep_sal.avg_sal
from employees,(
    select e.department_id, round(avg(e.salary),0) avg_sal
    from departments dept, 
         employees  e
    where dept.department_id = e.department_id
    group by e.department_id) dep_sal
where employees.department_id = dep_sal.department_id) x
where salary> avg_sal
order by department_id

--query to find employees that make more than their manager
select e.employee_id, e.salary, e.manager_id, mgr.salary mgr_salary
from employees e
--where manager_id is null 1 row
inner join employees mgr
on e.manager_id = mgr.employee_id
where e.salary > mgr.salary

--correlated subquery
--find all employees who earn more than the average salary for their respective departments (note: i added the extra join so I could verify results)
select e.employee_id, e.department_id, e.salary, e3.avg_sal
from employees e, (select department_id, round(avg(salary),1) avg_sal, count(*) over () ct from employees group by department_id) e3
where  e.department_id = e3.department_id
and e.salary > (select avg(e2.salary)
                from employees e2
                where e2.department_id = e.department_id)
                
--find all departments which have more than 3 employees	

select * --distinct department_id
from employees
where department_id in (
    select department_id --, count(*) ct
    from employees
    group by department_id 
    having count(*) > 3
)


--ANY operator
--select count(*) --19 employees
select distinct department_id --7 departments
from departments
where department_id = any(select department_id
from employees
where salary >= 10000)

--in operator returns the same values as any (note: any operator requires a comparison operator (=, <>, >, <, etc) to work while in operator does not need anything else
--rac note: = any is equivalent of in 
select distinct department_id --7 departments
from departments
where department_id in (select department_id
from employees
where salary >= 10000)

select e.employee_id, e.salary, e.department_id, d.department_name, count(*) over () ct
--select distinct d.department_id, d.department_name
from employees e
inner join departments d on e.department_id = d.department_id
where e.salary >= 10000
order by e.salary

--write sql query to find employees who earn more than their managers
select *
from (
select e1.employee_id e_id,e1.salary e_sal, e1.manager_id, e2.employee_id m_id, e2.salary m_sal
from employees e1
inner join employees e2 on e1.manager_id = e2.employee_id
)
where e_sal > m_sal



--interview question: How to display employee records who gets more salary than the average salary in the department?
select e.*, a.*
from emp e
inner join (
select deptno, round(avg(sal),0) avg_sal, count(*) ct
from emp 
group by deptno
order by 1) a
on e.deptno = a.deptno
where e.sal >= a.avg_sal
order by e.deptno, e.sal desc

select *
from emp 
order by deptno, sal desc

select E.EMPLOYEE_ID, E.SALARY, E.DEPARTMENT_ID, D.AVG_DEPT_SAL, D.DEPARTMENT_ID
from employees e
INNER JOIN (
    select department_id, round(avg(salary),1) avg_dept_sal
    from employees
    group by department_id) d
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > D.AVG_DEPT_SAL
