

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


---- using schema scott, create a procedure that accepts
---the employee number to display his/her name, salary and job as follows

--employee number x is Y. He is earning D a month.
-- where x is empno, y is ename,z is job and d is sal

---how to know how many tables in schema scott
SELECT table_name FROM user_tables;

-- to display the structure of table emp

DESC emp;

CREATE OR REPLACE PROCEDURE p_sep_12_ex1 (p_empno_in IN NUMBER) AS
 v_ename VARCHAR2(10);
 v_job VARCHAR2(9);
 v_sal NUMBER(7,2);  ---7 is the max lenght and 2 is the decimal places
BEGIN
 SELECT ename, job, sal
 INTO v_ename, v_job, v_sal
 FROM emp
 WHERE empno = p_empno_in;
 DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' is ' || v_ename || '. He is earning ' || v_sal || ' a month. ' );
 DBMS_OUTPUT.PUT_LINE('Where ' || p_empno_in || ' is empno, ' || v_ename || ' is ename, ' || v_job || ' is job and ' || v_sal || ' is sal');
END;
/

exec p_sep_12_ex1(7839);


------modify the procedure to handle the predefined exceptions
----no_data_found with the message below

---Employee number x not exist my friend 
CREATE OR REPLACE PROCEDURE p_sep_12_ex2 (p_empno_in IN NUMBER) AS
 v_ename VARCHAR2(10);
 v_job VARCHAR2(9);
 v_sal NUMBER(7,2);  ---7 is the max lenght and 2 is the decimal places
BEGIN
 SELECT ename, job, sal
 INTO v_ename, v_job, v_sal
 FROM emp
 WHERE empno = p_empno_in;
 DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' is ' || v_ename || '. He is earning ' || v_sal || ' a month. ' );
 DBMS_OUTPUT.PUT_LINE('Where ' || p_empno_in || ' is empno, ' || v_ename || ' is ename, ' || v_job || ' is job and ' || v_sal || ' is sal');
EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' not exist my friend');
END;
/

exec p_sep_12_ex2(10000);


-----Create a procedure that accepts 2 number and the percentage increase
--in salaray, the procedure will update the salary of the employee if 
---they exist or otherwise will insert a default employee with the given salary
----of 2000 named default_emp

CREATE OR REPLACE PROCEDURE p_sep_12_ex3 (p_empno_in IN NUMBER, p_increase_in IN NUMBER) AS
 v_sal NUMBER(7,2);
 v_new_sal NUMBER (7,2);
 v_default_e VARCHAR2(10) := 'default_e';
BEGIN
 SELECT sal
 INTO v_sal
 FROM emp
 WHERE empno = p_empno_in;

 v_new_sal := v_sal + (v_sal * p_increase_in / 100);

 DBMS_OUTPUT.PUT_LINE('OLD SALARY OF NUMBER' || p_empno_in || ' IS ' || v_sal);
 DBMS_OUTPUT.PUT_LINE('NEW SALARY OF NUMBER' || p_empno_in || ' IS ' || v_new_sal);

 UPDATE emp 
 SET sal = v_new_sal
 WHERE empno = p_empno_in;
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('SALARY UPDATED SUCCESSFULLY');
EXCEPTION
  WHEN no_data_found THEN
    INSERT INTO emp(empno, ename, job, sal)
    VALUES (p_empno_in, v_default_e,'djob', 2000);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('New employee created');
END;
/

exec p_sep_12_ex3(7839, 10);

----try a select that return many rows---
CREATE OR REPLACE PROCEDURE p_sep_12_ex1 (p_empno_in IN NUMBER) AS
 v_ename VARCHAR2(10);
 v_job VARCHAR2(9);
 v_sal NUMBER(7,2);  ---7 is the max lenght and 2 is the decimal places
BEGIN
 SELECT ename, job, sal
 INTO v_ename, v_job, v_sal
 FROM emp
 --WHERE empno = p_empno_in;
 DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' is ' || v_ename || '. He is earning ' || v_sal || ' a month. ' );
 DBMS_OUTPUT.PUT_LINE('Where ' || p_empno_in || ' is empno, ' || v_ename || ' is ename, ' || v_job || ' is job and ' || v_sal || ' is sal');
END;
/

exec p_sep_12_ex1(7839);


-----handle pre-defined exceptions too many rows

CREATE OR REPLACE PROCEDURE p_sep_12_ex3 (p_empno_in IN NUMBER) AS
 v_ename VARCHAR2(10);
 v_job VARCHAR2(9);
 v_sal NUMBER(7,2);  ---7 is the max lenght and 2 is the decimal places
BEGIN
 SELECT ename, job, sal
 INTO v_ename, v_job, v_sal
 FROM emp
 --WHERE empno = p_empno_in;
 DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' is ' || v_ename || '. He is earning ' || v_sal || ' a month. ' );
 DBMS_OUTPUT.PUT_LINE('Where ' || p_empno_in || ' is empno, ' || v_ename || ' is ename, ' || v_job || ' is job and ' || v_sal || ' is sal');

