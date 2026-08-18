set serveroutput on

--example 0
--most basic example of an varray 
DECLARE
  TYPE email_list_arr IS VARRAY(10) OF VARCHAR2(80);
  my_emails email_list_arr;
BEGIN
  my_emails := email_list_arr('john.doe@example.com', 'jane.smith@example.com');
  for i in my_emails.first..my_emails.last loop
    DBMS_OUTPUT.PUT_LINE(my_emails(i));
  end loop;
  dbms_output.put_line('ct: '||my_emails.count);
END;


--example1 - populate a varray defined with 2 rows and 2 columns manually (very simple)
--note: I used columns from emp table because I don't have a customer table and didn't want to recode the whole thing
--note: first 2 examples are copies from internet with minor changes to fit my local database (copied from https://www.oracletutorial.com/plsql-tutorial/plsql-varray/)
DECLARE
    TYPE r_customer_type IS RECORD(
        customer_name emp.ename%TYPE,
        credit_limit emp.sal%TYPE
    ); 
    
    TYPE t_customer_type IS VARRAY(2) 
        OF r_customer_type;

    t_customers t_customer_type := t_customer_type();
BEGIN
    t_customers.EXTEND; 
    t_customers(t_customers.LAST).customer_name := 'ABC Corp';
    t_customers(t_customers.LAST).credit_limit  := 10000; 
    
    t_customers.EXTEND; 
    t_customers(t_customers.LAST).customer_name := 'XYZ Inc';
    t_customers(t_customers.LAST).credit_limit  := 20000; 
    
    dbms_output.put_line('The number of customers is ' || t_customers.COUNT);
END;

--example 2: populate a varray using a cursor
DECLARE
    TYPE r_customer_type IS RECORD(
        customer_name emp.ename%TYPE,
        credit_limit emp.sal%TYPE
    ); 

    TYPE t_customer_type IS VARRAY(5) 
        OF r_customer_type;
    
    t_customers t_customer_type := t_customer_type();

    CURSOR c_customer IS 
        SELECT eNAME , sal 
        FROM emp
        ORDER BY sal DESC 
        FETCH FIRST 5 ROWS ONLY;
BEGIN
    -- fetch data from a cursor
    FOR r_customer IN c_customer LOOP
        t_customers.EXTEND;
        t_customers(t_customers.LAST).customer_name := r_customer.ename;
        t_customers(t_customers.LAST).credit_limit  := r_customer.sal;
    END LOOP;

    -- show all customers
    FOR l_index IN t_customers .FIRST..t_customers.LAST 
    LOOP
        dbms_output.put_line(
            'The customer ' ||t_customers(l_index).customer_name ||' has a credit of ' ||t_customers(l_index).credit_limit);
    END LOOP;
    dbms_output.put_line('The number of customers is ' || t_customers.COUNT);
END;

--example 3 (written from memory, it works) loading a varray with multiple rows and multiple columns from a cursor within a loop
declare
    type t_rac is record (ename varchar2(10), sal   number(7,2));
    type t_vary is varray (10) of t_rac;
    v_vary    t_vary := t_vary();
begin
    for l_rac in (select * from emp order by sal desc fetch first 10 rows only) loop
        v_vary.extend;   
        v_vary(v_vary.last).ename := l_rac.ename;
        v_vary(v_vary.last).sal := l_rac.sal;
    end loop;
    
    for i in 1..v_vary.count loop
        dbms_output.put_line('name ' || v_vary(i).ename||' sal: '||v_vary(i).sal);    
    end loop;
    dbms_output.put_line('The number of emps is ' || v_vary.COUNT);    
end;

--below i am trying to use a db schema type (instead of pl/sql defined type) to run the example above
--create or replace type db_vary as (

--example 4 needs to use a bulk collect

declare
    type t_rac is record (ename  varchar2(10), sal number(7,2));
    type t_vary is varray(10) of t_rac;
    v_vary  t_vary  := t_vary();
begin
    for i in (select ename, sal from emp fetch first 10 rows only) loop
        v_vary.extend;
        v_vary(v_vary.last).ename := i.ename;
        v_vary(v_vary.last).sal := i.sal;
    end loop;    
    dbms_output.put_line('The number of emps is ' || v_vary.COUNT);    
end;    

declare
    type t_rac is record (ename  varchar2(10), sal number(7,2));
    type t_nt is table of t_rac;
    v_nt t_nt := t_nt();
begin
    for i in (select ename, sal from emp) loop
        v_nt.extend;
        v_nt(v_nt.last).ename := i.ename;
        v_nt(v_nt.last).sal := i.sal;
    end loop;
    dbms_output.put_line('The number of emps is ' || v_nt.COUNT);        
end;    


declare
    type t_rac is record (ename varchar2(10),sal    number(7,2));
    type t_vary is varray(10) of t_rac;
    v_vary  t_vary := t_vary();
begin
    for l_emp in (select ename, sal from emp order by sal desc fetch first 9 rows only) loop
        v_vary.extend;
        v_vary(v_vary.last).ename := l_emp.ename;
        v_vary(v_vary.last).sal := l_emp.sal;
    end loop;
    dbms_output.put_line('The number of emps is ' || v_vary.COUNT);        
end;    


--varray using bulk collect into
declare
    type t_rac is record (ename varchar2(10),sal    number(7,2));
    type t_vary is varray(100) of t_rac;
    v_vary  t_vary := t_vary();
begin
    select ename, sal
    bulk collect into v_vary
    from emp; 

    dbms_output.put_line('The number of emps is ' || v_vary.COUNT);        
end;    


