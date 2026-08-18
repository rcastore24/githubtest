--got this from google ai (it works)
SELECT
    level,
    employee_id,
    manager_id,
    last_name
FROM
    employees
START WITH
    manager_id IS NULL -- Starts with the top-level manager
CONNECT BY PRIOR
    employee_id = manager_id; -- Links employees to their managers