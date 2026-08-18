--Step 1 - create function to return ref cursor values
CREATE OR REPLACE FUNCTION xx_f RETURN SYS_REFCURSOR
AS
  c SYS_REFCURSOR;
BEGIN
  OPEN c FOR select job_title
                from jobs
                where rownum < 5;
  RETURN c;
END;
/
set serveroutput ON
--Step 2 - run script to call function, retrieve ref cursor values and display them
declare
   d sys_refcursor;
   v jobs.job_title%type; 

begin
   dbms_output.put_line ('start: '||to_char(sysdate,'mm/dd/yyyy hh:mi:ss')); 
   d := xx_f();
   loop
      fetch d into v;
         exit when d%notfound;
         dbms_output.put_line ('job title: '||v);      
   end loop;
end;
/

--
CREATE OR REPLACE PROCEDURE get_employees_by_dept (
    p_deptno IN employees.department_id%TYPE,
    p_recordset OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_recordset FOR --note there are no parentheses () used here (it is not a loop)
        SELECT first_name, last_name, employee_id, department_id
        FROM employees
        WHERE department_id = p_deptno
        ORDER BY last_name;
END get_employees_by_dept;
/


declare
    v_first_name varchar2(20);
    v_last_name varchar2(25);
    v_employee_id number(6);
    v_department_id number(4);
    v_cursor sys_refcursor;
begin 
    get_employees_by_dept(60,v_cursor);  --this fetches a pointer to the resultset defined in the procedure get_employees_by_dept defined above
    --use the pointer to loop through the refcursor
    --this is the client side processing described in google => to populate a grid or something like that
    loop
        fetch v_cursor into v_first_name, v_last_name, v_employee_id, v_department_id;
        exit when v_cursor%notfound;
        dbms_output.put_line('last_name-'||v_last_name);
    end loop;
end;    

--9/18/25 creating a pl/sql block to use an existing ref cursor procedure
declare 
    v_last_name         employees.last_name%type;
    v_ref_cursor        sys_refcursor;
    v_first_name        employees.first_name%type;
    v_employee_id       employees.employee_id%type;
    v_department_id     employees.department_id%type;
begin
    get_employees_by_dept(90,v_ref_cursor);
    
    loop
        fetch v_ref_cursor into v_first_name, v_last_name, v_employee_id, v_department_id;
        exit when v_ref_cursor%notfound;
        dbms_output.put_line('v_last_name: '||v_last_name);
    end loop;    
exception
    when others then
        dbms_output.put_line('when others exception: '||SQLERRM);
end;    

--create procedure to retrieve a ref cursor result set
create or replace procedure get_ename_by_deptno (p_deptno in emp.deptno%type, p_ref_cursor out sys_refcursor)
as
begin
    open p_ref_cursor for
        select ename 
        from emp 
        where deptno = p_deptno;
end;

--pl/sql block to fetch a ref cursor from the db and then display the contents to the screen (it works)
declare
    v_ref_cursor    sys_refcursor;
    v_ename         emp.ename%type;
begin
    get_ename_by_deptno (20,v_ref_cursor);
    
    loop 
        fetch v_ref_cursor into v_ename;
        exit when v_ref_cursor%notfound;
        dbms_output.put_line('ename: '||v_ename);
    end loop;    
    
    dbms_output.put_line('ct: '||v_ref_cursor%rowcount);    
end;    


--combine the procedure technique from above with the pl/sql block which retrieves the ref cursor
--the above scenario is more real world in that a third party client software would retrieve a ref cursor to display the contents in the application
--below scenario is just for practice and to show it can be done

declare
    type t_ref_cursor is ref cursor;
    v_emp_by_mgr    t_ref_cursor;
    v_emp           emp%rowtype;
begin
    open v_emp_by_mgr for select * from emp where mgr = 7698;
    
    loop
        fetch v_emp_by_mgr into v_emp;
        exit when v_emp_by_mgr%notfound;        
        dbms_output.put_line('mgr: '||v_emp.mgr||' ename: '||v_emp.ename);
    end loop;
    
    dbms_output.put_line('ct: '||v_emp_by_mgr%rowcount);
    
    close v_emp_by_mgr;
end;    

--ref cursor based on book oracle pl/sql by example chapter 12 page 190
declare
    type t_rec is ref cursor return student.course%rowtype;
    cv_course   t_rec;
    
    v_course    student.course%rowtype;
begin
    open cv_course for
        select * from student.course where prerequisite = 20;
    loop
        fetch cv_course into v_course;
        exit when cv_course%notfound;
        dbms_output.put_line('course: '||v_course.course_no||' - '||v_course.description);
    end loop;
    dbms_output.put_line('ct: '||cv_course%rowcount);
    close cv_course;
end;

declare
    type t_rec is ref cursor return student.course%rowtype;
    cv_course   t_rec;
    
    v_course    student.course%rowtype;
begin    
    open cv_course for
        select * from student.course where prerequisite = 20 order by description;
    loop
        fetch cv_course into v_course;
        exit when cv_course%notfound;
        dbms_output.put_line('course info: '||v_course.course_no||' - '||v_course.description);    
    end loop;
    dbms_output.put_line('ct: '||cv_course%rowcount);
    close cv_course;
end;

declare
    type t_rec is ref cursor return student.course%rowtype;
    cv_course t_rec;
    v_course student.course%rowtype;
begin
    open cv_course for select * from student.course where   prerequisite = 20;
    loop
        fetch cv_course into v_course;
        exit when cv_course%notfound;
        dbms_output.put_line('course info: '||v_course.course_no||' - '||v_course.description);
    end loop;
    dbms_output.put_line('ct: '||cv_course%rowcount);
end;

declare
    type t_rec is ref cursor  return student.course%rowtype;
    cv_course t_rec;
    v_course    student.course%rowtype;
begin
    open cv_course for
        select * from student.course where prerequisite = 20;
    loop
        fetch cv_course into v_course;
        exit when cv_course%notfound;
        dbms_output.put_line('course info: '||v_course.course_no||' - '||v_course.description);
    end loop;    
    dbms_output.put_line('ct: '||cv_course%rowcount);    
end;

--rac note: i am not sure the purpose of return stmt(line 198), it also works the same without it
clear screen;
declare
    type t_refcursor is ref cursor return emp%rowtype;
    cv_refcursor t_refcursor;
    v_emp   emp%rowtype;
begin
    open cv_refcursor  for
        select *
        from emp
        order by sal desc
        fetch first 5 rows only;
    loop    
        fetch cv_refcursor into v_emp;
        exit when cv_refcursor%notfound;
        dbms_output.put_line('emp: '||v_emp.ename||' sal: '||v_emp.sal);
    end loop;        
    close cv_refcursor;
end;

select * from student.course
select user from dual
--pl/sql by example book page 314 - using a ref cursor loop
--rac note: the book uses the parts below that are commented out, i used another technique that skips the type stmt (it also worked)
set serveroutput on;
clear screen;
declare 
    --type t_refcursor is ref cursor;
    c_student   sys_refcursor; --t_refcursor;
    rec_student student%rowtype;
    
    v_zip_code  student.zip%type := '06820';
begin
    open c_student for
        'select * from student where zip = :my_zip'
        using v_zip_code;
    loop
        fetch c_student into rec_student;
        exit when c_student%notfound;
        
        dbms_output.put_line('student id: '||rec_student.student_id||' - '||rec_student.first_name||' '||rec_student.last_name);
    end loop;
    close c_student;
end; 

select user from dual

SELECT city, state, zip
         ,CURSOR (SELECT first_name, last_name  
                    FROM student.student s
                   WHERE s.zip = z.zip) -- cursor expression
     FROM student.zipcode z                
    WHERE z.zip in ('06820', '06830', '07010');