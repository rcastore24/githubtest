select *
from jobs
where regexp_like (job_title,'manager','i')

--this is a basic old school loop that I did from memory
declare
    cursor c1 is
        select *
        from jobs
        where regexp_like (job_title,'manager','i');
    c1_row  c1%rowtype;
begin
    dbms_output.put_line('start: ');
    open c1;
    loop
        fetch c1 into c1_row;
        exit when c1%notfound;        
        dbms_output.put_line('job title: '||c1_row.job_title);
    end loop;
    close c1;
end;

declare
    cursor c1 is
        select *
        from jobs
        where regexp_like (job_title,'manager','i');
    c1_row  c1%rowtype;
begin
    dbms_output.put_line('start: ');
    open c1;
    loop
        fetch c1 into c1_row;
        exit when c1%notfound;        
        dbms_output.put_line('job title: '||c1_row.job_title);
    end loop;
    close c1;
end;


--FOR LOOP EXAMPLE (using sql select)
begin
    dbms_output.put_line('start: '||to_char(sysdate,'yyyymmdd hh24:mi:ss'));
    for c1_row in (
        select j.*, rownum
        from jobs j
        where regexp_like (job_title,'manager','i')
        ) loop
        dbms_output.put_line('for loop job title: '||c1_row.rownum||' '||c1_row.job_title);        
    end loop;
exception
    when others then
	  rollback;
      dbms_output.put_line(dbms_utility.format_error_backtrace);    
end;    

--for loop using a defined range
declare
    cnt number := 0;
begin
    for var in 1..3
    loop
      cnt := cnt+2; 
    end loop;
    dbms_output.put_line('cnt: '||cnt);
end;

--while loop => loop until while condition is no longer true
declare
   v_count number :=  1;
begin
   while v_count <=3 
   loop
        dbms_output.put_line('count: '||v_count);
        v_count := v_count + 1;        
    end loop;
end;



--basic old school loop done from memory
declare
    cursor c1 is select * from employees;
    c1_rec      employees%rowtype;
    v_count number :=0;
begin
    open c1;
        loop
            fetch c1 into c1_rec;
            exit when c1%notfound;
            exit when v_count =5; --Note: I added this extra exit to test how to exit a loop based on multiple conditions =>it works as is
            v_count := v_count + 1;            
        end loop;
    dbms_output.put_line('emp ct:'||v_count);
    close c1;
end;    

--for loop using embedded select stmt (de facto cursor)
declare
    v_ct    number := 0;
begin
    for x in (  
        select *
        from source_tab
        where object_type = 'WINDOW')
    loop
        v_ct := v_ct + 1;
        dbms_output.put_line('Num: '||v_ct||' OBJECT_ID: '||x.OBJECT_ID);        
    end loop;
    
    dbms_output.put_line('ct: '||v_ct);
end;

--same logic as above except using a named cursor rather than an embedded cursor
declare
    cursor c1 is 
        select * from source_tab where object_type = 'WINDOW';
    v_ct number := 0;
begin
    for c1_rec in c1
    loop
        v_ct := v_ct + 1;
        dbms_output.put_line('Num: '||v_ct||' OBJECT_ID: '||c1_rec.OBJECT_ID);     
    end loop;
    dbms_output.put_line('ct: '||v_ct);   
end;

--for loop for fixed number of lines
--use this when you want to run a loop a specific number of times
declare
    v_ct    number := 0;
begin
    for x in 1..5
    loop
        v_ct := v_ct + 1;
    end loop;
    
    dbms_output.put_line('ct: '||v_ct);

end;

--while loop
declare
    chk_val number := 0;
    v_ct    number := 0;
begin
    while chk_val <= 1000
    loop
        chk_val := chk_val + 50;
        v_ct := v_ct + 1;
    end loop;
    dbms_output.put_line ('ct: '||v_ct);
    dbms_output.put_line ('chk_val: '||chk_val);
end;    
        
--look for prefix ^ or suffix $ using regexp_like        
begin
    for x in (
        select * from jobs
        where regexp_like (job_title,'^Stock','c')
        or regexp_like(job_title,'Manager$','c')
        )  loop
            dbms_output.put_line(x.job_title);
    end loop;
end;       

--intervew question - Write a PL/SQL block to calculate the factorial of a number. 
--uses a for loop with a defined interval
declare
    prod number := 1;
begin
    for var in 1..4 loop
        prod := prod * var;
     end loop;
     dbms_output.put_line('prod: '||prod);
exception
    when others then
            dbms_output.put_line('error: '||sqlerrm);
end;     

--simple for loop done from memory
--forgot the loop keyword after the sql stmt=> I always forget this 
set serveroutput on
begin
   for c1 in (select j.*, rownum rt
              from jobs j
              where regexp_like (job_title,'manager','i')) loop
      dbms_output.put_line(c1.rt||' - '||c1.job_id||' - '||c1.job_title);
   end loop;               
end;   

--old school loop from memory, remember to put the exit after the fetch so you don't double count the row before exiting loop
set serveroutput on
declare
cursor c1  is select j.*, rownum rt
              from jobs j
              where regexp_like (job_title,'manager','i');
    c1_row  c1%rowtype;              
    row_ct  number := 0;
begin
    open c1;
    loop
        fetch c1 into  c1_row;
        exit when c1%notfound;        
        row_ct := row_ct + 1;
        dbms_output.put_line('job_id '||c1_row.job_id);        
    end loop;
    dbms_output.put_line('rowct: '||row_ct);
end;

--while loop using declared cursor into a row variable, remember to open/close cursor
declare 
    cursor c1 is select j.*, rownum rt
              from jobs j
              where regexp_like (job_title,'manager','i');
    c1_row c1%rowtype;
    v_row_ct number := 0;
begin
    open c1;
    while v_row_ct < 3 loop
        fetch c1 into c1_row;
        v_row_ct := v_row_ct +1;
        dbms_output.put_line('job_id '||c1_row.job_id);        
    end loop;    
    dbms_output.put_line('rowct: '||v_row_ct);
    close c1;
end;    