--nested table example
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

  FOR i IN 1 .. all_employees.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || all_employees(i).employee_id || ', Last Name: ' || all_employees(i).last_name);
  END LOOP; 
  dbms_output.put_line('row ct: '||all_employees.count);
END;

--associative array example

declare
    type t_asray is table of number index by pls_integer;
    v_asray t_asray;
    i   pls_integer := 0;
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        i := i + 1;
        v_asray(i) := l_emp.sal;
    end  loop;
    dbms_output.put_line('row ct: '||v_asray.count);
    
    for j in 1..v_asray.count loop
        DBMS_OUTPUT.PUT_LINE('sal: ' || v_asray(j));
    end loop;
end;    


declare
    type t_rac is record (ename varchar2(10),sal    number(7,2));
    type t_asray is table of t_rac index by pls_integer;
    v_asray t_asray;
    i   pls_integer := 0;
begin 
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        i := i + 1;
        v_asray(i).sal := l_emp.sal;
        v_asray(i).enam
        ename '||v_asray(j).ename||' sal: ' || v_asray(j).sal);
    end loop; 
end;    

--associative array example
declare
    type t_rac is record(ename varchar2(10),sal    number(7,2));
    type t_aray is table of t_rac index by pls_integer;
    aa_aray     t_aray;
    i   pls_integer := 0;
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        i := i + 1;
        aa_aray(i).ename := l_emp.ename;
        aa_aray(i).sal := l_emp.sal;
    end loop;
    dbms_output.put_line('row ct: '||aa_aray.count);
    for j in 1..aa_aray.count loop
        DBMS_OUTPUT.PUT_LINE('ename '||aa_aray(j).ename||' sal: ' || aa_aray(j).sal);
    end loop;
end;    

--nested table example
declare
    type t_rac is record(ename varchar2(10),sal    number(7,2));
    type t_nt is table of t_rac;
    v_nt    t_nt := t_nt();
begin
    for l_emp in (select ename, sal from emp order by sal desc fetch first 10 rows only) loop
        v_nt.extend;
        v_nt(v_nt.last).ename := l_emp.ename;
        v_nt(v_nt.last).sal := l_emp.sal;
    end loop;
    
    dbms_output.put_line('row ct: '||v_nt.count);
    
    for i in 1..v_nt.last loop
        DBMS_OUTPUT.PUT_LINE('ename: ' || v_nt(i).ename || ', sal: ' || v_nt(i).sal);
    end loop;
end;    


--varray example
declare
    type t_rac is record(ename varchar2(10),sal    number(7,2));
    type t_varay is varray(10) of t_rac;
    v_varay    t_varay := t_varay();
begin
    for l_emp in (select ename, sal from emp order by sal desc fetch first 10 rows only) loop
        v_varay.extend;
        v_varay(v_varay.last).ename := l_emp.ename;
        v_varay(v_varay.last).sal := l_emp.sal;
    end loop;
    
    dbms_output.put_line('row ct: '||v_varay.count);
    
    for i in 1..v_varay.last loop
        DBMS_OUTPUT.PUT_LINE('ename: ' || v_varay(i).ename || ', sal: ' || v_varay(i).sal);
    end loop;
end;    

--associative array example
declare
    type t_rac is record(ename varchar2(10),sal    number(7,2));
    type t_aaray is table of t_rac index by pls_integer;
    v_aaray    t_aaray := t_aaray();
    i pls_integer := 0;
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        i := i+1;
        v_aaray(i).ename := l_emp.ename;
        v_aaray(i).sal := l_emp.sal;    
    end loop;
    dbms_output.put_line('row ct: '||v_aaray.count);   
end;    

--varray example
declare
    type t_rac is record(ename varchar2(10), sal number(7,2));
    type t_aaray is table of t_rac index by pls_integer;
    v_aaray t_aaray := t_aaray();
    i pls_integer :=0;
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        i := i+1;
        v_aaray(i).ename := l_emp.ename;
        v_aaray(i).sal := l_emp.sal;
    end loop;
    dbms_output.put_line('ct: '||v_aaray.count);
end;

--varray example
declare
    type t_rac is record (ename varchar2(10), sal number(7,2));
    type t_aaray is table of t_rac index by pls_integer;
    v_aaray t_aaray := t_aaray();
    i pls_integer := 0;
begin
    for l_emp in (select ename, sal from emp where deptno = 20) loop
        i := i+1;
        v_aaray(i).ename := l_emp.ename;
        v_aaray(i).sal  := l_emp.sal;
    end loop;
    dbms_output.put_line('ct: '||v_aaray.count);
end;    


declare
    type t_rac is record(ename varchar2(10), sal number(7,2));
    type t_nt is table of t_rac;
    v_nt t_nt := t_nt();
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        v_nt.extend;
        v_nt(v_nt.last).ename := l_emp.ename;
        v_nt(v_nt.last).sal := l_emp.sal;
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
end;    

