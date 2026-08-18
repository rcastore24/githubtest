
    
    
begin
    dbms_output.put_line('RAC1');
    goto label1;
    dbms_output.put_line('RAC2');
    <<Label1>>
    dbms_output.put_line('RAC3');
end;    