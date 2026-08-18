SELECT *
FROM USER_TRIGGERS
WHERE TABLE_NAME = 'EMPLOYEES';

--using employees table as starting point/inspiration
create table salary_audit(
    employee_id         number(6),
    old_salary          number(8,2),
    new_salary          number(8,2),
    change_date         date
    );


--below compound trigger works as written=>updates occur and an audit log of the 2 changes is writtn to salary audit table
--trigger populates an array with employee info and old/new salary values and then writes the changes to the table after the statement has completed it changes
--i can see this being a big deal - also as an interview question about how to prevent mutating table errors
create or replace trigger trg_salary_audit
for update of salary on employees --trigger fires on salary updates
compound trigger
    type t_salary_audit is table of salary_audit%rowtype index by pls_integer;
    v_audit_data    t_salary_audit;
    v_idx   pls_integer := 0;
    
    before each row is
    begin
        v_idx := v_idx + 1;
        v_audit_data(v_idx).employee_id := :old.employee_id;
        v_audit_data(v_idx).old_salary := :old.salary;
        v_audit_data(v_idx).new_salary := :new.salary;
        v_audit_data(v_idx).change_date := sysdate;
    end before each row;
    
    --after the statement, insert all audit records in bulk
    after statement is
    begin
        forall i in 1..v_idx
            insert into salary_audit values v_audit_data(i);
    end after statement;
end trg_salary_audit ;

--select count(*)
select *
from salary_audit

select *
from employees
where employee_id in (128,136);

--
update employees
set salary = 2250
where employee_id in (128,136)
