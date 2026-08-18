select a.*
from (
select e.*, dense_rank() over (order by salary desc) drank_sal
from employees e
order by salary desc) a
where drank_sal = 2

--where rownum <

set autotrace on
SELECT * FROM employees WHERE department_id = 10;

select * from dba_synonyms
where synonym_name = 'V$PARAMETER'


select *
from (
select employee_id, salary, dense_rank() over(order by salary desc) d_sal
from employees)
where d_sal = 2


select text, count(*)
from all_source
where upper(text) like '%WRAP%'
group by text
having count(*) > 1
order by 2 desc



select *
from user_views;


CREATE VIEW employees_departments_view AS
SELECT e.employee_id, e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

CREATE OR REPLACE TRIGGER trg_io_insert_emp_dept
INSTEAD OF INSERT ON employees_departments_view
FOR EACH ROW
BEGIN
   -- First, ensure the department exists (or insert it)
   INSERT INTO departments (department_id, department_name)
   SELECT :NEW.department_id, :NEW.department_name FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = :NEW.department_id);

   -- Then, insert the employee record
   INSERT INTO employees (employee_id, first_name, last_name, department_id)
   VALUES (:NEW.employee_id, :NEW.first_name, :NEW.last_name, :NEW.department_id);
END;

--below insert does not work because my view does not include some columns from employees table that are not null(email for example)
--i could add them to the view but i don't think its necessary, i get what this type of trigger does
insert into employees_departments_view (department_id, department_name, employee_id,first_name, last_name)
values (99,'Idabel',99,'Richard', 'Castorena');

select * from employees order by 1 desc
