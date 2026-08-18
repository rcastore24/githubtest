create or replace function find_job_title (v_job_id in varchar2)
    return varchar2
is    
    v_job_title varchar2(35);
begin
    select job_title
    into v_job_title
    from jobs
    where job_id = v_job_id;
    
    if sql%notfound then
        v_job_title := 'not found';
    end if;
    return v_job_title;
exception
    when others then
        raise_application_error(-20001,'error occurred - '||sqlcode||' - '||sqlerrm);
end;

select job_id, job_title, find_job_title(job_id)
from jobs;


select job_id, job_title, find_job_title(88)
from jobs;


--translate replaces single characters with their corresponding character
select translate('123456789','321','987') xyz
from dual

--replace function replaces the ENTIRE string with the alternative
select replace('123456789','123','999') xyz
from dual

select replace('123456789','321','789') xyz
from dual

--nvl
select employee_id, manager_id, nvl(manager_id,99) result
from employees
where employee_id in (100,101)

--nvl2=>if expression is null return expr3, else return expr2
select employee_id, manager_id, nvl2(manager_id,'not null','null') result 
from employees
where employee_id in (100,101)

--nullif
select nullif(100,100) result1, nullif(100,101) result2, nullif('abc',sysdate) result3 --for result3, different datatypes result in error
from dual

--coalesce
--list must contain the same datatypes
select employee_id, manager_id, coalesce(manager_id,123,456)
from employees
where employee_id in (100,101)

--count(column_name) returns count of all non null values in the column
--count(*) counts all rows
select count(*), count(manager_id), count(distinct manager_id)
from employees;

--months_between=>to return positive value, date1 should be later than date2
--also uses round function in last column
select jh.*, months_between(start_date, end_date), months_between(end_date, start_date), ROUND( months_between(end_date, start_date),2) fmt
from job_history jh
order by start_date


--mod function
--
select mod(1000,100),mod(1001,100), mod(999,100), mod(2000,100)
from dual

--listagg function
--fetch first x rows only does not work
--rownum did work but I didn't get the output I expected, I don't see this function as that big a deal so I am moving on
select listagg(job_title,' ') within group (order by job_title)
from jobs
where job_title not like '%Account%'
--and rownum <= 5
--fetch first 5 rows only

--initcap
select initcap('abc') a, initcap('ABC') b
from dual;


--trim functionv =>trims spaces from both ends of a string
select length(trim(' abc '))
from dual

SELECT TRIM(LEADING '0' FROM '012345 ') FROM dual;

select *
from employees
order by first_name

select *
from employees
where soundex(first_name) = soundex('Daniel')

--trunc function =>does no rounding
select trunc(8.115) a, trunc(8.115,2) b, round(8.115,2) c from dual

--systimestamp built in function
--default format is DD-MON-YYYY HH.MI.SS PM GMT
select systimestamp, to_char(sysdate,'dd-mon-yyyy hham;mi:ss') date_time, sysdate from dual

--NUMTODSINTERVAL function =>converts a number into an interval
--below select converts 74 hours, 36 hours, 11 hours into an interval, don't overthink what this does
--regarding the input parms, think of it as x hours or x minutes or x seconds
select numtodsinterval(74,'HOUR'),numtodsinterval(36,'HOUR'), numtodsinterval(11,'HOUR'), numtodsinterval(11,'MINUTE') D, numtodsinterval(11,'DAY') E
from dual;

--NUMTOYMINTERVAL => output is an interval value
--as above, think of it as x year or x months
select numtoyminterval(27,'YEAR'), numtoyminterval(27,'MONTH')
from dual

SELECT 'O''HEARN' FROM DUAL

--ceil/floor function =>  function returns the smallest integer that is greater than or equal to a specified number
SELECT 
    CEIL(24.99)  AS pos_decimal,
    CEIL(-11.23) AS neg_decimal,
    CEIL(45)     AS integer_val,
    floor(24.99)  AS a,
    floor(-11.23) AS b,
    floor(45)     AS c
FROM DUAL;

select * from employees where soundex(first_name) = soundex('Steven')

--round function - pay attention how negative rounding works
select round(250.55,0) a, round(250.55,1), round(250.55,-1),  round(250.55,-2), round(250.55,-3) from dual
select round(250.55,0) a, round(250.55,1), round(250.55,-1),  round(240.55,-2), round(250.55,-3) from dual


SELECT ROUND(124.55, -1) FROM dual;