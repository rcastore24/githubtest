--regular expressions

select *
from (
select e.*, regexp_count(job,'man$',1,'i') ct
from emp e
)
where ct >0
