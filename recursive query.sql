--copied from google ai (it works)
--
WITH Employee_Hierarchy (emp_id, emp_name, mgr_id, lvl) AS (
  -- Anchor Member: Start with the CEO (who has no manager)
  SELECT employee_id, last_name, manager_id, 1
  FROM employees
  WHERE manager_id IS NULL
  
  UNION ALL
  
  -- Recursive Member: Join the CTE back to the employees table
  SELECT e.employee_id, e.last_name, e.manager_id, eh.lvl + 1
  FROM employees e
  INNER JOIN Employee_Hierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM Employee_Hierarchy ORDER BY lvl;

--copied from google ai (it works)
--older, legacy technique to get hierarchy
SELECT employee_id, last_name, manager_id, LEVEL
FROM employees
START WITH manager_id IS NULL  -- Defines the root
CONNECT BY PRIOR employee_id = manager_id; -- Defines the parent-child relationship

