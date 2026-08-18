--created 8/13/25
--this is a scratch query where I am testing all the analytic functions I can think of in one query (to refresh my memory)
--this uses rank, dense_rank, avg, count
select  employee_id, salary, department_id, 
    rank() over (partition by department_id order by salary) rnk_dept,
    dense_rank() over (partition by department_id order by salary) drank_dept,
    round(avg(salary) over(partition by department_id),1) dept_avg_sal,
    count(*) over(partition by department_id) dept_ct,
    row_number() over(order by department_id) row_num,  --this is not working (
    count(*) over () ttl_ct
from employees
order by department_id nulls first;


-how many employees in each department as well as total employees (correct)

select e.*, count(*) over (partition by deptno) dept_ct, count(*) over () ttl_ct
from emp e
order by deptno

select e.*, round(avg(sal) over()) avg_sal, round(avg(sal) over (partition by deptno),2) avg_sal_dept, 
    count(*) over (partition by deptno) dept_ct, sum(sal) over (partition by deptno) sum_dept_sal
from emp e
order by deptno, sal desc


select count(*)
from ship_cabins

--window
select s.*, sum(sq_ft) over () ttl_sq_ft, sum(sq_ft) over (order by sq_ft) rt_sq_ft,
    sum(sq_ft) over (order by sq_ft rows between 1 preceding and 1 following) roll_sq_ft,
    s.sq_ft sq_ft2,
    sum(sq_ft) over (partition by window order by sq_ft) part_rt_sq_ft,
    sum(sq_ft) over (partition by window order by sq_ft rows between 1 preceding and 1 following) part_roll_sq_ft
from ship_cabins s
order by sq_ft

update ship_cabins
set sq_ft = '600'
where ship_cabin_id = 3

select employee_id, department_id, 
    count(*) over (partition by department_id) dept_ct ,count(*) over () ttl_cnt
from employees;

select e.*, count(*) over (partition by deptno) deptno_ct,
avg(sal) over (partition by deptno order by sal desc) avg_deptno_sal
from emp e
order by sal desc

select employee_id, department_id, hire_date, 
    count(*) over (partition by department_id order by hire_date desc) dept_ct
from employees
order by department_id nulls first


--create table for rank/dense_rank demo
CREATE TABLE rank_demo (
	col VARCHAR(10) NOT NULL
);

INSERT ALL 
INTO rank_demo(col) VALUES('A')
INTO rank_demo(col) VALUES('A')
INTO rank_demo(col) VALUES('B')
INTO rank_demo(col) VALUES('C')
INTO rank_demo(col) VALUES('C')
INTO rank_demo(col) VALUES('C')
INTO rank_demo(col) VALUES('D')
SELECT 1 FROM dual; 

--simple use of rank/dense_rank to show that rank will leave gaps while dense_rank will not 
SELECT 
	col, 
	RANK() OVER (ORDER BY col) my_rank, 
    dense_RANK() OVER (ORDER BY col) dense_rank,
    count(*) over () ttl_cnt
FROM 
	rank_demo;

--below query show difference between rank and dense_rank=>when salary is equal between employees rank will leave a gap for every equivalent row while dense_rank will not leave a gap    
select employee_id, department_id, salary, row_number() over (partition by department_id order by salary desc) rownm,
    rank()       over (partition by department_id order by salary desc nulls last) rank1,
    dense_rank() over (partition by department_id order by salary desc nulls last) dense_rank1
from employees
--where rank1 <> dense_rank1
order by department_id, rank1


FIRST VALUE and LAST VALUE function

-- How many days after the first hire of each department were the next employees hired?
--first_value is derived in the subquery and then used in a calculation in the outer query to determine the gap between first hired and current hired
select employee_id, department_id, hire_date, fhire_date, hire_date - fhire_date day_gap
    ,count(*) over (partition by department_id) dept_ct
from (
SELECT employee_id, department_id, hire_date,
    FIRST_VALUE(hire_date) OVER (PARTITION BY department_id ) fhire_date
FROM employees
ORDER BY department_id
)
ORDER BY department_id, DAY_GAP;


--how many employees in each department as well as total employees (correct)
select e.*, count(*) over () ct_total, count(*) over (partition by department_ID) CT_DEPT
from employees e
order by department_id



--partition clause uses order by clause (for ordering within each partition)
select employee_id, department_id, salary , 
    first_value(salary) over (partition by department_id order by salary desc) as fv_dept
    ,count(*) over (partition by department_id) dept_ct
    ,count(*) over () total_ct    
from employees
order by department_id

--compare each employee salary against the avg salary for each dept
--note: avg function can act as both aggregate and analytic function
select employee_id, department_id, salary, 
    round(avg(salary) over (partition by department_id ),1) avg_dept_sal, 
     salary - round(avg(salary) over (partition by department_id ),1) diff_avg_dept_sal ,
     count(*) over (partition by department_id) dept_ct
from employees
order by department_id

--all employees along with the the number of employees in their dept
select department_id, first_name, count(*) over(partition by department_id) dept_ct, count(*) over () ttl_cnt
from employees
--where rownum <=50
order by 1,2


--lead/lag
--make sure you know which one pulls from prior/next row, I got it backwards when reviewing=lead and lag is from perspective of the current row
    --so lead pulls the value from the subsequent row which lag pulls the value from the prior row
--to me, they should be reversed as far as functionality=>yes, I feel it should be reversed but it is what it is
--notice the second pair of lead/lag below is using offset value to pull data from 2 rows prior/after=> good to know
select s.product_name, s.quantity,
    lead(quantity) over (order by sale_date) lead_next_day_sales,
    lag(quantity) over (order by sale_date) lag_prev_day_sales,
    lead(quantity, 2) over (order by sale_date) lead_next_day_sales_off2,
    lag(quantity,2) over (order by sale_date) lag_prev_day_sales_off2        
from sales s
order by sale_date


select s.*, 
    lead(quantity) over (partition by product_name order by sale_date ) next_day_sales,
    lag(quantity) over (partition by product_name order by sale_date) prev_day_sales
from sales s
order by product_name



--lead/lag
select s.*, lead(sale_date) over (order by sale_date) lead_sale_date, lag(sale_date) over (order by sale_date) lag_sale_date
from sales s
order by sale_date

select s.*, lead(sale_date) over (partition by product_name order by sale_date) lead_sale_date, lag(sale_date) over (partition by product_name order by sale_date) lag_sale_date
from sales s
order by product_name, sale_date

select * from sales order by sale_date

select * from emp order by deptno, ename

--avg analytic function
select e.*, round(avg(sal) over (partition by deptno),1) dept_avg_sal, round(avg(sal) over (),1) co_avg_sal, count(*) over() ttl_ct
from emp e

--rank dense_rank functions
--rank employees by their salary within their department
select x.*, row_number() over (order by x.department_id, sal_rank) rwnm
from (
select e.*, d.department_name dept_name, rank() over (partition by e.department_id order by salary desc) sal_rank, 
dense_rank() over (partition by e.department_id order by salary desc) sal_drank,
count(*) over (partition by e.department_id) dept_ct
from employees e
inner join departments d on e.department_id = d.department_id
order by e.department_id, sal_rank
) x

--using windowing clause
SELECT
    deptno,
    ename,
    sal,
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sal_total
FROM
    emp
ORDER BY
    deptno, sal;
    
--window clause at the end of query (21c feature) and give it an alias (w1)
--now all analytic functions can reuse the same window
select empno,
       deptno,
       sal,
       first_value(sal) over w1 as lowest_in_dept,
       round(avg(sal) over (partition by deptno),1) as dept_avg_sal
from   emp
window w1 as (partition by deptno order by sal);    
    
    
select e.*, e.sal sal1, lead(sal) over (order by sal) sal2, lag(sal) over(order by sal)
from emp e
order by sal desc

select empno, deptno, sal, lead(sal) over (order by sal) lead_sal, lag(sal) over (order by sal) lag_sal
from emp
order by sal

select * from employees
select employee_id, first_name, last_name, salary , nth_value(salary,4) over( order by salary desc range between unbounded preceding and unbounded following) nth_sal
, rownum
from employees;

select * from employees order by salary desc

--find the 4th highest salary in the entire company (know this)
SELECT * FROM (
    SELECT 
        employee_id, 
        salary, 
        DENSE_RANK() OVER (ORDER BY salary DESC) as salary_rank
    FROM employees
)
WHERE salary_rank = 4


select * from (
select employee_id, salary, dense_rank() over (order by salary desc) sal_rank
from employees )
where sal_rank = 4
\

select s.* , row_number() over (order by object_name)
from source_tab S
where object_type = 'WINDOW'

select e.*, row_number() over (order by sal desc) row_num
from emp e

select e.*, row_number() over (partition by deptno order by sal desc) row_num
from emp e

select e.*, rank() over (partition by deptno order by sal desc) sal_rank,  dense_rank() over (partition by deptno order by sal desc) sal_drank
from emp e

select s.*, lead(sal) over (order by sal desc) lead_sal, lag(sal) over(order by sal desc) lag_sal
from emp s
order by sal desc
