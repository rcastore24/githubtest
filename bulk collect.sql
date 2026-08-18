--below is incredibly simple example of a bulk collect into a collection and then listing out part of the collection
--and finally updating the table from the collection
--extremely useful to know (this is a money maker)
declare
    type t_tab is table of source_tab%rowtype;
    l_tab   t_tab;
begin
    select s.*
    bulk collect into l_tab
    from source_tab s
    inner join dest_tab d on s.object_id = d.object_ID
    where s.object_type = 'WINDOW';
    --where owner = 'HR'     and object_type = 'TABLE';
    
    dbms_output.put_line('count: '||l_tab.count);
    
    for i in l_tab.first .. l_tab.last
    loop
        dbms_output.put_line('table_name: '||l_tab(i).object_name||' - '||i||' - '||l_tab(i).object_id);
    end loop;

    forall idx in 1..l_tab.count
        update dest_tab d
            set d.obj_name1 = l_tab(idx).object_name
            where d.object_id = l_tab(idx).object_id; 
end;    



select s.object_type,count(*), sum(count(*)) over () total_ct
from source_tab s
inner join dest_tab d on s.object_id = d.object_id---
--where s.owner = 'HR'
where s.object_type = 'WINDOW'
group by s.object_type

--56492
select count(*)
from source_tab;

--25000
select count(*)
from dest_tab;

select count(*)
from source_tab s, dest_tab b
where s.object_id = b.object_id

alter table dest_tab
add (obj_name1 varchar2(128));

select *
from dest_tab
--where object_id = 76319
where obj_name1 is not null


UPDATE DEST_TAB
SET OBJ_NAME1 = NULL
WHERE OBJ_NAME1 IS NOT NULL


--12/19/24 attempt to replicate above script from memory

declare
    type x_type is table of source_tab%rowtype;
    l_tab      x_type;
begin
    select s.* 
    bulk collect into l_tab
    from source_tab s
    where object_type = 'WINDOW';
    
    dbms_output.put_line('count: '||l_tab.count);       
 
    forall idx in 1..l_tab.count 
    
        update dest_tab
            set obj_name1 = l_tab(idx).object_name
            where object_id = l_tab(idx).object_id;
     
end;    

declare
    type tab_type is table of source_tab%rowtype;
    t_type      tab_type;
begin
    select s.*
    bulk collect into t_type
    from source_tab s
    where s.object_type = 'WINDOW';
    
    dbms_output.put_line('ct: '||t_type.count);
    
    forall idx in 1..t_type.count
        update dest_tab
            set obj_name1 = t_type(idx).object_name
            where object_id = t_type(idx).object_id;
end;
        
        
declare
    type t_type is table of source_tab%rowtype;
    t_coll  t_type;
begin
    select s.*
    bulk collect into t_coll
    from source_tab s
    where object_type = 'WINDOW';
    
    dbms_output.put_line('count: '||t_coll.count);
    
    forall idx in t_coll.first..t_coll.last
    update dest_tab
        set obj_name1 = t_coll(idx).object_name
        where object_id = t_coll(idx).object_id;
    
end;


        
select *
from dest_tab
where obj_name1 is not null
 
 
select es.*, to_char(es.tstamp,'mm/dd/yyyy hh24:mi:ss') stamp
from endangered_species es

--bulk collect entire row into a collection and then display row count of the collection
declare
    type t_es is table of endangered_species%rowtype;
    l_es    t_es;
begin
    l_es := t_es();
    dbms_output.put_line('Count: '||l_es.count);
    select *
        bulk collect into l_es
    from endangered_species;
    
    dbms_output.put_line('Count: '||l_es.count);
    
    forall idx in 1..l_es.count
        update endangered_species
        set tstamp = sysdate
        where common_name = l_es(idx).common_name;
end;    

alter table endangered_species
add(tstamp  date);

--perform bulk collect/bulk update from memory (it works)
--RAC NOTE: this is a nested table collection
set serveroutput on
declare
    type t_source_tab is table of source_tab%rowtype;
    v_source_tab    t_source_tab;
