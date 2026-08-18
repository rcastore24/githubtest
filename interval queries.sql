--create table with inteval data type and then add 2 rows into it
CREATE TABLE candidates (
    candidate_id NUMBER,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    job_title VARCHAR2(255) NOT NULL,
    year_of_experience INTERVAL YEAR TO MONTH,
    PRIMARY KEY (candidate_id)
);

INSERT INTO candidates (
    candidate_id,
    first_name,
    last_name,
    job_title,
    year_of_experience
    )
VALUES (
    1,
    'Camila',
    'Kramer',
    'SCM Manager',
    INTERVAL '10-2' YEAR TO MONTH
    );
    
INSERT INTO candidates (candidate_id,
    first_name,
    last_name,
    job_title,
    year_of_experience
    )
VALUES (2,
    'Keila',
    'Doyle',
    'SCM Staff',
    INTERVAL '9' MONTH
    );   
--trying to insert a year interval large than precision will lead to ORA-01873: the leading precision of the interval is too small
--below statement worked because 99 fits within the default 2 precision
INSERT INTO candidates (candidate_id,
    first_name,
    last_name,
    job_title,
    year_of_experience
    )
VALUES (3,
    'test',
    'test',
    'SCM Staff',
    INTERVAL '99' YEAR
    );       
    
INSERT INTO candidates (candidate_id,
    first_name,
    last_name,
    job_title,
    year_of_experience
    )
VALUES (6,
    'test2025',
    'test2025',
    '2025',
    INTERVAL '99-5' YEAR TO MONTH
    );           
INSERT INTO candidates (candidate_id,
    first_name,
    last_name,
    job_title,
    year_of_experience
    )
VALUES (7,
    'test2025',
    'test2025',
    '2025',
    INTERVAL '00-5' YEAR TO MONTH
    );               
INSERT INTO candidates (candidate_id,
    first_name,
    last_name,
    job_title,
    dts_col
    )
VALUES (9,
    'test2025',
    'test2025',
    '2025',
    INTERVAL '11 23:55:59:0000' day to second
    );                   
--below is interval day to second stuff

select interval '123456789 00:00:00.123456789' day(9) to second(9) from dual;

alter table candidates
add (dts_col INTERVAL day to second);

--below update stmt works as written=>precision is 2 for day and 6 for fraction of second (defaults)
update candidates
set dts_col = to_dsinterval('12 00:00:00.1234')
    

select employee_id, hire_date, to_char(sysdate,'mm/dd/yyyy hhAM:mi:ss'), numtodsinterval(sysdate - hire_date) days_diff
from employees


REM Get fields from an interval
with rws as (
  select sysdate, hire_date, trunc(sysdate) - hire_date
  /* , NUMTOYMINTERVAL (
           trunc(sysdate) - hire_date,
           'Year'
         ) interval_diff */
  from   employees
)
  select sysdate, hire_date,
        extract ( day from interval_diff ) days,
         extract ( hour from interval_diff ) hours,
         extract ( minute from interval_diff ) minutes,
         extract ( second from interval_diff ) seconds
  from   rws;
  
  --this is a complicated example taken from oracle help documentation=>https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/NUMTOYMINTERVAL.html
  -- following example uses NUMTOYMINTERVAL in a SUM analytic function to calculate, for each employee, the total salary of employees hired in the past one year from his or her hire date
  --i don't understand this right now but would be good to understand for the future
  SELECT last_name, hire_date, salary,
       SUM(salary) OVER (ORDER BY hire_date 
       RANGE NUMTOYMINTERVAL(1,'year') PRECEDING) AS t_sal 
  FROM employees
  ORDER BY last_name, hire_date;
  
  --function returns an interval of 5 years
  SELECT NUMTOYMINTERVAL(5, 'YEAR') FROM DUAL;
  
  --function returns an interval of 1 year, 6 months
  SELECT NUMTOYMINTERVAL(18, 'MONTH') FROM DUAL;