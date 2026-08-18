--oracle does not support the limit clause
--see below for equivalent

select j.*, rownum
from hr.jobs j
order by j.max_salary desc
fetch first 4 rows only

--included the with ties variation (pulls an additional row because third row salary = second row salary)
select e.*, rownum
from employees e
order by salary desc
fetch first 2 rows with ties

select j.*, rownum
from hr.jobs j
order by j.max_salary desc
offset 3 rows fetch next 4 rows only