--populate an associative array using bulk collect, have to use intermediate nested table to do this
  DECLARE
      TYPE t_employee_row_collection IS TABLE OF employees%ROWTYPE;
      v_temp_employee_data t_employee_row_collection;

      TYPE t_employee_associative_array IS TABLE OF employees.last_name%TYPE INDEX BY pls_integer;
      v_employee_names_by_id t_employee_associative_array;
    BEGIN
      -- Fetch data into a temporary collection using BULK COLLECT
      SELECT *
      BULK COLLECT INTO v_temp_employee_data
      FROM employees;
--      WHERE department_id = 10;

      -- Iterate through the temporary collection and populate the associative array
      IF v_temp_employee_data.COUNT > 0 THEN
        FOR i IN v_temp_employee_data.FIRST .. v_temp_employee_data.LAST LOOP
          v_employee_names_by_id(v_temp_employee_data(i).employee_id) := v_temp_employee_data(i).last_name;
          v_employee_names_by_id(v_temp_employee_data(i).employee_id) := v_temp_employee_data(i).first_name;          
        END LOOP;
      END IF;

      -- Example of accessing data from the associative array
      DBMS_OUTPUT.PUT_LINE('Employee ID 101 Name: ' || v_employee_names_by_id(101));

    END;
    
--nested table example
declare
    type t_rac  is record (ename varchar2(10), sal number(7,2));
    type t_nt is table of t_rac;
    v_nt    t_nt := t_nt();
begin
    for l_emp in (select ename, sal from emp where deptno = 10) loop
        v_nt.extend;
        v_nt(v_nt.last).ename := l_emp.ename;
        v_nt(v_nt.last).sal := l_emp.sal;
    end loop;    
    dbms_output.put_line('row ct: '||v_nt.count);
end;    

select rownum from dual connect by rownum <=5

--basic nested table from memory --don't forget to initialize v_array as an empty collection (get error otherwise)
declare
    type t_job_record is record (job_id varchar2(10), job_title varchar2(35), min_salary number(6), max_salary number(6));
    type t_tbl_ass_array is table of t_job_record;
    v_array t_tbl_ass_array := t_tbl_ass_array();
begin
    for l_job in (select job_id, job_title, min_salary, max_salary from jobs where rownum <= 4) loop
        v_array.extend;
        v_array(v_array.count) := t_job_record(l_job.job_id, l_job.job_title, l_job.min_salary, l_job.max_salary);
    end loop;
    for i in 1..v_array.count loop
        dbms_output.put_line('job_id '||v_array(i).job_id||' job_title '||v_array(i).job_title);
    end loop; 
    dbms_output.put_line('row ct: '||v_array.count);    
end;    

--nest table collectin - it works
declare
   type type1 is record (job_id varchar2(10), job_title varchar2(35), min_salary number(6), max_salary number(6));
   type type2 is table of type1;
   type3 type2 := type2();
