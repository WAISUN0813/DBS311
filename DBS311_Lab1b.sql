-- ***************************************
-- DBS311 - Fall 2023
-- Lab 1b
-- Review of JOIN statements
-- 
-- <WAI SUN LAM>
-- <146691225>
-- <18/09/2023>
-- ***************************************

/* 
NOTES
-- Make sure you follow the course style guide for SQL as posted on blackboard.
-- Data should always be sorted in a logical way, for the question, even if the 
   question does not specify to sort it.
*/

-- Q1
/* 
Provide a list of ALL departments, what city they are located in, and the name
of the current manager, if there is one.  
*/
SELECT 
    d.department_id,
    department_name,
    city,
    last_name ||' '|| first_name AS managerName
FROM departments d
LEFT JOIN locations l ON d.location_id = l.location_id
LEFT JOIN employees e ON d.manager_id = e.employee_id
ORDER BY department_id;

-- Q2
/*
Allow the user to enter the name of a country, or any part of the name, and 
then list all employees, with their job title, currently working in that country.
*/
SELECT 
    country_name,
    employee_id,
    last_name ||' '|| first_name AS empName,
    job_id
FROM countries c 
    LEFT JOIN locations l on c.country_id = l.country_id
    LEFT JOIN departments d on l.location_id = d.location_id
    RIGHT JOIN employees e on d.department_id = e.department_id
WHERE
    UPPER(country_name) LIKE UPPER('%&country%')
ORDER BY
    empName;

-- Q3
/*
Provide a contact list of all employees, and if they have a manager, 
the name of their direct manager.
*/
SELECT 
    e.employee_id,
    e.last_name ||' '|| e.first_name AS empName,
    e.email,
    e.phone_number,
    m.last_name ||' '|| m.first_name AS managerName
FROM employees e
    LEFT JOIN employees m on e.manager_id = m.employee_id
ORDER BY employee_id;

-- Q4
/*
Provide a list of locations in the database, that currently do not have 
any employees working there.
*/
SELECT 
    l.location_id,
    l.city
FROM locations l
    LEFT JOIN departments d ON l.location_id = d.location_id
    LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL
ORDER BY l.location_id;


-- Q5
/*
Provide a list of employees whom are currently still in the same job that they
started in (i.e. they have never changed job titles).
*/
SELECT 
    e.employee_id,
    e.last_name ||' '|| e.first_name AS empName,
    e.job_id
FROM employees e
    LEFT JOIN job_history jh ON e.employee_id = jh.employee_id 
WHERE jh.employee_id IS NULL
ORDER BY e.employee_id

    