begin
    select *
    bulk collect into v_source_tab
    from source_tab
    where object_type = 'WINDOW';
    
    dbms_output.put_line('ct: '||v_source_tab.count);
    
    for i in v_source_tab.first..v_source_tab.last loop
        dbms_output.put_line('object_name: '||v_source_tab(i).object_name);
    end loop;    
    
    forall idx in 1..v_source_tab.count
        update dest_tab
            set obj_name1 = 'bulk'
            where object_id = v_source_tab(idx).object_id;
end;
    
    
select *
from dest_tab
where object_type = 'WINDOW'


SELECT OBJ_NAME1, COUNT(*)
FROM DEST_TAB
GROUP BY OBJ_NAME1


declare
    type t_dest_tab is table of dest_tab%rowtype;
    v_dest_tab t_dest_tab;
begin
    select dt.*
    --bulk collect into v_dest_tab
    from dest_tab dt
        inner join source_tab st on st.object_id = dt.object_id
    where dt.object_type = 'WINDOW';
    
    dbms_output.put_line('ct: '||v_dest_tab.count);    
    
    forall idx in v_dest_tab.first..v_dest_tab.last
        update dest_tab
        set obj_name1 = v_dest_tab(idx).object_name||'bulk update'
        where object_id = v_dest_tab(idx).object_id;
end;


declare
    type t_dest_tab is table of dest_tab%type;
    v_dest_tab  t_dest_tab;
begin
    select * 
    bulk collect into v_dest_tab
    
    
--this is an ai script (slightly tweaked to match my db/data) - it works
DECLARE
    -- Define a collection type based on the table
    TYPE emp_tab IS TABLE OF employees%ROWTYPE;
    l_employees emp_tab;
BEGIN
    -- 1. Bulk fetch into memory
    SELECT * BULK COLLECT INTO l_employees 
    FROM employees 
    WHERE department_id = 50;

    -- 2. Bulk insert into another table
    FORALL i IN 1..l_employees.COUNT
        INSERT INTO employees_bulk_collect VALUES l_employees(i);
        
    COMMIT;
END;
    
    
select count(*)
from employees_bulk_collect

declare
    type t_source_tab is table of source_tab%rowtype;
    nt_source_tab   t_source_tab;
begin
    select s.*
    bulk collect into nt_source_tab
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    and s.object_type = 'WINDOW';

    forall idx in 1..nt_source_tab.last
        update dest_tab
            set obj_name1 = nt_source_tab(idx).object_name
            where object_id = nt_source_tab(idx).object_id;
            
    dbms_output.put_line('ct: '||nt_source_tab.count);        
end;            

declare
    type t_source_tab is table of source_tab%rowtype;
    v_source_tab t_source_tab;
begin 
    select s.* 
    BULK COLLECT into v_source_tab
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    and s.object_type = 'WINDOW';
    
    forall idx in 1..v_source_tab.last
        update dest_tab  dt
            set dt.obj_name1 = v_source_tab(idx).object_name
            where dt.object_id = v_source_tab(idx).object_id;
    dbms_output.put_line('ct: '||v_source_tab.count);                    
end;            

--remember the bulk collect clause comes after the select clause but before the from clause
declare
    type t_source_tab is table of source_tab%rowtype;
    nt_source_tab   t_source_tab;
begin
    select s.* 
    bulk collect into nt_source_tab
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall idx in 1..nt_source_tab.last
        update dest_tab dt
        set obj_name1 = nt_source_tab(idx).object_name
        where dt.object_id = nt_source_tab(idx).object_id;
        
end;

