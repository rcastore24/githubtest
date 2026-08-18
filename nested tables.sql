CREATE OR REPLACE TYPE my_tab_t AS TABLE OF VARCHAR2(30);
/
CREATE TABLE nested_table (id NUMBER, 
                           col1 my_tab_t)
                            NESTED TABLE col1 STORE AS col1_tab;
       
INSERT INTO nested_table VALUES (1, my_tab_t('A'));
INSERT INTO nested_table VALUES (2, my_tab_t('B', 'C'));
INSERT INTO nested_table VALUES (3, my_tab_t('D', 'E', 'F'));
COMMIT;       

SELECT id, COLUMN_VALUE FROM nested_table t1, TABLE(t1.col1)-- t2;

--example #2
CREATE TYPE address_t AS OBJECT (
   street  VARCHAR2(30),
   city    VARCHAR2(20),
   state   CHAR(2),
   zip     CHAR(5) );
/
CREATE TYPE address_tab IS TABLE OF address_t;
/
CREATE TABLE customers (
   custid  NUMBER,
   address address_tab )
NESTED TABLE address STORE AS customer_addresses;

INSERT INTO customers VALUES (1,
            address_tab(
              address_t('101 First', 'Redwood Shores', 'CA', '94065'),
              address_t('123 Maple', 'Mill Valley',    'CA', '90952')
            )                );
            
select c.custid, u.*
from customers c, table(c.address) u

--example #3
--populate nested table using a for loop
--this only uses 3 columns from employees table (2 are concatenated)
set serveroutput on
DECLARE
  TYPE EmployeeRecord IS record (
    emp_id NUMBER,
    emp_name VARCHAR2(50)
  );
  TYPE EmployeeList IS TABLE OF EmployeeRecord;
  
  all_employees EmployeeList := EmployeeList(); -- Initialize as an empty collection
BEGIN
  -- Populate from a SELECT statement
  FOR emp_rec IN (SELECT employee_id, first_name || ' ' || last_name AS full_name FROM employees WHERE department_id = 90) LOOP
    all_employees.EXTEND; -- Add a new element
    all_employees(all_employees.COUNT) := EmployeeRecord(emp_rec.employee_id, emp_rec.full_name);
  END LOOP;
  
  -- Optionally, iterate and display elements
  FOR i IN 1 .. all_employees.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || all_employees(i).emp_id || ', Name: ' || all_employees(i).emp_name);
  END LOOP;
END;

--example4 - this works, it selects multiple records, multiple columns into a nested table as part of a for loop
--wanted to use %rowtype to declare the record but is giving error
DECLARE
  TYPE EmployeeRecord IS record (
    EMPLOYEE_ID                                NUMBER(6),
     FIRST_NAME                                VARCHAR2(20),
     LAST_NAME                                 VARCHAR2(25),
     EMAIL                                     VARCHAR2(25),
     PHONE_NUMBER                              VARCHAR2(20),
     HIRE_DATE                                 DATE,
     JOB_ID                                    VARCHAR2(10),
     SALARY                                    NUMBER(8,2),
     COMMISSION_PCT                            NUMBER(2,2),
     MANAGER_ID                                NUMBER(6),
     DEPARTMENT_ID                             NUMBER(4)
--    emprec  employees%rowtype
  );
  TYPE EmployeeList IS TABLE OF EmployeeRecord;
  
  all_employees EmployeeList := EmployeeList(); -- Initialize as an empty collection
BEGIN
  -- Populate from a SELECT statement 
  FOR emp_rec IN (SELECT * FROM employees WHERE department_id = 90) LOOP
    all_employees.EXTEND; -- Add a new element
    all_employees(all_employees.COUNT) := EmployeeRecord(emp_rec.employee_id, emp_rec.first_name, emp_rec.last_name,
        emp_rec.email, emp_rec.phone_number,emp_rec.hire_date, emp_rec.job_id, emp_rec.salary, emp_rec.commission_pct,
        emp_rec.manager_id, emp_rec.department_id);
  END LOOP; 

  FOR i IN 1 .. all_employees.COUNT LOOP    --could also loop through t_nt.first..t_nt.last (see below)
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || all_employees(i).employee_id || ', Last Name: ' || all_employees(i).last_name);
  END LOOP; 
  dbms_output.put_line('row ct: '||all_employees.count);
