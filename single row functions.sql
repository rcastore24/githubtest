--single row functions

--nvl
select employee_id, department_id, nvl(department_id, 999)
from employees 
order by department_id nulls first

--uses if then else logic =>if check_expression is not null then expression1 else expression2
select employee_id, department_id, nvl2(department_id, department_id, 999)
from employees 
order by department_id nulls first

--nullif
select e.*, nullif(empno, mgr) null1
from emp e

--i updated this row to test above nullif functtion
update emp
set mgr = 7369 where empno = 7369