begin  
    for x in (select * from jobs where rownum <=5 ) loop
        type3.extend;        
        type3(type3.count) := type1(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job_id '||type3(type3.count).job_id||' job_title '||type3(type3.count).job_title);
    end loop;
    dbms_output.put_line('row ct: '||type3.count);      
end;

--nested table example (it works)
set serveroutput on
declare
    type nt_rec is record(job_id varchar2(10), job_title varchar2(35), min_salary number(6), max_salary number(6));
    type nt_tbl is table of nt_rec;
    v_nt    nt_tbl := nt_tbl();
begin
    for x in (select * from jobs where job_title like '%Manager%' ) loop
        v_nt.extend;
        v_nt(v_nt.count) := nt_rec(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job_id '||v_nt(v_nt.count).job_id||' job_title '||v_nt(v_nt.count).job_title);
    end loop;
    dbms_output.put_line('row ct: '||v_nt.count);      
end;    
    
    
begin
    type nt_tbl is table of jobs%rowtype;
    --type nt_tbl is table of nt_rec;
    v_nt    nt_tbl := nt_tbl();
begin
    for x in (select * from jobs where job_title like '%Manager%' ) loop
        v_nt.extend;
        v_nt(v_nt.count) := nt_rec(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job_id '||v_nt(v_nt.count).job_id||' job_title '||v_nt(v_nt.count).job_title);
    end loop;
    dbms_output.put_line('row ct: '||v_nt.count);      
end;        

set serveroutput on 
  DECLARE
      TYPE t_employee_row_collection IS TABLE OF employees%ROWTYPE;
      v_temp_employee_data t_employee_row_collection;

      TYPE t_employee_associative_array IS TABLE OF employees.last_name%TYPE INDEX BY pls_integer;
      v_employee_names_by_id t_employee_associative_array;
    BEGIN
      -- Fetch data into a temporary collection using BULK COLLECT
      SELECT *
      BULK COLLECT INTO v_temp_employee_data
      FROM employees
      WHERE department_id = 90 order by last_name;

      -- Iterate through the temporary collection and populate the associative array
      IF v_temp_employee_data.COUNT > 0 THEN
        FOR i IN v_temp_employee_data.FIRST .. v_temp_employee_data.LAST LOOP
          v_employee_names_by_id(v_temp_employee_data(i).employee_id) := v_temp_employee_data(i).last_name;
          v_employee_names_by_id(v_temp_employee_data(i).employee_id) := v_temp_employee_data(i).first_name;          
        END LOOP;
      END IF;
      DBMS_OUTPUT.PUT_LINE('emp id1: '||v_employee_names_by_id.first);
      DBMS_OUTPUT.PUT_LINE('emp id3: '||v_employee_names_by_id.last);      
      DBMS_OUTPUT.PUT_LINE('ct: '||v_employee_names_by_id.count);
    END;
    
--rac note:  always remember => declaring a recod does not require OF stmt while declaring a table DOES require an OF stmt    
--rac note2: when loading the query results into collection variable, need to populate into the corresponding record and then assign to latest collectin row (see 9th line below)
set serveroutput on 
declare
    type nt_rec is record (job_id varchar2(10), job_title varchar2(35), min_salary number(6), max_salary number(6));
    type nt_table is table of nt_rec;
    v_nt nt_table := nt_table();
begin
    for x in (select * from jobs where rownum <= 4) loop
        v_nt.extend;
        v_nt(v_nt.count) := nt_rec(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job_id '||v_nt(v_nt.count).job_id||' job_title '||v_nt(v_nt.count).job_title);        
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
end;    

declare
    type type1 is record(job_id varchar2(10), job_title varchar2(35), min_salary number(6), max_salary number(6));
    type type2 is table of type1;
    type3 type2 := type2();
begin
    for x in (select * from jobs where rownum <=7) loop
        type3.extend;
        type3(type3.count) := type1(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job id '||type3(type3.count).job_id);
    end loop;        
    dbms_output.put_line('ct '||type3.count);
end;    

--start here
declare
    type type2 is table of jobs%rowtype;
    type3 type2 := type2();
begin
    for x in (select * from jobs where rownum <=7) loop
        type3.extend;
        type3(type3.count) := jobs%rowtype(x.job_id, x.job_title, x.min_salary, x.max_salary);
        dbms_output.put_line('job id '||type3(type3.count).job_id);
    end loop;        
    dbms_output.put_line('ct '||type3.count);
end;    


--varray 
declare
    type t_emp is record(ename varchar2(10), sal    number(7,2));
    type t_varray is varray(10) of t_emp;
    v_varray    t_varray := t_varray();
begin
    for x in (select ename, sal from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).ename := x.ename;
        v_varray(v_varray.last).sal := x.sal;        
    end loop;    
  
    for i in 1..v_varray.last loop
      dbms_output.put_line('ename: '||v_varray(i).ename ||' sal: '||v_varray(i).sal);
--    DBMS_OUTPUT.PUT_LINE('ename: '||v_varray(i).ename ||',sal: '||v_varray(i).sal);
    end loop;    
    
    dbms_output.put_line('row ct: '||v_varray.count);    
end;        


--sample varrray copied from google ai (it works, i added the row ct at the end)
DECLARE
  -- Define the collection type
  TYPE MyType IS TABLE OF VARCHAR2(10);
  
  -- Instantiation AND Initialization using the constructor (MyType())
  v_collection MyType := MyType(); -- This creates an initialized empty collection
BEGIN
  v_collection.EXTEND; -- Works because it's initialized
  v_collection(1) := 'Example';
  dbms_output.put_line('row ct: '||v_collection.count);    
END;
/
--varray done from memory (it works)
--things i messed up
    --when declaring varray, don't forget to include the record type (of t_rec)
    --when getting count, you don't need collection subscript (only collection_name.count)
declare 
    type t_rec is record( ename varchar2(10), sal number(7,2));
    type t_varray is varray(10) of t_rec;
    v_varray    t_varray := t_varray();
begin
    for x in (select ename, sal from emp fetch first 10 rows only) loop
       v_varray.extend;
       v_varray(v_varray.last).ename := x.ename;
       v_varray(v_varray.last).sal := x.sal;
    end loop;
    
    for i in 1..v_varray.last loop
       dbms_output.put_line('ename: '||v_varray(i).ename ||' sal: '||v_varray(i).sal);
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);    
end;    

--don't forget to add the type (of t_rec) when declaring varray
--don't forget to use .last as the subscript when assigning values to the varray
--%rowtype is used with bulk collect, not varray
set serveroutput on
clear screen
declare
    type t_rec is record (ename varchar2(10), sal number(7,2));
    type t_varray is varray(10) of t_rec;
    v_array t_varray := t_varray();
begin
    for i in (select ename, sal from emp fetch first 5 row only) loop
        v_array.extend;
        v_array(v_array.last).ename := i.ename;
        v_array(v_array.last).sal := i.sal;        
    end loop;    
    for i in 1..v_array.last loop
       dbms_output.put_line('ename: '||v_array(i).ename ||' sal: '||v_array(i).sal);
    end loop;    
    dbms_output.put_line('ct: '||v_array.count);    
end;    


declare
    type t_rec is record (ename varchar2(10), sal number(7,2));
    type t_varray is varray(10) of t_rec;
    v_varray t_varray := t_varray();
begin    
    for x in (select * from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).ename := x.ename;
        v_varray(v_varray.last).sal := x.sal;
    end loop;    
    for i in 1..v_varray.last loop
       dbms_output.put_line('ename: '||v_varray(i).ename ||' sal: '||v_varray(i).sal);
    end loop;  
    dbms_output.put_line('ct: '||v_varray.count);    
end loop;    

--varray includes exception handler
declare
    type t_rec is record(empno number(4),sal number(7,2));
    type t_array is varray(10) of t_rec;
    v_varray    t_array := t_array();
begin
    for x in (select * from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := x.empno;
        v_varray(v_varray.last).sal := x.sal;
    end loop;
    for i in 1..v_varray.last loop
        dbms_output.put_line('fuck you empno: '||v_varray(i).empno||' sal: '||v_varray(i).sal);
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
exception
    when others then
        dbms_output.put_line('errm: '||sqlerrm||' error code: '||sqlcode);
end;

--nested table
declare
    type t_rec is record(empno number(4),sal number(7,2));
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for i in (select * from emp order by sal desc) loop
        v_nt.extend;
        v_nt(v_nt.last).empno := i.empno;
        v_nt(v_nt.last).sal := i.sal;        
    end loop;
    for x in 1..v_nt.last loop
        dbms_output.put_line('empno: '||v_nt(x).empno||' sal: '||v_nt(x).sal);    
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
end;


declare
    type t_assoc_array is table of number index by pls_integer;
    v_assarray  t_assoc_array;
    x   pls_integer := 0;
begin
    for i in (select empno from emp) loop
        x := x + 1;
        v_assarray(x) := i.empno;
    end loop;
    for l in 1..v_assarray.last loop
        dbms_output.put_line('empno: '||v_assarray(l));
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
end;    

--varray index is varchar2
--dont' forget to define varchar2 length, get error if you don't
declare
    type t_assarray is table of varchar2(10) index by pls_integer;
    v_assarray t_assarray;
    str     number := 0;
begin
    for x in (select * from emp fetch first 5 rows only) loop
        str := str +1;
        v_assarray(str) := x.ename;
    end loop;
    for i in 1..v_assarray.last loop
        dbms_output.put_line('ename: '||v_assarray(i));
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
end;

declare
    type t_rec is table of number(10) index by pls_integer;
    v_assarray t_rec;
    str number := 0;
begin
    for x in (select * from emp order by sal desc fetch first 5 rows only) loop
        str := str + 1;
        v_assarray(str) := x.empno;
    end loop;
    for i in 1..v_assarray.last loop
        dbms_output.put_line('empno: '||v_assarray(i));
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
end;    

--don't forget to include the wide of the number column in your type declaration (line 2)
declare
    type t_rec is table of number(10) index by pls_integer;
    v_assarray t_rec;
    str number := 0;
begin    
    for x in (select * from emp order by sal desc fetch first 5 rows only) loop
        str := str + 1;
        v_assarray(str) := x.empno;
    end loop;        
        
    for i in 1..v_assarray.last loop
        dbms_output.put_line('empno: '||v_assarray(i));
    end loop;

    dbms_output.put_line('ct: '||v_assarray.count);
end;    

declare
    type t_emp is table of number(10) index by pls_integer;
    v_assarray  t_emp;
    str number := 0;
begin
    for x in (select * from emp order by sal desc fetch first 2 rows with ties) loop
        str := str + 1;
        v_assarray(str) := x.sal;
    end loop;
    for i in 1..v_assarray.last loop
        dbms_output.put_line('sal: '||v_assarray(i));
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
end;    

--nested table
--rememeber not to use OF keyworld when declaring record type (line 2 below)
--use the nested table type (not the record type) when instantiating the nested table variable (line 4 below)
--remember to assign field from the select stmt using the record in 1 line versuses assigning the field invidividually (i.e, multiple lines/assignments), see line 8 below
declare
    type t_rec is record (ename varchar2(10), empno number(4));
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for x in (select ename, empno from emp fetch first 10 rows only) loop
        v_nt.extend;
        v_nt(v_nt.last) := t_rec(x.ename, x.empno);
    end loop;
    
    for i in 1..v_nt.last loop
        dbms_output.put_line('ename: '||v_nt(i).ename||' empno: '||v_nt(i).empno);
    end loop;
    
    dbms_output.put_line('ct: '||v_nt.count);
end;    

--v_array example
--remember that varray does not require an upper bound for the substring (gives error)
declare
    type t_rec is record(ename varchar2(10), empno number(4));
    type t_varray is table of t_rec;
    v_varray    t_varray := t_varray();
begin
    for x in (select ename, empno from emp fetch first 5 rows only) loop
        v_varray.extend;
--        v_varray(v_varray.last).ename := x.ename;
--        v_varray(v_varray.last).empno := x.empno;
        v_varray(v_varray.last) := t_rec(x.ename, x.empno);
    end loop;
    for i in 1..v_varray.last loop
       dbms_output.put_line('ename: '||v_varray(i).ename ||' empno: '||v_varray(i).empno);
    end loop;      
    dbms_output.put_line('ct: '||v_varray.count);
end;

--associative array example
declare
    type t_nt is table of number index by pls_integer;
    v_assarray  t_nt;
    i   number := 0;
begin
    for x in (select sal from emp order by sal desc fetch first 2 rows with ties) loop
        i := i + 1;
        v_assarray(i) := x.sal;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    
    for j in 1..v_assarray.count loop
        DBMS_OUTPUT.PUT_LINE('sal: ' || v_assarray(j));
    end loop;    
end;

declare
    type t_assarray is table of number index by pls_integer;
    v_assarray t_assarray;
    i number := 0;
begin
    for x in (select sal from emp order by sal desc fetch first 2 rows with ties) loop
        i := i + 1;
        v_assarray(i) := x.sal;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    
    for j in 1..v_assarray.count loop
        DBMS_OUTPUT.PUT_LINE('sal: ' || v_assarray(j));
    end loop;        
end;

--nested table
set serveroutput on
declare
    type t_rec is record (empno number, sal number);
    type t_nt is table of t_rec;
    v_nt    t_nt := t_nt();
begin
    for x in (select * from emp) loop
        v_nt.extend;
        v_nt(v_nt.last).empno := x.empno;
        v_nt(v_nt.last).sal := x.sal;
    end loop;
    dbms_output.put_line('ct: '||v_nt.last);
    for i in 1..v_nt.last loop
        DBMS_OUTPUT.PUT_LINE('empno: ' || v_nt(i).empno || ', sal: ' || v_nt(i).sal||' adj sal: '||v_nt(i).sal);
    end loop;
end;

set serveroutput on
declare
    type t_rec is record(empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray t_varray := t_varray();
begin
    for i in (select empno, sal from emp fetch first 8 rows only) loop
    v_varray.extend;
    v_varray(v_varray.last).empno := i.empno;
    v_varray(v_varray.last).sal := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
end;

--remember to instantiate your collection
declare
    type t_rec is record(empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray    t_varray := t_varray();
begin
    for x in (select empno, sal from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := x.empno;
        v_varray(v_varray.last).sal := x.sal;
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
    
    for i in 1..v_varray.last loop
        dbms_output.put_line('empno: '||v_varray(i).empno);
    end loop;    
end;    

--on line 2, remember to use INDEX not INDEXED
declare
    type t_rec is table of number index by pls_integer;
    v_assarray  t_rec;
    x   pls_integer := 0;
begin
    for i in (select empno from emp ) loop
        x := x+1;
        v_assarray(x) := i.empno;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    for idx in 1..v_assarray.last loop
        dbms_output.put_line('empno: '||v_assarray(idx));
    end loop;
end;    

set serveroutput on
declare
    type t_rec is record(empno number, sal number);
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for i in (select empno, sal from emp fetch first 5 rows only) loop
        v_nt.extend;
        v_nt(v_nt.last).empno := i.empno;
        v_nt(v_nt.last).sal := i.sal;        
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
    for idx in 1..v_nt.last loop
        dbms_output.put_line('empno: '||v_nt(idx).empno||' sal: '||v_nt(idx).sal);
    end loop;
end;    

--don't forget to assign record type when declaring varray(line 3)
declare
    type t_rec is record (empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray t_varray := t_varray();
begin
    for i in (select empno, sal from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := i.empno;
        v_varray(v_varray.last).sal := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
    
    for i in 1..v_varray.last loop
      dbms_output.put_line('empno: '||v_varray(i).empno ||' sal: '||v_varray(i).sal);
    end loop;    
end;    

declare
    type t_assarray is table of integer index by pls_integer;
    v_assarray t_assarray;
    i   pls_integer := 0;
begin
    for x in (select empno from emp) loop
        i := i + 1;
        v_assarray(i) := x.empno;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    
    for idx in 1..v_assarray.count loop
    dbms_output.put_line('empno: '||v_assarray(idx));        
    end loop;
end;    

--don't forget to include the upper bound when declaring a varray (see line 3)
declare
    type t_rec is record (empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray    t_varray := t_varray();
begin
    for i in (select empno, sal from emp fetch first 9 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := i.empno;
        v_varray(v_varray.last).sal := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
    for idx in 1..v_varray.last loop
        dbms_output.put_line('empno: '||v_varray(idx).empno||' sal: '||v_varray(idx).sal);
    end loop;
end;

declare
    type t_rec is table of number index by pls_integer;
    v_assarray t_rec;
    idx pls_integer := 0;
begin
    for i in (select empno from emp) loop
        idx := idx + 1;
        v_assarray(idx) := i.empno;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    for l in 1..v_assarray.count loop
        dbms_output.put_line('empno: '||v_assarray(l));
    end loop;
end;    
    
declare
    type t_rec is record (empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray    t_varray := t_varray();
begin
    for i in (select empno, sal from emp fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := i.empno;
        v_varray(v_varray.last).sal := i.sal;        
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
    for idx in 1..v_varray.last loop
        dbms_output.put_line('empno: '||v_varray(idx).empno||' sal: '||v_varray(idx).sal);
    end loop;
end;    

--below is how to assign the subscript of an associative array a meaningful value to create a pair of related values (like employee and his salary)
--the only tricky part of this is how you need to use a while loop to iterate through the array to retrieve your values
-- also need to store the subscript in a variable as you iterate through the array => variable is used to retrieve the value from the array and to be able to display the contents of the subscript
    --you most likely can use the collection iteration clause PAIRS OF 9new 21c feature) to display array contents, worth looking into
--i doubt you would ever want to do this for real, but it does work

declare
    type t_assarray is table of number index by varchar2(10);
    v_assarray t_assarray;
    v_ename varchar2(10);
begin
    for i in (select sal, ename from emp) loop
        v_assarray(i.ename) := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    v_ename := v_assarray.first;
    while v_ename is not null loop
        dbms_output.put_line('ename: '||v_ename||' sal: '||v_assarray(v_ename));
        v_ename := v_assarray.next(v_ename);
    end loop;
end;    

--nested table using a explicit cursor (little different technique)
declare
    cursor c1 is select empno, sal from emp fetch first 5 rows only;
    
    type t_rec is record (empno number, sal number);
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for i in c1 loop
        v_nt.extend;
        v_nt(v_nt.last).empno := i.empno;
        v_nt(v_nt.last).sal := i.sal;        
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
    for idx in 1..v_nt.last loop
        dbms_output.put_line('empno: '||v_nt(idx).empno||' sal '||v_nt(idx).sal);
    end loop;
end;    

select *
from user_types

--nested table example
--this one is different because I assigned 3 rows during initialization
--i assigned 3 values
declare
    type t_nt is table of number;
    v_nt t_nt := t_nt(10,20,30);
begin
    dbms_output.put_line('ct: '||v_nt.count);
    
    for idx in v_nt.first..v_nt.last loop
        dbms_output.put_line('nt value: '||v_nt(idx));
    end loop;
end;    

--nested table 
--this example uses the new collection iteration control VALUES OF to navigate through the nested table
--note:you have to use the loop pointer to display the values from the nested table
--I have placed 2 arrows (<==) indicating where the changes were made
declare
    type t_nt is table of number;
    v_nt t_nt := t_nt(10,20,30);
begin
    dbms_output.put_line('ct: '||v_nt.count);
    
    for idx in values of v_nt loop <==
        dbms_output.put_line('nt value: '||idx);  <==
    end loop;
end;    

--i used PAIRS OF to display contents of nested table
--just remember you have to use 2 different variables to receive the values of indeces and values
declare
    type t_nt is table of number;
    v_nt t_nt := t_nt(10,20,30);
begin
    dbms_output.put_line('ct: '||v_nt.count);
    
    for idx1, idx2 in pairs of v_nt loop --<==i have to use 2 different variables because I am returning 2 different values
        dbms_output.put_line('indeces value: '||idx1||' value: '||idx2);  --<==I am able to use these 2 variables independently of each other
    end loop;
end;    

--associative array
--using student schema
--fetched first and last name into an associative array and used PAIRS OF technique to display the full name
declare
    type t_assarray is table of varchar2(25) index by varchar2(25);
    v_assarray t_assarray;
    v_first_name varchar2(25) := null;
begin
    for i in (select first_name, last_name from student.instructor fetch first 5 rows only) loop
        v_first_name := i.first_name;
        v_assarray(v_first_name) := i.last_name;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    
    for x,y in pairs of v_assarray loop
        dbms_output.put_line('first name: '||x||' last name: '||y);
    end loop;
end;    

declare
    type t_assarray is table of integer index by pls_integer;
    v_assarray t_assarray;
begin
    v_assarray := t_assarray(1,2,3,4,5);
    v_assarray := t_assarray(for 
    dbms_output.put_line('ct: '||v_assarray.count);
end;

declare
    type t_assarray is table of varchar2(25) index by varchar2(25);
    v_assarray t_assarray;
    v_first_name varchar2(25) := null;
begin
    for i in (select first_name, last_name from student.instructor) loop
        v_first_name := i.first_name;
        v_assarray(v_first_name) := i.last_name;
    end loop;

    for x,y in pairs of v_assarray loop
--        dbms_output.put_line('first_name: '||x||' last name: '||y);
        dbms_output.put_line('full name: '||x||' '||y);
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);    
end;    

--Oracle PL/SQL by Example - chapter 15 exercise #2
declare
    type t_rec is record (first_name varchar2(25), last_name varchar2(25));
    type t_varray is varray(10) of t_rec;
    v_varray t_varray := t_varray();
begin
    for i in (select first_name, last_name from student.instructor fetch first 5 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).first_name := i.first_name;
        v_varray(v_varray.last).last_name := i.last_name;
    end loop;
   
    for x in values of v_varray loop
        dbms_output.put_line('full name: '||x.first_name||' '||x.last_name);
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);    
end;

declare
    type t_rec is record (instructor_id number, first_name varchar2(25), last_name varchar2(25));
    type t_varray is varray(10) of t_rec;
    v_instr_varray t_varray := t_varray();

    type t_sec_rec is record (course_no number(8));
    type t_sec_varray is varray(78) of t_sec_rec;
    v_sec_varray t_sec_varray := t_sec_varray();    
begin
    for x in (select instructor_id, first_name, last_name from student.instructor order by last_name) loop
        v_instr_varray.extend;
        v_instr_varray(v_instr_varray.last).first_name := x.first_name;
        v_instr_varray(v_instr_varray.last).last_name := x.last_name;
        dbms_output.put_line('instructor name: '||x.first_name||' '||x.last_name);
        for y in (select course_no from student.section where instructor_id = x.instructor_id order by course_no) loop
            v_sec_varray.extend;
            v_sec_varray(v_sec_varray.last).course_no := y.course_no;
            dbms_output.put_line('course no: '||y.course_no);
        end loop;            
    end loop;
    
    dbms_output.put_line('instr ct: '||v_sec_varray.count);    
/*    for z in values of v_instr_varray loop
        dbms_output.put_line('instr name: '||z.first_name||' '|f|z.last_name);
    end loop;        */
end;    

select a.*, sum(a.ct) over () total_ct
from (
select i.instructor_id, i.last_name, i.first_name, count(s.course_no) ct 
from student.instructor i
left join student.section s
on i.instructor_id = s.instructor_id
group by i.instructor_id, i.last_name, i.first_name
--order by i.last_name
) a

declare
    type t_rec is record(empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray t_varray := t_varray();
begin
    for x in (select empno, sal from emp order by sal desc fetch first 5 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := x.empno;
        v_varray(v_varray.last).sal := x.sal;
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
    for a in values of v_varray loop
        dbms_output.put_line('empno: '||a.empno||' sal '||a.sal);
    end loop;
end;    

declare
    type t_rec is record (empno number, sal number);
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for x in (select empno, sal from emp order by sal desc fetch first 5 rows only) loop
        v_nt.extend;
        v_nt(v_nt.last).empno := x.empno;
        v_nt(v_nt.last).sal := x.sal;        
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
    for y in values of v_nt loop
        dbms_output.put_line('emp info: '||y.empno||' '||y.sal);
    end loop;
end;

declare
    type t_assarray is table of number index by pls_integer;
    v_assarray t_assarray;
    v_index number := 0;
begin
    for i in (select empno, sal from emp order by sal desc fetch first 6 rows only) loop
    
        v_index := v_index + 1;
        v_assarray(i.empno) := i.sal;
    
    end loop;
    
    dbms_output.put_line('ct: '||v_assarray.count);
    
    for x,y in pairs of v_assarray loop
        dbms_output.put_line('empno: '||x||' sal: '||y);
    end loop;
end;    

--oracle pl/sql by example exercise #1
--Create an associative array with the element type of a user-defined record. 
--This record should contain the first name, last name, and total number  
--of courses that a particular instructor teaches. Display the records of the 
--associative array on the screen. 

set serveroutput on
clear screen;
declare
    type t_rec is record (first_name varchar2(25), last_name varchar2(25), course_ct number, instructor_id  number);
    type t_tab is table of t_rec index by pls_integer;
    v_tab t_tab;
    v_index     number := 0;
begin
    for i in (select i.instructor_id, first_name, last_name, count(s.instructor_id) course_ct
              from student.instructor i
              left join  student.section s
              on  i.instructor_id = s.instructor_id
              group by i.instructor_id, first_name, last_name order by count(*) desc) loop
        v_index := v_index + 1;              
        v_tab(v_index) := t_rec(i.first_name, i.last_name, i.course_ct, i.instructor_id);             
        dbms_output.put_line('instructor_id: '||i.instructor_id||' instructor name: '||i.first_name||' '||i.last_name||' course ct: '||i.course_ct);
    end loop;              
    dbms_output.put_line('instructor ct: '||v_tab.count);
end;    

--pl/sql by example chapter 16 exercise #2
--this is a nested records example (i.e. a user defined record type that contains a nested record type
--rac note: it appears this whole nested technique could be eliminated by just doing a simple join of course table to itself using prerequisite column
clear screen;
declare
    type t_prerequisite_rec is record(prereq_no    number, prereq_desc varchar2(50), prereq_cost   number(9,2));
    type t_rec is record(course_no  number, description varchar2(50), cost number(9,2), prerequisite_rec t_prerequisite_rec);
    v_rec t_rec;
begin
    for x in (select course_no, description, cost, prerequisite from student.course where prerequisite is not null fetch first 10 rows only) loop
        v_rec := t_rec(x.course_no, x.description, x.cost);
        select course_no, description, cost
        into v_rec.prerequisite_rec
        from student.course c1
        where c1.course_no = x.prerequisite;
        
        dbms_output.put_line('course_no: '||v_rec.course_no||' description: '||v_rec.description||' cost: '||v_rec.cost||' prereq no: '||v_rec.prerequisite_rec.prereq_no||' prereq desc: '||v_rec.prerequisite_rec.prereq_desc||' prereq cost: '||v_rec.prerequisite_rec.prereq_cost);
    end loop;
end;    

--nested table example
set serveroutput on
clear screen;
declare
    type t_rec is record (empno number, sal number(7,2));
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    for i in (select empno, sal from emp order by sal desc fetch first 5 rows only) loop
        v_nt.extend;
        v_nt(v_nt.last).empno := i.empno;
        v_nt(v_nt.last).sal := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_nt.count);
end;    

clear screen;
declare
    type t_rec is record (empno number, sal number);
    type t_varray is varray(10) of t_rec;
    v_varray    t_varray := t_varray();
begin
    for i in (select empno, sal from emp order by sal desc fetch first 10 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := i.empno;
        v_varray(v_varray.last).sal := i.sal;        
        dbms_output.put_line('empno: '||v_varray(v_varray.last).empno||' sal: '||v_varray(v_varray.last).sal);
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
end;    

--associative array example below (uses while loop to retrieve contents
--i think you could also use for loop using .first .last methods to loop through the array (with .next inside the loop)
clear screen;    
declare
    type t_assarray is table of number index by pls_integer;
    v_assarray t_assarray;
    v_index pls_integer;
begin
    for i in (select empno, sal from emp fetch first 5 rows only) loop
        v_assarray(i.empno) := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
    v_index := v_assarray.first;
    while v_index is not null loop
        dbms_output.put_line('empno: '||v_index||' sal: '||v_assarray(v_index));
        v_index := v_assarray.next(v_index);
    end loop;
end;    

set serveroutput on
clear screen;
declare
    type t_assarray is table of number index by pls_integer;
    v_assarray t_assarray;
    v_idx pls_integer;
begin
    for i in (select empno, sal from emp fetch first 5 rows only) loop
        v_idx := v_idx + 1;
        v_assarray(i.empno) := i.sal;
    end loop;
    dbms_output.put_line('ct: '||v_assarray.count);
end;    
    
set serveroutput on    
clear screen;    
declare
    type t_rec is record (empno number, sal number);
    type t_varray is varray(5) of t_rec;
    v_varray t_varray := t_varray();
begin
    for i in (select empno, sal from emp order by sal desc fetch first 5 rows only) loop
        v_varray.extend;
        v_varray(v_varray.last).empno := i.empno;
        v_varray(v_varray.last).sal := i.sal;    
        dbms_output.put_line('empno '||v_varray(v_varray.last).empno||' sal: '||v_varray(v_varray.last).sal);        
    end loop;
    dbms_output.put_line('ct: '||v_varray.count);
end;

select user from dual
select * from emp order by sal desc

select i.instructor_id, first_name, last_name, count(s.instructor_id) course_ct
from student.instructor i
left join  student.section s
on  i.instructor_id = s.instructor_id
group by i.instructor_id, first_name, last_name order by count(*) desc
              
select i.instructor_id, first_name, last_name, s.section_id--, count(*) course_ct
from student.instructor i, student.section s
where i.instructor_id = s.instructor_id(+)
and i.instructor_id in (109,110)

              