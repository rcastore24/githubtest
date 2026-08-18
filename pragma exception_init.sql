--raise exception for a user defined exception
set serveroutput on
declare
    e_exception exception;
    pragma exception_init(e_exception,-20001);
begin
    null;
    raise_application_error(-20001,'err msg');
    
 DBMS_OUTPUT.PUT_LINE('Transaction processed successfully.');
    
exception
when e_exception then
    dbms_output.put_line('exception err: '||sqlerrm);
when others then
    dbms_output.put_line('other err: '||sqlerrm);
end;    

--below is testing when you raise an error for an undeclared error message 
declare
    e_exception exception;
    pragma exception_init(e_exception,-20001);
begin
    null;
    raise_application_error(-20000,'raise err msg');
    dbms_output.put_line('complete msg');
exception 
    when e_exception then
            dbms_output.put_line('e_exception msg '||sqlerrm);
    when others then
            dbms_output.put_line('others msg '||sqlerrm);    
end;            

set serveroutput on
declare
    e_user_defined_exception    exception;
    pragma exception_init(e_user_defined_exception,-20001);
begin
    null;
    raise e_user_defined_exception;
exception
    when e_user_defined_exception then
        dbms_output.put_line('user defined exception raised');
    when others then
        dbms_output.put_line('other exception raised');
end;        
        
    