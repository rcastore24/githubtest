--dynamic sql


--using execute immediate
--this works fine
set serveroutput on
declare
    v_table_name varchar2(30) := 'dest_tab'; --default value
    v_sql varchar2(250) := 'select count(*) from ';
    v_ct    number;
begin
    execute immediate v_sql||v_table_name into v_ct;
    
    dbms_output.put_line(v_table_name||' count:'||v_ct);
end;    

--this ddl (create table) using dynamic sql (need to drop the table my_emp from hr before running or you get error)
--i have been using emp as my test table to create new my emp table
--remember=> you cannot pass names of schema objects to dynamic sql (both ddl and dml) at runtime as bind arguments, you need to perform this action beforehand (i.e. assemble the entire sql stmt with bind variables prior to execute immediate)
clear screen;
declare
    v_table_name   varchar2(50) := '&new_table_name';
    v_sql varchar2(250) := 'create table my_'||v_table_name||' as select * from '||v_table_name;
    v_ct    number;
begin
    execute immediate v_sql;
    
    execute immediate 'select count(*) from my_emp'
        into v_ct;
    dbms_output.put_line('new tab row ct: '||v_ct);    
end;    

--oracle pl/sql by example book, page 278, ch17_sb.sql
--this is an example of an embedded pl/sql block being executed with dynamic sql
set serveroutput on
clear screen;
declare
    v_plsql_block   varchar2(2000);
    v_side1         number := 75;
    v_side2         number := 25;
begin
    v_plsql_block := '
        declare
            v_area number;
        begin
            v_area := :v_side1 * :v_side2;
            dbms_output.put_line(''v_area is ''||v_area);
            null;
        end;';
    execute immediate v_plsql_block using v_side1, v_side2;
end;    

clear screen;
declare
    v_side1 number := 25;
    v_side2 number := 25;
    v_plsql varchar2(500);
begin
    v_plsql := '
        declare
            v_area number;            
        begin
            v_area := :side1 * :side2;
            dbms_output.put_line(''area is ''||v_area);                        
        end;    ';
        execute immediate v_plsql
            using v_side1, v_side2;
end;    

--this is a variation of the above dynamic pl/sql script
--i passed a variable (v_side1) out of the script after modifying it within the dynamic sql script and displayed it onscreen to show the value was 25 when the math happened and then the value was changed then passed back out to the calling block
clear screen;
declare
    v_side1 number := 25;
    v_side2 number := 25;
    v_plsql varchar2(500);
    v_area number;
begin
    v_plsql := '
        begin
            :v_area := :side1 * :side2; 
            :side1 :=99;
        end;    ';
        execute immediate v_plsql
            using in out v_area, in out v_side1, v_side2; 
        dbms_output.put_line('area is '||v_area);                                    
        dbms_output.put_line('v_side1 is '||v_side1);                                            
end;    

--this dynamic sql pulls back multiple rows which can be looped through
--use OPEN FOR instead of EXECUTE IMMEDIATE for this type of dynamic sql
--remember: use a ref cursor type for your cursor variable
clear screen;
declare
    type t_c1 is ref cursor;
    c1  t_c1;
    
    v_sql   varchar2(500);
    v_zip   varchar2(5) := '10025';
    v_first_name    varchar2(25);
    v_last_name     varchar2(25);
    v_student_id    number;
begin
    v_sql := 'select student_id, first_name, last_name from student.student where zip = :zip';
    open c1 for v_sql using v_zip;
    loop
        fetch c1 into v_student_id, v_first_name, v_last_name;
        exit when c1%notfound;
        dbms_output.put_line('student info: '||v_student_id||' - '||v_first_name||' '||v_last_name);
    end loop;
    close c1;
end;

--below variation uses a table name assigned at runtime rather than hardcoded 
--remember you cannot pass the name of schema objects to dynamic sql at runtime as bind arguments, have to do it beforehand
set serveroutput on
clear screen;
declare
    type t_c1 is ref cursor;
    c1  t_c1;
    v_sql  varchar2(500);
    v_zip   varchar2(5) := '10025';
    v_table_name varchar2(50) := 'student';
    v_student_id    number;
    v_first_name    varchar2(50);
    v_last_name     varchar2(50);
    
begin
    v_sql := 'select first_name, last_name
              from '||v_table_name||' 
              where zip = :zip';
                
    open c1 for v_sql using v_zip;
    loop
        fetch c1 into v_first_name, v_last_name;
        exit when c1%notfound;
        dbms_output.put_line('student info: '||v_first_name||' '||v_last_name);
    end loop;
    close c1;
end;

--this is a variation of the above script to show  student or instructor info
--the difference is i am placing the output from the dynamic sql into a composite record type rather than individual variables
--this is not a big difference from the prior script, but it is how i would approach this in a real life situation more so than individual variables
clear screen;
declare
    type t_c1 is ref cursor;
    c1  t_c1;
    v_sql  varchar2(500);
    v_zip   varchar2(5) := '10025';
    v_table_name varchar2(50) := 'student.instructor';
    
    type t_info is record (first_name   varchar2(50), last_name varchar2(50));
    v_info  t_info;
    
begin
    v_sql := 'select first_name, last_name
              from '||v_table_name||' 
              where zip = :zip';
                
    open c1 for v_sql using v_zip;
    loop
        fetch c1 into v_info;
        exit when c1%notfound;
        dbms_output.put_line('student info: '||v_info.first_name||' '||v_info.last_name);
    end loop;
    close c1;
