-- ***************************************
-- DBS311 - Fall 2023
-- Lab 3
-- Sub-Select
-- 
-- <WAI SUN LAM>
-- <146691225>
-- <02/10/2023>
-- ***************************************
-- Q1
INSERT INTO employees
    VALUES(300, 'WAISUN', 'LAM', 'WLAM', '123.456.7890', '29-SEP-23', 'AD VP', NULL, 0.21, 100, 90);

-- Q2
UPDATE employees SET salary = 2500
WHERE UPPER(last_name) LIKE ('MATOS%') OR UPPER(last_name) LIKE ('WHALEN%');

-- Q3
COMMIT;

--Q4
SELECT 
    e.last_name
FROM employees e
WHERE e.department_id IN (
    SELECT 
        d.department_id
    FROM employees d
    WHERE UPPER(d.last_name) LIKE '%' || TRIM(UPPER('Abel')) || '%'
);
 
-- Q5
SELECT 
    last_name
FROM employees
WHERE salary = (
SELECT
    MIN(salary)
FROM employees
);

-- Q6
SELECT
    city
FROM locations l
WHERE l.location_id IN (
SELECT
 d.location_id
FROM departments d
WHERE d.department_id IN (
    SELECT 
        e.department_id
    FROM employees e
    WHERE e.salary = (  
    SELECT
    MIN(salary)
FROM employees 
)));

-- Q7
SELECT 
    e.last_name, 
    e.department_id, 
    e.salary
FROM employees e
WHERE (e.department_id, e.salary) IN (
    SELECT 
       department_id,
        MIN(salary)
    FROM employees 
    GROUP BY department_id
)
ORDER BY e.department_id;

-- Q8
SELECT 
    last_name, 
    city, 
    salary 
FROM (
    SELECT 
        last_name, 
        city, 
        salary 
    FROM 
        employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN locations l ON d.location_id = l.location_id
)
WHERE (city, salary) IN (
    SELECT 
        city, 
        MIN(salary) 
    FROM (
        SELECT 
        last_name, 
        city, 
        salary 
    FROM 
        employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN locations l ON d.location_id = l.location_id
)
    GROUP BY city
);

    
-- Q9
SELECT
    e.last_name,
    e.salary
FROM employees e
WHERE e.salary < (
    SELECT MAX(minSalary)
    FROM (
        SELECT MIN(salary) AS minSalary
        FROM employees
        GROUP BY department_id
    )
)
ORDER BY e.salary DESC, e.last_name;

-- 10
SELECT
    last_name,
    job_id,
    salary
FROM employees
WHERE salary IN (
    SELECT
        salary
    FROM employees
    WHERE UPPER(job_id) = 'IT_PROG'
)
ORDER BY salary DESC, last_name;


    









