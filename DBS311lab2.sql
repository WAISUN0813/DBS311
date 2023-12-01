-- ***************************************
-- DBS311 - Fall 2023
-- Lab 2
-- Multi-Line Functions
-- 
-- <WAI SUN LAM>
-- <146691225>
-- <24/09/2023>
-- ***************************************

-- Q1
SELECT 
    TO_CHAR(AVG(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)) 
        - MIN(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)), 
        '$99,999.99') AS "Real Amount" 
FROM employees

-- Q2
SELECT
    department_id,
    TO_CHAR(MAX(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)),
    '$99,999.99') AS "high",
    TO_CHAR(MIN(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)), 
    '$99,999.99') AS "low",
    TO_CHAR(AVG(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)), 
    '$99,999.99') AS "avg"
FROM employees
GROUP BY department_id
ORDER BY "avg" DESC;

-- Q3
SELECT
    department_id AS Dept#,
    job_id AS "Job",
    COUNT(employee_id) AS "How Many"
FROM employees
GROUP BY 
    department_id, 
    job_id
HAVING COUNT(employee_id) > 1
ORDER BY "How Many" DESC;                              

-- Q4
SELECT
    job_id,
    SUM(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)) AS totalPaid  
FROM employees
WHERE job_id NOT IN ('AD_PRES','AD_VP')
GROUP BY 
    job_id
HAVING SUM(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct,0)) > 11000
ORDER BY totalAmountPaid DESC;
-- Q5
SELECT 
    manager_id,
    COUNT(employee_id) AS supervises
FROM employees
WHERE manager_id NOT IN (100, 101, 102)
GROUP BY manager_id 
HAVING COUNT(employee_id) > 2
ORDER BY supervises DESC;

-- Q6
SELECT 
    department_id,
    MAX(hire_date) AS lastestDate,
    MIN(hire_date) AS earliestDate
FROM employees
WHERE department_id NOT IN (10,20)
GROUP BY department_id
HAVING MAX(hire_date) < '01-JAN-20'
ORDER BY lastestDate DESC;



    