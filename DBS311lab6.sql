-- ***********************
-- Name: WAI SUN LAM
-- ID: 146691225
-- Date: 13/11/2023
-- Purpose: Lab 6 DBS311
-- ***********************
SET SERVEROUTPUT ON;
-- Q1
CREATE OR REPLACE FUNCTION fncCalcFactorial(n IN INTEGER) 
RETURN INTEGER IS
    fact INTEGER := 1;
BEGIN
    IF n = 0 OR n = 1 THEN
        RETURN 1;
    ELSE
        FOR i IN 1..n LOOP
            fact := fact * i;
        END LOOP;
        RETURN fact;
    END IF;
END fncCalcFactorial;

BEGIN
    DBMS_OUTPUT.PUT_LINE('0! = ' || fncCalcFactorial(0)); 
    DBMS_OUTPUT.PUT_LINE('2! = ' || fncCalcFactorial(2)); 
    DBMS_OUTPUT.PUT_LINE('10! = ' || fncCalcFactorial(10)); 
END;

-- Q2
CREATE OR REPLACE PROCEDURE spCalcCurrentSalary (empID employees.employee_id%type)
AS
    firstName employees.first_name%TYPE;
    lastName employees.last_name%TYPE;
    hireDate employees.hire_date%TYPE;
    Salary employees.salary%TYPE;
    currentSalary NUMBER;
    yearsEmployed NUMBER;
    vacationWeeks NUMBER := 2;
BEGIN
    SELECT first_name, last_name, hire_date, salary
    INTO firstName, lastName, hireDate, Salary
    FROM employees
    WHERE employee_id = empID;
  
    yearsEmployed := TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate) / 12);
    currentSalary := Salary;
    FOR i IN 1..yearsEmployed LOOP
        currentSalary := currentSalary * 1.04;
    END LOOP;
    IF yearsEmployed >= 3 THEN
        vacationWeeks := vacationWeeks + LEAST(yearsEmployed - 2, 4); 
    END IF;

        DBMS_OUTPUT.PUT_LINE(RPAD('First Name:', 16, ' ') || firstName);
        DBMS_OUTPUT.PUT_LINE(RPAD('Last Name:', 16, ' ') || lastName);
        DBMS_OUTPUT.PUT_LINE(RPAD('Hire Date:', 16, ' ') || TO_CHAR(hireDate, 'Mon. DD, YYYY'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Salary:', 16, ' ') || TO_CHAR(currentSalary, 'FM$999,999.99')); 
        DBMS_OUTPUT.PUT_LINE('Vacation Weeks: ' || vacationWeeks);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('More then one employee found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred.');
END;

BEGIN
spCalcCurrentSalary(0);
END;
       
-- Q3
CREATE OR REPLACE PROCEDURE spDepartmentsReport AS
CURSOR pc IS
    SELECT 
        d.department_id,
        d.department_name,
        l.city,
        NVL(COUNT(e.employee_id), 0) AS numEmp
    FROM departments d
        LEFT JOIN locations l ON d.location_id = l.location_id
        LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name, l.city
    ORDER BY d.department_id;

BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('DeptID', 11, ' ') ||
        RPAD('Department', 18, ' ') ||
        RPAD('City', 23, ' ') ||
        'NumEmp'
    );
    FOR dept IN pc LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(dept.department_id, 11, ' ') ||
            RPAD(dept.department_name, 18, ' ') ||
            RPAD(dept.city, 23, ' ') ||
            dept.numEmp
        );
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
END;


BEGIN
spDepartmentsReport();
END;

-- Q4
CREATE OR REPLACE FUNCTION spDetermineWinningTeam ( game_ID INT )
RETURN INT IS
  hID INT;
  hscore INT;
  vID INT;
  vscore INT;
  played INT;
BEGIN   
    SELECT
        hometeam,
        homescore,
        visitteam,
        visitscore,
        isplayed
    INTO
        hID,
        hscore,
        vID,
        vscore, 
        played 
    FROM games
    WHERE gameID = game_ID;
    CASE played 
        WHEN 1 THEN
            IF hscore > vscore THEN
                RETURN hID;
            ELSIF vscore > hscore THEN
                RETURN vID;
            ELSE
                RETURN 0;
            END IF;
        WHEN 0 THEN
            RETURN -1;
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NOT FOUND');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
        RETURN NULL;
END;
     
--EXECUTION
BEGIN 
    DBMS_OUTPUT.PUT_LINE(spDetermineWinningTeam(1));
END;
     
-- Q4B
SELECT
    t.teamID,
    CASE 
        WHEN W.numWins > 0 THEN W.numWins
        ELSE NULL 
    END AS numWins
FROM 
    teams t
LEFT JOIN (
    SELECT
        wTeamID,
        COUNT(*) AS numWins
    FROM (
        SELECT
            spDetermineWinningTeam(gameID) AS wTeamID
        FROM 
            Games
        WHERE 
            spDetermineWinningTeam(gameID) > 0
    )
    GROUP BY 
        wTeamID
) W ON T.teamID = W.wTeamID
ORDER BY 
    t.teamID;