EXCEPTION
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno_in || ' not exist my friend');
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Some error occured');

END;
/

exec p_sep_12_ex3(7839);


---------CURSORS------------

---4 steps
--step 1 DECLARE (done in the declaratiion section)
   --syntax : CURSOR cursor_name IS
   --SELECT statement;

--step 2 OPEN(done in the executable section)
  --syntax : OPEN cursor_name;
  --Result: the select is executed, data if found will be sent
  ----to the memory area named ACTIVE SET   
  -----Cursor's attribute %^ISOPEN is set to true

--step 3 FETCH (done in the executable section)
  --syntax : FETCH cursor_name INTO variables;
  --Result: Successful fetch will set the data into variables
          --Cursor's attribute %FOUND is set to true
          --Cursor's attribute %NOTFOUND is set to false
          --Cursor's attribute %ROWCOUNT is incremented BY 1

          --: Unsuccessful fetch will set the data into variables
          --Cursor's attribute %FOUND is set to false
          --Cursor's attribute %NOTFOUND is set to true
          --Cursor's attribute %ROWCOUNT is NOT incremented BY 1


--step 4 CLOSE (done in the executable section)
  --syntax : CLOSE cursor_name;
  --Result: Memory occupied by the ACTIVE SET is released
            --Cursor's attribute %ISOPEN is set to false




----The 3 types of LOOP in PL/SQL

--Basic LOOP
----Syntax: 
-------LOOP
-------  statement;
-------  EXIT WHEN condition;
-------END LOOP;
--Statement will loop until the condition is evaluated to true


---example 1: create a procedure named  p_sep19_ex1 to display
---the numbers from 1 to 10 using a basic loop


CREATE OR REPLACE PROCEDURE p_sep19_ex1 AS
   v_counter NUMBER := 0;
BEGIN
    LOOP
       
       DBMS_OUTPUT.PUT_LINE(v_counter);
       v_counter := v_counter + 1;
       EXIT WHEN v_counter = 11;
    END LOOP;
END;
/

exec p_sep19_ex1;


-- While loop
-----syntax:
------ WHILE condition LOOP
------   statement;
------ END LOOP;
--statement will be executed until condition is true
--condition is evaluated at the end of each iteration
--statement will be executed at the end of each iteration


--- example 2: create a procedure named  p_sep19_ex2 to display
---the numbers from 0 to 10 using a while loop

CREATE OR REPLACE PROCEDURE p_sep19_ex2 AS
   v_counter NUMBER := 0;
BEGIN
    WHILE v_counter <= 10 LOOP
       DBMS_OUTPUT.PUT_LINE(v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/

exec p_sep19_ex2;


--FOR loop
-----syntax:
------ FOR counter IN [REVERSE] start .. end LOOP
------   statement;
------ END LOOP;
--statement will be executed until counter reaches the end
--counter is incremented at the end of each iteration


---example 3: create a procedure named  p_sep19_ex3 to display
---the numbers from 0 to 10 using a for loop

CREATE OR REPLACE PROCEDURE p_sep19_ex3 AS
   v_counter NUMBER := 0;
BEGIN
    FOR v_counter IN 0..10 LOOP
       DBMS_OUTPUT.PUT_LINE(v_counter);
    END LOOP;
END;
/

exec p_sep19_ex3;



--example 4 : create a procedure named  p_sep19_ex4 to display
---the numbers from 10 to 0 using a for loop

CREATE OR REPLACE PROCEDURE p_sep19_ex4 AS
   v_counter NUMBER := 10;
BEGIN
    FOR v_counter IN REVERSE 0..10 LOOP
       DBMS_OUTPUT.PUT_LINE(v_counter);
    END LOOP;
END;
/

exec p_sep19_ex4;


---example of cursor
---using cursor to display many rows of data, create
--a procedure to display all employees (empno, ename, job, sal)
--as follows
---Employee x is y, He is a Z, earning a salary of $D
---wHERE X = EMPNO, Y = ENAME, Z = JOB, D = SAL OF TABLE emp OF C##SCOTT


CREATE OR REPLACE PROCEDURE p_sep19_ex5 AS
   CURSOR c_emp IS
     SELECT empno, ename, job, sal
     FROM EMP;
     v_empno NUMBER;
     v_ename VARCHAR2(10);
      v_job VARCHAR2(9);
       v_sal NUMBER(7,2);
  BEGIN
   OPEN c_emp;
   FETCH c_emp into v_empno,v_ename,v_job,v_sal;
   WHILE c_emp%FOUND LOOP
     DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || ' is' || '. He is a ' ||
                          v_job || ', earning a salary of $'|| v_sal || '.');
     FETCH c_emp into v_empno,v_ename,v_job,v_sal;
     END LOOP;
     CLOSE c_emp;

