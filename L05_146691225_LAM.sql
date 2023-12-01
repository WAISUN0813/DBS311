-- ***********************
-- Name: WAI SUN LAM
-- ID: 146691225
-- Date: 31/10/2023
-- Purpose: Lab 5 DBS311
-- ***********************

-- Q1
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE even_Odd(nums IN INTEGER)
AS
BEGIN
    IF MOD(nums,2) = 0 
    THEN
    DBMS_OUTPUT.PUT_LINE('The number is even.');
    ELSE
    DBMS_OUTPUT.PUT_LINE('The number is odd.');
    END IF;
EXCEPTION
WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;

BEGIN 
even_Odd(15);
END;
BEGIN 
even_Odd(20);
END;

-- Q2
CREATE OR REPLACE PROCEDURE find_employee(empID IN NUMBER)
AS
    firstName VARCHAR2(20);
    lastName VARCHAR2(20);
    email VARCHAR2(50);
    phone VARCHAR2(20);
    hireDate DATE;
    jobTitle VARCHAR2(20);
BEGIN
    SELECT first_Name, last_Name, email, phone_number, hire_Date, job_ID
    INTO firstName, lastName, email, phone, hireDate, jobTitle
    FROM employees
    WHERE employee_id = empID;
    
    DBMS_OUTPUT.PUT_LINE('First name: ' || firstName);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || lastName);
    DBMS_OUTPUT.PUT_LINE('Email: ' || email);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || phone);
    DBMS_OUTPUT.PUT_LINE('Hire date: ' || hireDate);
    DBMS_OUTPUT.PUT_LINE('Job title: ' || jobTitle);
EXCEPTION
WHEN NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.PUT_LINE ('The employee with ID '||empId||' does not found.');
WHEN OTHERS 
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;

BEGIN
find_employee(176);
END;
BEGIN
find_employee(500);
END;

-- Q3
CREATE OR REPLACE PROCEDURE update_salary_by_dept(
    departmentID IN employees.department_id%TYPE,
    increase IN NUMBER,
    rowsUpdated OUT NUMBER
)
AS 
  
BEGIN
    UPDATE employees
    SET salary = salary * (1 + increase / 100)
    WHERE department_id = departmentID AND salary > 0; 
    rowsUpdated := SQL%ROWCOUNT;
    IF (rowsUpdated = 0)
        THEN
            dbms_output.put_line('DEPARTMENT ID does NOT EXIST');
    END IF;
EXCEPTION
WHEN OTHERS 
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;

DECLARE
    numRowsUpdated NUMBER;
BEGIN
    update_salary_by_dept(110, 2.5, numRowsUpdated);
    DBMS_OUTPUT.PUT_LINE (numRowsUpdated || ' rows updated.');
END;
DECLARE
    numRowsUpdated NUMBER;
BEGIN
    update_salary_by_dept(0, 2.5, numRowsUpdated);
    DBMS_OUTPUT.PUT_LINE (numRowsUpdated || ' rows updated.');
END;

-- Q4
CREATE OR REPLACE PROCEDURE spUpdateSalary_UnderAvg AS 
avgSalary employees.salary%TYPE;
rowsUpdated NUMBER;
BEGIN
    SELECT AVG(salary) 
    INTO avgSalary 
    FROM employees;
    IF avgSalary <= 9000 
    THEN
        UPDATE employees
        SET salary = salary * 1.02
        WHERE salary < avgSalary;
    ELSE
        UPDATE employees
        SET salary = salary * 1.01
        WHERE salary < avgSalary;
    END IF;
    rowsUpdated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(rowsUpdated || ' rows updated.');
EXCEPTION
    WHEN OTHERS 
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;

BEGIN
spUpdateSalary_UnderAvg();
END;

-- Q5
CREATE OR REPLACE PROCEDURE spSalaryReport
AS
    min_salary NUMBER;
    avg_salary NUMBER;
    max_salary NUMBER;
    
    countMinSalary NUMBER := 0;
    countAvgSalary NUMBER := 0;
    countMaxSalary NUMBER := 0;
BEGIN
    SELECT MIN(salary), AVG(salary), MAX(salary)
    INTO min_salary, avg_salary , max_salary
    FROM employees;

    SELECT COUNT(*)
    INTO countMinSalary
    FROM employees
    WHERE salary < (avg_salary - min_salary)/2;
    
    SELECT COUNT(*)
    INTO countMaxSalary
    FROM employees 
    WHERE salary > (max_salary - avg_salary)/2;

    SELECT COUNT(*)
    INTO countAvgSalary
    FROM employees 
    WHERE salary BETWEEN (avg_salary - min_salary)/2 
    AND (max_salary - avg_salary)/2;
    
    DBMS_OUTPUT.PUT_LINE('Low: '|| countMinSalary);
    DBMS_OUTPUT.PUT_LINE('Fair: '|| countAvgSalary);
    DBMS_OUTPUT.PUT_LINE('High: '|| countMaxSalary);
EXCEPTION
    WHEN OTHERS 
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;

BEGIN
spSalaryReport;
END;