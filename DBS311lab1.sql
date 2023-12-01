-- ***********************
-- Name: WAI SUN LAM
-- ID: 146691225
-- Date: 09/09/2023
-- Purpose: Lab 1 DBS311
-- ***********************

UPDATE employees SET hire_date = hire_date + (20*365);
UPDATE job_history SET end_date = end_date + (20*365);
UPDATE job_history SET start_date = start_date + (20*365);

-- QUESTION 1

SELECT last_name AS "LName", 
       job_id AS "Job_Title", 
       hire_date AS "Job_Start"
FROM employees;

-- QUESTION 2

SELECT 
    employee_id,
    last_name,
    TO_CHAR(salary, '$99,999') AS salary
FROM employees
WHERE salary BETWEEN 8000 AND 11000
ORDER BY salary DESC, last_name;

-- QUESTION 3

SELECT 
    employee_id,
    last_name,
    salary
FROM employees
WHERE salary BETWEEN 8000 AND 11000
ORDER BY salary DESC, last_name;

-- QUESTION 4

SELECT 
    job_id AS "Job Title",
    first_name || ' ' || last_name AS "Full name"
FROM employees
WHERE UPPER(first_name) LIKE '%E%'
ORDER BY first_name; 

-- QUESTION 5

SELECT * FROM Locations
Where UPPER(city) LIKE UPPER('%&city%')
ORDER BY UPPER(city);

-- QUESTION 6

SELECT 
    TO_CHAR(sysdate + 1, 'Month ddth "of year" yyyy') AS Tomorrow
FROM dual;

--QUESTION 7

SELECT
    e.last_name,
    e.first_name,
    d.department_name,
    e.salary,
    ROUND(e.salary *1.04) AS "Good Salary",
    ROUND((e.salary * 1.04 - e.salary) * 12) AS 
    "Annual Pay Increase"
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = 20 OR
    e.department_id = 50 OR
    e.department_id = 60;

-- QUESTION 8

SELECT 
    last_name,
    hire_date,
    TRUNC(months_between(sysdate, hire_date)/12) AS "Years worked"
FROM employees 
WHERE hire_date < TO_DATE('01-01-2014', 'mm-dd-yyyy')
ORDER BY "Years worked" DESC;

-- QUESTION 9

SELECT 
    city,
    country_id,
    NVL(state_province, 'Unknown Province') AS state_province
FROM locations
Where UPPER(city) LIKE UPPER('S%') and length(city) >= 8
ORDER BY city;

-- QUESTION 10

SELECT 
    last_name,
    hire_date,
    TO_CHAR(next_day(add_months(hire_date, 12),'THURSDAY'), 
    'DAY, MONTH "the" Ddspth "of year" yyyy') AS "REVIEW DAY"
FROM employees
WHERE hire_date > TO_DATE('01-01-2017', 'mm-dd-yyyy')
ORDER BY next_day(add_months(hire_date, 12), 'THURSDAY');