END;
/          

exec p_sep19_ex5;


--- DISPLAY ROW NUBER
CREATE OR REPLACE PROCEDURE p_sep19_ex6 AS
   CURSOR c_emp IS
     SELECT empno, ename, job, sal
     FROM EMP;
     v_empno NUMBER;
     v_ename VARCHAR2(10);
      v_job VARCHAR2(9);
       v_sal NUMBER(7,2);
  BEGIN
   OPEN c_emp;
   FETCH c_emp into v_empno,v_ename,v_job,v_sal;
   WHILE c_emp%FOUND LOOP
     DBMS_OUTPUT.PUT_LINE('ROW NUMBER: ' || c_emp%ROWCOUNT);
     DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || ' is' || '. He is a ' ||
                          v_job || ', earning a salary of $'|| v_sal || '.');
     FETCH c_emp into v_empno,v_ename,v_job,v_sal;
     END LOOP;
     CLOSE c_emp;

END;
/          

exec p_sep19_ex6;



---- Cursor with parameters

--syntax:
---- CURSOR cursor_name(pp_parameter IN datatype) IS
----   SELECT column_name
----   FROM table_name
----   WHERE column_name = pp_parameter

----   Open cursor_name (value);




---example 1 ---  create a cursor named p_sep19_ex7 to display
---all departments, under each department display
---all employees under each department

CREATE OR REPLACE PROCEDURE p_sep19_ex7 AS
---OUTER CURSOR
   CURSOR DEPT_CURR IS
     SELECT deptno, Dname, LOC
     FROM dept;
     v_deptno dept.deptno%TYPE;
     v_dname dept.dname%TYPE;
     v_loc dept.loc%TYPE;

     ---inner cursor
     CURSOR EMP_CURR(p_deptno dept.deptno%TYPE) IS
       SELECT empno, ename, sal, deptno
       FROM EMP
       WHERE deptno = p_deptno;
       v_empno emp.empno%TYPE;
       v_ename emp.ename%TYPE;
       v_sal emp.sal%TYPE;
       v_dno emp.deptno%TYPE;
BEGIN
   OPEN DEPT_CURR;
   FETCH DEPT_CURR into v_deptno,v_dname,v_loc;
   WHILE DEPT_CURR%FOUND LOOP
     DBMS_OUTPUT.PUT_LINE('Department number ' || v_deptno || ' is ' ||  v_dname || '. It is located in ' ||
                          v_loc || '.');
    ---inner loop
    OPEN EMP_CURR(v_deptno);
    FETCH EMP_CURR into v_empno,v_ename,v_sal,v_dno;
    WHILE EMP_CURR%FOUND LOOP
      DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || ' is. He is  ' ||
                          v_ename || ', earning a salary of $'|| v_sal || ' in department number ' || v_dno || '.');
      FETCH EMP_CURR into v_empno,v_ename,v_sal,v_dno;
      END LOOP;
      CLOSE EMP_CURR;




     FETCH DEPT_CURR into v_deptno,v_dname,v_loc;
     END LOOP;
     CLOSE DEPT_CURR;
END;
/

SET SERVEROUTPUT ON
exec p_sep19_ex7;




------Cursor for update
-----syntax: 
-----CURSOR cursor_name IS
-----  SELECT column_name
-----  FROM table_name
-----  FOR UPDATE OF column_name;

   -----WHERE CURRENT OF cursor_name;

---------example
---create a procedure that accepts a number represeting the percentgae increase in salary
---the procedure will lock the salary for each employee and update the employee withe
---the new salry calculated using the percentage inserted. display the message below

---the salary of x is changed from y to z.
---where x is ename, y is old sal, z is new sal

CREATE OR REPLACE PROCEDURE p_sep19_ex8(P_PERCENTAGE IN NUMBER) AS
   CURSOR c_emp IS
     SELECT ename, sal
     FROM EMP
     FOR UPDATE OF sal;
     v_ename EMP.ename%TYPE;
     v_sal EMP.sal%TYPE;
     v_new_sal EMP.sal%TYPE;

BEGIN
   OPEN c_emp;
   FETCH c_emp into v_ename,v_sal;
   WHILE c_emp%FOUND LOOP
     v_new_sal := v_sal + (v_sal * P_PERCENTAGE / 100);
     UPDATE EMP
     SET sal = sal + (sal * P_PERCENTAGE / 100)
     WHERE CURRENT OF c_emp;
     DBMS_OUTPUT.PUT_LINE('The salary of ' || v_ename || ' is changed from ' || v_sal || ' to ' ||
                          v_new_sal || '.');
     FETCH c_emp into v_ename,v_sal;
     END LOOP;
     CLOSE c_emp;
     COMMIT;
END;
/
SET SERVEROUTPUT ON
exec p_sep19_ex8(10);




SPOOL OFF;