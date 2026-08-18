--cast function

SELECT CAST('123.456' AS NUMBER(5,2)) 
FROM DUAL;

SELECT CAST(12345 AS VARCHAR2(10)) FROM DUAL;

declare
    type emp_names_tab is record emp.%rowtype;
begin    /*
    SELECT
        CAST(MULTISET(SELECT ename FROM emp) AS emp_names_tab) AS hr_employee_names
        from dual; */
        null;
end;