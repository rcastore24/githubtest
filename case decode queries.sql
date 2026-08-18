select e.*, case when sal >= 2000 then 'High Sal'
                 when sal >=1000 and sal <2000 then 'Med Sal'
                 else 'Low Sal'
            end as saldesc
from emp e
order by sal desc

select e.*, case when sal >=2000 then 'baller'
                 when sal between 1000 and 1999 then 'average joe'
                 else 'take your broke ass home'
            end as spender     
from emp e
order by sal desc



select e.*, case when sal >= 2000 then 'baller' when sal between 1000 and 1999 then 'average joe'  else 'take your broke ass home' 
    end as spender
from emp e
order by sal desc

