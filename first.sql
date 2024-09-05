

-- connect sys/sys as sysdba
connect c##scott/tiger
SPOOL C:\Users\Shaquille\Databse2\first.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

--PL/SQL is a block language
--syntax
    ---BEGIN
    ---executable_statement;
    ---END;
    ---/


-------Example 1---------
--create an anonimous block that does nothing

BEGIN
 NULL;
END;
/ 

--a procedure is a block with a name and saved
--in the database

--ExAMPLE 2---
---Create a procedure named p_ex2
--- that does nothing

--syntax
---CREATE OR REPLACE PROCDEURE name_of_procedure 
--[(parameter1, MODE datatype, ..)] AS
---BEGIN
    ---executable_statement;
    ---END;
    ---/

CREATE OR REPLACE PROCEDURE p_ex2 AS
BEGIN 
  NULL;
END;
/

---to execute a procedure----
---EXECUTE name_of_procedure
--OR EXEC name_of_procedure 

EXEC p_ex2

---Example 3 : Modify the procedure of p_ex2 to add a variable named V_num
-- of datatype number and then assign number 42 to it 
---hint : declare the variable in the optional DECLARATION section
--and assign the value in the MANDATORY EXECUTABLE section using
--the assignation operator :=

CREATE OR REPLACE PROCEDURE p_ex2 AS
--declaration section
   V_num NUMBER;
BEGIN 
--executable section
  V_num := 42;
  NULL;
END;
/

----Display the contents of the variable---
---modify procedure p_ex2 by displaying content of the variable
--using PUT LINE command

CREATE OR REPLACE PROCEDURE p_ex2 AS
--declaration section
   V_num NUMBER;
BEGIN 
--executable section
  V_num := 42;
  DBMS_OUTPUT.PUT_LINE(v_num);
  NULL;
END;
/

EXEC p_ex2


--- we have to turn on the package DBMS_OUTPUT for each connect
SET SERVEROUTPUT ON
EXEC p_ex2


---modify procedure p_ex2 by displaying the content of the variable as
----Melinda's Favorite number is x
--where x is the value of v_num
--hint :add the text using the cancatenation operator || betwen the character ')

CREATE OR REPLACE PROCEDURE p_ex2 AS
--declaration section
   V_num NUMBER;
BEGIN 
--executable section
  V_num := 42;
  DBMS_OUTPUT.PUT_LINE('Melinda''s Favorite number is '||v_num);
  NULL;
END;
/

EXEC p_ex2

-----example 6-----
--create a procedure named seven_time that accepts a number
--to calculate 7x the value inserted and display exactly the follwing
--Seven time X is Y!
--Where X is the input value, and y is seven times the value

CREATE OR REPLACE PROCEDURE seven_time(p_num_in IN NUMBER) AS
 v_num NUMBER;
 V_result Number;
BEGIN
 v_num := p_num_in;
 v_result := v_num * 7;
 DBMS_OUTPUT.PUT_LINE('Seven time of ' || v_num || ' is ' || v_result || '!');
END;
/

exec seven_time(7)

-- TO SHOW ERROR - show error 

---example 7 --
--create a fucnton named f_seven_time that accepts a number to
--return 7 times the input value to the calling environment

--syntax

---CREATE OR REPLACE FUNCTION name_of_function(parameter1 MODE datatype, ..)
-- RETURN datatype AS
---BEGIN
--    executable statement
--    RETURN variable
---END;
---/


CREATE OR REPLACE FUNCTION f_seven_time(p_num_in IN NUMBER)
RETURN NUMBER AS
  v_num NUMBER;
  v_result NUMBER;
BEGIN
  v_num := p_num_in;
  v_result := v_num * 7;
  RETURN v_result;
  END;
  /


--test the function--
SELECT f_seven_time(7) FROM dual;

---use the functionof example 7 to find sempno, ename, sal and
-- the seven time of the salary of each employee of department 30
--hint use table emp of c##scott

START "C:\Users\Shaquille\Databse2\scott_emp_dept.sql"
Connect c##scott/tiger

CREATE OR REPLACE FUNCTION f_seven_time(p_num_in IN NUMBER)
RETURN NUMBER AS
  v_num NUMBER;
  v_result NUMBER;
BEGIN
  v_num := p_num_in;
  v_result := v_num * 7;
  RETURN v_result;
  END;
  /

SELECT empno, ename,deptno, sal, f_seven_time(sal) "Dream Salary"
FROM emp
WHERE deptno = 30;

---2nd way of doing the same thing--

CREATE OR REPLACE FUNCTION f_seven_time_b(p_num_in IN NUMBER)
RETURN NUMBER AS
  v_num NUMBER := p_num_in;;
  v_result NUMBER;
BEGIN
  v_result := v_num * 7;
  RETURN v_result;
  END;
  /

SELECT empno, ename,deptno, sal, f_seven_time(sal) "Dream Salary"
FROM emp
WHERE deptno = 30;



-----CREATE a procedure named p_serp5_ex1 that accepts a number and use the
---function f_seven_time to display the follwing
---Seven time X is Y!

CREATE OR REPLACE PROCEDURE p_sep5_ex1 (p_num_in IN NUMBER) AS
    v_result NUMBER;
BEGIN
    v_result := f_seven_time(p_num_in); -- Corrected parameter name
    DBMS_OUTPUT.PUT_LINE('Seven times ' || p_num_in || ' is ' || v_result || '!');
END;
/

SET SERVEROUTPUT ON;
EXEC p_sep5_ex1(7)


---if statement ----
---syntax if IF condition1 THEN
---executable statement
---END IF;

---create procedure named p_mark_t0_grade that accepts a numerical mark
---and converts it into etter grade
--and display For a mark of x, you will have Y!

CREATE OR REPLACE PROCEDURE p_mark_to_grade (p_mark_in IN NUMBER) AS
  c_grade VARCHAR(40);
BEGIN
  IF p_mark_in >= 90 THEN
    c_grade := 'A';
  ELSIF p_mark_in >= 80 THEN
    c_grade := 'B';
  ELSIF p_mark_in >= 70 THEN
    c_grade := 'C';
  ELSIF p_mark_in >= 60 THEN
    c_grade := 'D';
  ELSE
    c_grade := 'See you again my friend!';
  END IF;
  DBMS_OUTPUT.PUT_LINE('For a mark of ' || p_mark_in || ' you will have ' || c_grade || '!');
END;
/

EXEC p_mark_to_grade(50);

SPOOL OFF;