END;

--below is example of how to use a rowtype when creating a type as a record
declare
   type t_emp_plus_rec is record
      ( emprec emp%rowtype
      , extra integer
      );
   emp_plus_rec t_emp_plus_rec;
begin
   emp_plus_rec.emprec.empno := 123;
   emp_plus_rec.emprec.ename := 'SMITH';
   emp_plus_rec.extra := 3;
end;    

--nested table from memory (it worked)
declare
    type t_rac is record (sale_id    number, product_name    varchar2(50), quantity  number, sale_date   date);
    type t_rec is table of t_rac;
    t_nt    t_rec := t_rec(); --remember this is initialization of the table t_rec, easy to forget
begin
    null; 
    for l_sales in (select * from sales) loop
        t_nt.extend;
        --remember, t_rac below is a reference to the record type above, not the declaration of the table t_rec, easy to forget
        t_nt (t_nt.count ) := t_rac(l_sales.sale_id, l_sales.product_name, l_sales.quantity, l_sales.sale_date);
    end loop;

    for i in t_nt.first..t_nt.last loop --could also loop through 1..t_nt.count (see above example 3)
            DBMS_OUTPUT.PUT_LINE('salee ID: ' || t_nt(i).sale_id || ', prod Name: ' || t_nt(i).product_name);
    end loop;
    dbms_output.put_line('ct: '||t_nt.count);
end;    



declare
    type t_rac is record (sale_id    number, product_name    varchar2(50), quantity  number, sale_date   date);
    type t_rec is table of t_rac;
    t_nt    t_rec := t_rec();
begin
    for l_sales in (select * from sales) loop
        t_nt.extend;
        t_nt(t_nt.count) := t_rac(l_sales.sale_id, l_sales.product_name, l_sales.quantity, l_sales.sale_date);
    end loop;    
    dbms_output.put_line('ct: '||t_nt.count);
    
    for i in 1..t_nt.count loop
        DBMS_OUTPUT.PUT_LINE('salee ID: ' || t_nt(i).sale_id || ', prod Name: ' || t_nt(i).product_name);
    end loop;    
end;

--nested table example using bulk collect into
declare
    type t_rac is record (sale_id    number, product_name    varchar2(50), quantity  number, sale_date   date);
    type t_rec is table of t_rac;
    t_nt    t_rec := t_rec();
begin
    select sale_id, product_name, quantity, sale_date 
    bulk collect into t_nt
    from sales;

    dbms_output.put_line('ct: '||t_nt.count);
    
    for i in 1..t_nt.count loop
        DBMS_OUTPUT.PUT_LINE('salee ID: ' || t_nt(i).sale_id || ', prod Name: ' || t_nt(i).product_name);
    end loop;    
end;

--populate nested table (defined using %rowtype) and then display count and nested table contents =>this big
declare
--    type t_emp_rec is record(ename varchar2(10),sal    number(7,2));
    type t_nt  is table of emp%rowtype;
    v_nt    t_nt :=t_nt();
begin
    for l_emp in (select ename, sal from emp) loop
        v_nt.extend;
        v_nt(v_nt.last).ename := l_emp.ename;
        v_nt(v_nt.last).sal := l_emp.sal;        
    end loop;
    dbms_output.put_line('row ct: '||v_nt.count);  
    
    for i in v_nt.first..v_nt.last loop
        dbms_output.put_line('ename '||v_nt(i).ename||' sal '||v_nt(i).sal);
    end loop;
end;    