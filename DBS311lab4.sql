-- ***************************************
-- DBS311 - Fall 2023
-- Lab 4
-- Set-Operators
-- 
-- <WAI SUN LAM>
-- <146691225>
-- <08/10/2023>
-- ***************************************

-- Q1
-- Fetch all department IDs
SELECT department_id 
FROM employees 
MINUS 
SELECT department_id 
FROM employees 
WHERE job_id = 'ST_CLERK';

-- Q2
SELECT
    country_id,
    country_name
FROM countries
MINUS
SELECT 
    l.country_id,
    c.country_name 
FROM countries c 
JOIN locations l ON c.country_id = l.country_id 
JOIN departments d ON l.location_id = d.location_id;

-- Q3
SELECT DISTINCT
    job_id, 
    department_id 
FROM employees
WHERE department_id = 10
UNION ALL
SELECT DISTINCT 
    job_id, 
    department_id 
FROM employees 
WHERE department_id = 50
UNION ALL
SELECT DISTINCT 
    job_id, 
    department_id 
FROM employees 
WHERE department_id = 20;

-- Q4
SELECT 
    employee_id,
    job_id
FROM employees
INTERSECT
SELECT 
    employee_id,
    job_id
FROM job_history;

-- Q5
SELECT
    e.last_name,
    e.department_id,
    d.department_name
FROM employees e 
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT
    e.last_name,
    d.department_id,
    d.department_name
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id
ORDER BY department_id;
