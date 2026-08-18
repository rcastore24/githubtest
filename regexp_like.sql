--there are many ways to search using regexp_like than the below examples
--website with many of the search techniques https://www.techonthenet.com/oracle/regexp_like.php

--basic example=>find all rows with "er" in the job title, the trailing i makes the search case insensitve=>use c instead of i to make search case sensative
--this works just like a LIKE operator

select * 
from jobs
where  regexp_like (job_title,'er','i')

--same as above except I added a second condition "cl" using pipe notation,
--it appears you can can add as many conditions as you like using pipe notation
select * 
from jobs
where  regexp_like (job_title,'mer|cl|mark','i')

--use caret (before) or $ (after) to search for strings beginning or ending a column, notice placement of each
select * 
from jobs
where  regexp_like (job_title,'mer$|cl|mark','i')

--use square brackets to search for any individual character contained within the brackets
--below search for any containing a v or u
--you can also specify a range of letter such as [a-c] pulls letters a b and c
--appending a string to the square brackets such as [a-c]e pull any a b or c string immediately followed by an e
select * 
from jobs
where  regexp_like (job_title,'[vu]','i')

--using a period (any character except null) allows you to search for 2 ordered chaacters =>below p must be first followed by an r
select * 
from jobs
where  regexp_like (job_title,'[p].[r]','i')

--use curly brackets in conjnction with square brackets to indicate the number of successive occurrences for which to search
--below looks for 2 successive occurrences of l in the last name
select *
from employees
where regexp_like (last_name,'[l]{2}');

--finds all rows where job_titles spelled like Salas, Sales, Salis, Salos,Salus=>dumb example but i don't have great sample data
select * 
from jobs
where  regexp_like (job_title,'Sal(a|e|i|o|u)s');

--any row where job title starts with A
--need to figure out the purpose of (*)-website says matches zero or more occurrences (what does that mean?)
select * 
from jobs
where  regexp_like (job_title,'^A(*)');

--stats with a P=>it rant without the (*), should figure out the purpose of it
select * 
from jobs
where regexp_like (job_title,'^P');

--rows where job_title ends with lowercase "mer"=>note the placement of the notation at the end
select * 
from jobs
where regexp_like (job_title,'mer$');



select * from employees