--remember if using %rowtype to declare your nt record type, your select columns must match the nested table columns (i.e., i had to use s* instaead of * which includes dest_table columns because of the join
--remember you can use a %rowtype to declare nested table
declare
    type t_nt  is table of source_tab%rowtype;
    v_nt t_nt;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on d.object_id = s.object_id
    where s.object_type = 'WINDOW';
    
    dbms_output.put_line('ct: '||v_nt.count);
    forall i in 1..v_nt.last
        update dest_tab d2
            set obj_name1 = v_nt(i).object_name
            where d2.object_id = v_nt(i).object_id;
end;            

--remember bulk collect clause goes between select and from clauses
--rememeber forall immediately goes into a range loop (1..nested table.last), but does not have a loop keyword (and not end loop of course)
--remember update statement includes full nested table nomenclature (e.g., v_nt(i).object_name)
declare
    type t_nt is table of source_tab%rowtype;
    v_nt t_nt := t_nt();
begin
    select s.* 
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall i in 1..v_nt.last 
        update dest_tab d2
            set d2.obj_name1 = v_nt(i).object_name
            where d2.object_id = v_nt(i).object_id;
end;            
    
declare
    type t_source is table of source_tab%rowtype;
    v_nt t_source;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall i in 1..v_nt.last
        update dest_tab d2
            set d2.obj_name1 = v_nt(i).object_name
            where d2.object_id = v_nt(i).object_id;
end;            

--don't forget to indicate bulk collect should insert into nested table (i.e., bulk collect into v_nt)    
declare
    type t_rec is table of source_tab%rowtype;
    v_nt t_rec;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall i in 1..v_nt.last
        update dest_tab d2
            set d2.obj_name1 = v_nt(i).object_name
            where d2.object_id = v_nt(i).object_id;
end;            

--rac note: you can use %rowtype or declare a record with individual columns as I did below
declare
    type t_rec is record(object_id number, object_name varchar2(128));
    type t_nt is table of t_rec;
    v_nt t_nt;
begin
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall i in 1..v_nt.last
        update dest_tab 
            set obj_name1 = v_nt(i).object_name
            where object_id = v_nt(i).object_id;
end;
    
declare
    type t_rec is table of source_tab%rowtype;
    v_nt t_rec;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type =   'WINDOW';
    
    forall i in 1..v_nt.last
        update dest_tab
            set obj_name1 = v_nt(i).object_name
            where object_id = v_nt(i).object_id;
end;    

declare
    type t_rec is table of source_tab%rowtype;
    v_nt t_rec := t_rec();
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    and s.object_type = 'WINDOW';

    forall i in 1..v_nt.last 
        update dest_tab d2
        set obj_name1 = v_nt(i).object_name
        where d2.object_id = v_nt(i).object_id;
end;

declare
    type t_nt is table of source_tab%rowtype;
    v_nt t_nt;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    and s.object_type = 'WINDOW';
    
    forall idx in 1..v_nt.last
        update dest_tab d2
        set d2.obj_name1 = v_nt(idx).object_name
        where d2.object_id = v_nt(idx).object_id;
    dbms_output.put_line('ct: '||v_nt.last);    
end;

declare
    type t_emp is table of source_tab%rowtype;
    v_source_tab t_emp;
begin
    select s.* 
    --bulk collect into v_source_tab
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall idx in 1..v_source_tab.last
        update dest_tab  dt
            set dt.obj_name1 = v_source_tab(idx).object_name
            where dt.object_id = v_source_tab(idx).object_id;
    dbms_output.put_line('ct: '||v_source_tab.count);        
end;    

declare
    type t_rec is table of source_tab%rowtype;
    v_nt t_rec;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    forall x in 1..v_nt.last
        update dest_tab d2
        set obj_name1 = v_nt(x).object_name
        where d2.object_id = v_nt(x).object_id;
end;    

declare    
    type t_nt is table of source_tab%rowtype;
    v_nt    t_nt := t_nt();
begin
    select s.* 
    bulk collect into v_nt
    from source_tab s 
    left join dest_tab d on s.object_id = d.object_id
    where s.object_type = 'WINDOW';

    forall x in 1..v_nt.last
        update dest_tab d
        set d.obj_name1 = v_nt(x).object_name
        where d.object_id = v_nt(x).object_id;
end;

declare
    type t_nt  is table of source_tab%rowtype;
    v_nt t_nt;
begin
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';

    forall x in 1..v_nt.last 
        update dest_tab d2
            set d2.obj_name1 = v_nt(x).object_name
            where d2.object_id = v_nt(x).object_id;
end;    
    
--this bulk collect process will use the save exceptions clause which places error records into the implicit sql%bulk_collections collection   
--note1: below works but i forced it to fail on all rows rather than selectively failing on a couple of rows
--note2: to selectively cause rows to fail, need to NOT base type t_nt on the source table, need to use a value larger than student.test.row_test column to accommodate the larger value which will allow a too large string to be assigned and then it will fail during the forall stmt as expected
clear screen;
declare
    type t_nt is table of source_tab%rowtype;
    v_nt t_nt;
    
    e_bulk_error    exception;
    pragma exception_init(e_bulk_error,-24381);
    v_count number;
begin
    select count(*) into v_count from dest_tab where obj_name1 is not null;
    dbms_output.put_line('obj_name1 is not null ct: '||v_count);
    if v_count > 0 then
        update dest_tab
            set obj_name1 = null
            where obj_name1 is not null;
    end if;
    select s.*
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    dbms_output.put_line('v_nt ct: '||v_nt.count);
    
    for x,y in pairs of v_nt loop
        dbms_output.put_line('index: '||x||' object_type: '||y.object_type);
    end loop;
    
    --v_nt(2).object_type := rpad(v_nt(2).object_type,24,' ');
    --v_nt(4).object_type := rpad(v_nt(2).object_type,24,' ');    
--    dbms_output.put_line('post making error');    

    forall i in 1..v_nt.last save exceptions
        update dest_tab
            set obj_name1 = rpad(v_nt(i).object_name,128,' ')||' '
            where object_id = v_nt(i).object_id;
exception
    when e_bulk_error then
        dbms_output.put_line('entering bulk error handler');    
        dbms_output.put_line('bulk error ct: '||sql%bulk_exceptions.count);
        for i in 1..sql%bulk_exceptions.count loop
            dbms_output.put_line('error row num: '||sql%bulk_exceptions(i).error_index||' error msg: '||sqlerrm(-sql%bulk_exceptions(i).error_code));
        end loop;
    when others then        
        dbms_output.put_line('entering other error handler');        
        dbms_output.put_line('other error: '||sqlerrm);
end;    

--this works!!! lotta typos and syntax errors but it works
clear screen;
declare
    type t_rec is record (object_id number, object_name varchar2(130));
    type t_nt   is table of t_rec;
    v_nt t_nt;
    
    e_bulk_exception    exception;
    pragma exception_init(e_bulk_exception, -24381);
begin
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    dbms_output.put_line('v_nt ct: '||v_nt.count);
    
    v_nt(1).object_name := rpad(v_nt(1).object_name,130,' ');
    v_nt(5).object_name := rpad(v_nt(1).object_name,130,' ');
    v_nt(7).object_name := rpad(v_nt(1).object_name,130,' ');    
    
    forall i in 1..v_nt.last save exceptions
        update dest_tab
            set obj_name1 = v_nt(i).object_name
            where object_id = v_nt(i).object_id;
exception
    when e_bulk_exception then        
        dbms_output.put_line('sql%bulk_exceptions ct: '||sql%bulk_exceptions.count);    
        for x in 1..sql%bulk_exceptions.count loop
            dbms_output.put_line('exception index: '||sql%bulk_exceptions(x).error_index||' exception error '||sqlerrm(-sql%bulk_exceptions(x).error_code));
        end loop;
    when others then
        dbms_output.put_line('other error: '||sqlerrm);        
end;    

clear screen;
declare
    type t_rec is record (object_id number, object_name varchar2(130));
    type t_nt is table of t_rec;
    v_nt    t_nt;
    
    e_bulk_exception    exception;
    pragma exception_init(e_bulk_exception,-24381);
begin
    dbms_output.put_line('start date/time: '||to_char(sysdate,'mm/dd/yyyy hh24:mi:ss'));
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    dbms_output.put_line('v_nt ct: '||v_nt.count);
    
    v_nt(1).object_name := rpad(v_nt(1).object_name,130,' ');
    v_nt(5).object_name := rpad(v_nt(5).object_name,130,' ');    
    v_nt(7).object_name := rpad(v_nt(7).object_name,130,' ');    
    
    forall x in 1..v_nt.last save exceptions
        update dest_tab
            set obj_name1 = v_nt(x).object_name
            where object_id = v_nt(x).object_id;

exception
    when e_bulk_exception then
        dbms_output.put_line('bulk exception error encountered: '||sqlerrm);
        dbms_output.put_line('sql%bulk_exceptions ct:'||sql%bulk_exceptions.count);       
        for x in 1..sql%bulk_exceptions.count loop
            dbms_output.put_line('error index: '||sql%bulk_exceptions(x).error_index||' errmsg: '||sqlerrm(-sql%bulk_exceptions(x).error_code));
        end loop;
    when others then
        dbms_output.put_line('other error encountered: '||sqlerrm);
end;    


    
clear screen;
declare
    type t_nt is table of student.zipcode%rowtype index by pls_integer;
    v_nt t_nt;
begin
    null;
end;    
select * from student.zipcode    

--oracle pl/sql by example book chapter 18 excercise #1
--populate new my_section table using forall with the save exceptions clause
--rac note: this script uses 11 different associative arrays (1 for each column in the table), no one would ever write a script like this (editorial)
--rac note:2: I added begin..exception..end around the forall stmt because I wasn't seeing the after count at the end of the script because focus had gone into the exception handler and it stopped processing there
--rac note2a: I could have also put the after count inside the exception handler (in both places) and it would also have shown then
set serveroutput on
clear_screen;
declare
    type t_num is table of number index by pls_integer;
    type t_string is table of varchar2(100) index by pls_integer;
    type t_date is table of date index by pls_integer;
    
    v_section_id        t_num;
    v_course_no         t_num;
    v_section_no        t_num;
    v_start_date_time   t_date;
    v_location          t_string;
    v_instructor_id     t_num;
    v_capacity          t_num;
    v_created_by        t_string;
    v_created_date      t_date;
    v_modified_by       t_string;
    v_modified_date     t_date;
    
    v_total number;
    
    e_bulk_exceptions   exception;
    pragma exception_init  (e_bulk_exceptions,-24381);
begin
    select count(*) into v_total from student.my_section;    
    if v_total >0 then
        delete from student.my_section;
        commit;
    end if;    
    dbms_output.put_line('before load ct: '||v_total);
    select *
    bulk collect into v_section_id, v_course_no, v_section_no, v_start_date_time, v_location, v_instructor_id, v_capacity, v_created_by, v_created_date, v_modified_by, v_modified_date
    from section;
    
    v_location(1) := rpad(v_location(1),100,' ');
    v_location(5) := rpad(v_location(5),100,' ');
    v_location(7) := rpad(v_location(7),100,' ');    
    
    begin
    forall i in 1..v_section_id.count save exceptions
        insert into student.my_section
            values(v_section_id(i), v_course_no(i), v_section_no(i), v_start_date_time(i), v_location(i), v_instructor_id(i), v_capacity(i), v_created_by(i), 
                v_created_date(i), v_modified_by(i), v_modified_date(i));
    exception
        when e_bulk_exceptions then
            dbms_output.put_line('bulk errors ct: '||sql%bulk_exceptions.count);    
            for z in 1..sql%bulk_exceptions.count loop
                dbms_output.put_line('index: '||sql%bulk_exceptions(z).error_index||' error message: '||sqlerrm(-sql%bulk_exceptions(z).error_code));
            end loop;
        when others then
            dbms_output.put_line('error encountered ct: '||sqlerrm);                
    end;            
            
    select count(*) into v_total from student.my_section;       
    dbms_output.put_line('after load ct: '||v_total);
exception
    when e_bulk_exceptions then
        dbms_output.put_line('bulk errors ct: '||sql%bulk_exceptions.count);    
        for z in 1..sql%bulk_exceptions.count loop
            dbms_output.put_line('index: '||sql%bulk_exceptions(z).error_index||' error message: '||sqlerrm(-sql%bulk_exceptions(z).error_code));
        end loop;
    when others then
        dbms_output.put_line('error encountered ct: '||sqlerrm);
end;    

--chapter 18 exercises problem#2 - use a collection of records instead of individual arrays
--rac note: this is a lot more like what a real programmer would do
clear screen;
declare
    type t_tab is table of section%rowtype index by pls_integer;
    v_tab t_tab;
    
    v_counter number := 0;
begin
    delete from student.my_section;
    commit;
    select *
    bulk collect into v_tab
    from student.section;
    dbms_output.put_line('v_tab ct: '||v_tab.count);
    
    forall i in 1..v_tab.last save exceptions
        insert into student.my_section
            values(v_tab(i).section_id, v_tab(i).course_no, v_tab(i).section_no, v_tab(i).start_date_time, v_tab(i).location, v_tab(i).instructor_id, v_tab(i).capacity, v_tab(i).created_by, v_tab(i).created_date, v_tab(i).modified_by, v_tab(i).modified_date);
    select count(*) into v_counter from student.my_section;            
    dbms_output.put_line('my_section ct: '||v_counter);
    
end;    

clear screen;
declare
    type t_rec is table of section%rowtype index by pls_integer;
    v_tab t_rec;
    v_count number := 0;
begin
    select count(*) into v_count from student.my_section;            
    dbms_output.put_line('my_section ct: '||v_count);
    
    select *
    bulk collect into v_tab
    from student.section;
    dbms_output.put_line('v_tab ct: '||v_tab.count);
    
    forall i in 1..v_tab.last save exceptions
        insert into student.my_section
            values(v_tab(i).section_id, v_tab(i).course_no, v_tab(i).section_no, v_tab(i).start_date_time, v_tab(i).location, v_tab(i).instructor_id, v_tab(i).capacity, v_tab(i).created_by, v_tab(i).created_date, v_tab(i).modified_by, v_tab(i).modified_date);            
    select count(*) into v_count from student.my_section;            
    dbms_output.put_line('my_section ct: '||v_count);
end;    

--chapter 18 pl/sql by example book excercise #4
--remove records from a table and use RETURNING clause to store the values in a collection to be displayed afterwards
--rac note: the given exercise wanted to use separate coto store different columns (not realistic in real life) so I used a record with multiple columns instead
clear screen;
declare
    type t_rec is record (section_id    number, location varchar2(100));
    type t_tab is table of t_rec;
    v_tab t_tab;
begin
    delete from student.my_section
    where location = 'L211'
    returning section_id, location
    bulk collect into v_tab;
    
    dbms_output.put_line('v_tab ct: '||v_tab.count);
    for i in 1..v_tab.last loop
        dbms_output.put_line('location: '||v_tab(i).location||' section id: '||v_tab(i).section_id);
    end loop;
end;

delete from student.my_section

select count(*)
from student.my_section


select student_id, first_name, last_name, count(*)
from student s
inner join enrollment e
using (student_id)
group by student_id, first_name, last_name

clear screen;
declare
    type t_rec is record (object_id number, object_name varchar2(120));
    type t_nt is table of t_rec;
    v_nt    t_nt := t_nt();
begin
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    dbms_output.put_line('ct: '||v_nt.count);
    
    forall i in 1..v_nt.last
        update dest_tab2
            set obj_name1 = v_nt(i).object_name
            where object_id = v_nt(i).object_id;
end;            

clear screen;
declare
    type t_rec is record (object_id number, object_name varchar2(120));
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW';
    
    dbms_output.put_line('count: '||v_nt.count);
    
    forall i in 1..v_nt.last
        update dest_tab
        set obj_name1 = v_nt(i).object_name
        where object_id = v_nt(i).object_id; 
end;

clear screen;
declare
    type t_rec is record(object_id  number, object_name varchar2(120));
    type t_nt is table of t_rec;
    v_nt t_nt := t_nt();
begin
    select s.object_id, s.object_name
    bulk collect into v_nt
    from source_tab s
    inner join dest_tab d
    on s.object_id = d.object_id
    where s.object_type = 'WINDOW'
    fetch first 5 rows only;
    
    forall i in 1..v_nt.last
        update dest_tab
        set obj_name1 = v_nt(i).object_name
        where object_id = v_nt(i).object_id;
    dbms_output.put_line('ct: '||v_nt.count);
end;

select user from dual    
select *
from dest_tab
where obj_name1 is not null