end;

--book pl/sql by example, chapter 17 excercise #1
--run a pl/ql block using dynamic sql and return the value to the calling environment to display the result
set serveroutput on
clear screen;
declare
    v_plsql varchar2(500);
    v_area number(9,2);
    v_radius number(9,2);
begin
    v_plsql := 'DECLARE
                    v_radius NUMBER := &sv_radius;
                    v_area   NUMBER;
                BEGIN
                    dbms_output.put_line(''v_radius: ''||v_radius);
                    :v_area := POWER(v_radius, 2) * 3.14; 
                END;';
    execute immediate v_plsql using in out v_area;
    DBMS_OUTPUT.PUT_LINE (' RAC The area of the circle is: '||v_area);    
end;                
    
    
--book pl/sql by example, chapter 17 excercise #2
clear screen;
declare
    type t_c1 is ref cursor;
    c1 t_c1;
    
    v_sql varchar2(500);
    v_table_name varchar2(25) := 'student.instructor';
    type t_c1_rec is record (course_no    number, ct number);
    c1_rec  t_c1_rec;
    v_counter   number := 0;
begin
    if v_table_name = 'enrollment' then
        v_sql := 'select course_no, count(*) from enrollment e inner join section s on s.section_id = e.section_id group by course_no';
    else
        v_sql := 'select course_no, count(*) from section group by course_no';
    end if;
    open c1 for v_sql;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        v_counter := v_counter +1;
        dbms_output.put_line('info: '||c1_rec.course_no||' - '||c1_rec.ct);
    end loop;
    dbms_output.put_line('ct: '||v_counter); 
end;    

--this doesn't work because ORA-06562: type of out argument must match type of column or bind variable
--tried to debug for a hour or so but no dice
clear screen;
declare
    v_cursor_id integer;
    v_table_name varchar2(30) := 'employees';
    v_sql varchar2(250) := 'select count(*) from ';
    v_ct    number;    
    v_rows_fetched  number;
begin
    v_cursor_id := dbms_sql.open_cursor;
    
    dbms_sql.parse(v_cursor_id, v_sql||v_table_name, dbms_sql.native);
    
    dbms_sql.define_column(v_cursor_id,1,v_ct,10);
    
    v_rows_fetched := dbms_sql.execute(v_cursor_id);
    
    while dbms_sql.fetch_rows(v_cursor_id) > 0 loop
        dbms_sql.column_value(v_cursor_id,1,v_ct);
    end loop;
    
    dbms_sql.close_cursor (v_cursor_id);
    
    dbms_output.put_line(v_table_name||' :'||v_ct); /*
exception
    when others then
        if dbms_sql.is_open(v_cursor_id) then
            dbms_sql.close_cursor(v_cursor_id);
        end if;
        raise; */
end;



--below is google example but also doesn't work ORA-06562: type of out argument must match type of column or bind variable
--my example above is based on below example so that is why it probably doesn't work for the same reasons
set serveroutput on
DECLARE
    v_cursor_id     INTEGER;
    v_sql_statement VARCHAR2(200);
    v_deptno        NUMBER := 10; -- Bind variable value
    v_dname         VARCHAR2(30);
    v_loc           number(4);
    v_rows_fetched  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('start');
    -- 1. Open a new cursor
    v_cursor_id := DBMS_SQL.OPEN_CURSOR;

    -- 2. Construct the dynamic SQL statement
    v_sql_statement := 'SELECT department_name, location_id FROM departments WHERE department_id = :p_deptno';

    -- 3. Parse the SQL statement
    DBMS_SQL.PARSE(v_cursor_id, v_sql_statement, DBMS_SQL.NATIVE);

    -- 4. Bind variables (if any)
    DBMS_SQL.BIND_VARIABLE(v_cursor_id, ':p_deptno', v_deptno);

    -- 5. Define output columns for a SELECT statement
    DBMS_SQL.DEFINE_COLUMN(v_cursor_id, 1, v_dname, 30); -- Column 1 (dname), type VARCHAR2, max length 20
    DBMS_SQL.DEFINE_COLUMN(v_cursor_id, 2, v_loc, 4);   -- Column 2 (loc), type VARCHAR2, max length 15

    -- 6. Execute the cursor
    v_rows_fetched := DBMS_SQL.EXECUTE(v_cursor_id);

    -- 7. Fetch and process rows (for SELECT statements)
    DBMS_OUTPUT.PUT_LINE('start while');    
    WHILE (DBMS_SQL.FETCH_ROWS(v_cursor_id)) > 0 LOOP
        -- Get column values into PL/SQL variables
        DBMS_SQL.COLUMN_VALUE(v_cursor_id, 1, v_dname);
        DBMS_SQL.COLUMN_VALUE(v_cursor_id, 2, v_loc);

        DBMS_OUTPUT.PUT_LINE('Department Name: ' || v_dname || ', Location: ' || v_loc);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('end while');
    -- 8. Close the cursor
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
    DBMS_OUTPUT.PUT_LINE('end');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('exception');    
        IF DBMS_SQL.IS_OPEN(v_cursor_id) THEN
            DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
        END IF;
        RAISE;
END;
/


select user from dual