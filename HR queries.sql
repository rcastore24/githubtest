select *
from jobs

select * from employees

select to_char(start_date,'yyyy-mm'),  count(*)
from job_history
group by to_char(start_date,'yyyy-mm')
order by 1
 