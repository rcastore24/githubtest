select *
from jobs
where regexp_like (job_title,'manager','i')

declare cursor c1 is
    select *
    from jobs
    where regexp_like (job_title,'manager','i')
    order by min_salary;
    c1_row c1%rowtype;    
begin
    open c1;
    loop
        fetch c1 into c1_row;
        exit when c1%notfound;
        dbms_output.put_line('min sal-'||c1_row.min_salary);
    end loop;
    close c1;
end;    
    
    
    
--for loop --do this again, remember the structor the loop
begin
    dbms_output.put_line('start time - '||to_char(sysdate,'mm/dd/yyyy dd:hh:mi'));
    for c1 in (
        select *
        from jobs
        where regexp_like (job_title,'manager','i')
        order by min_salary ) loop 
        dbms_output.put_line('min sal-'||c1.min_salary);       
    end loop;
    dbms_output.put_line('end time - '||to_char(sysdate,'mm/dd/yyyy dd:hh:mi'));       
exception
    when others then
	  rollback;
      dbms_output.put_line(dbms_utility.format_error_backtrace);       
end;        


begin
    dbms_output.put_line('start time - '||to_char(sysdate,'mm/dd/yyyy dd:hh:mi'));
    for c1 in (
    select * from jobs
    where regexp_like (job_title,'manager','i')    
    order by min_salary
    ) loop
        dbms_output.put_line('min sal-'||c1.min_salary);        
    
    end loop;
    dbms_output.put_line('end time - '||to_char(sysdate,'mm/dd/yyyy dd:hh:mi'));           
end;    

--for loop with defined range
declare
    cnt number := 0;
begin
    for l in 1..4 loop
        cnt := cnt + 1;
    end loop;
    dbms_output.put_line('cnt: '||cnt);
end;    
        
        

declare
   cnt number := 0;
begin
    while cnt < 5 loop
        cnt := cnt +1;
            dbms_output.put_line('cnt: '||cnt);
        end loop;
end;
    