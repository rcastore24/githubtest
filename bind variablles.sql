--rac note: I got most of the below example from google, but it was wrong
--i tweaked the original by adding 2 variables before the begin and setting the bind variables within the main block (and it worked correctly)
--just a note to not always trust google's code
set define off
set serveroutput on
variable emp_id number
variable new_sal number
DECLARE
  v_employee_id NUMBER := 132;
  v_new_salary  NUMBER := 2150;
BEGIN
 :emp_id := 132;
 :new_sal := 2150;
  -- Using bind variables in an UPDATE statement
  UPDATE employees
  SET salary = :new_sal
  WHERE employee_id = :emp_id;

  -- Using bind variables in a SELECT INTO statement
  SELECT salary INTO v_new_salary
  FROM employees
  WHERE employee_id = :emp_id;

  DBMS_OUTPUT.PUT_LINE('Employee ' || v_employee_id || ' new salary: ' || v_new_salary);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

--emp id = 132, salary 2100
select *
from employees
order by salary