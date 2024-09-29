-- Menu du jour
--  SELECT in PL/SQL
--  Pre-defined EXCEPTION
--  Distribute Project Part 3

--  Syntax:
   --    SELECT column1, column2, ...
    --   INTO   variable1, variable2, ...
   --    FROM   table
   --   [ WHERE condition ]  ;

-- Example_1:  Using schema scott, create a procedure that  accepts
-- the employee number to display his/her name, salary, and job  as
-- follow:

--  Employee number X is Y. He is a Z, earning $D a month.
-- where X is empno, Y is ename, Z is job and D is sal
-- (hint:  use table emp of schema c##scott)
-- to find out the name of all tables belonged to the current connection
SELECT table_name FROM user_tables;
-- to display the structure of a table
DESC emp

     CREATE OR REPLACE  PROCEDURE p_sep12_ex1(p_empno IN NUMBER) AS
        v_ename VARCHAR2(10);
        v_job   VARCHAR2(9);  
        v_sal   NUMBER(7,2);   
     BEGIN
       SELECT ename, job, sal
       INTO   v_ename, v_job, v_sal
       FROM   emp
       WHERE  empno = p_empno;

  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is ' || v_ename ||
     
   '. He is a ' || v_job ||', earning $' || v_sal ||' a month.' );

END;
/
SELECT  empno,ename, job,  sal FROM emp;
exec p_sep12_ex1(7934)

-- Example_2: Modify the procedure of example 1 to handle the predefined exception
-- No_data_found with the message below:

    --  Employee number X not exist my friend Shaquille!

CREATE OR REPLACE  PROCEDURE p_sep12_ex1(p_empno IN NUMBER) AS
        v_ename VARCHAR2(10);
        v_job   VARCHAR2(9);  
        v_sal   NUMBER(7,2);   
     BEGIN
       SELECT ename, job, sal
       INTO   v_ename, v_job, v_sal
       FROM   emp
       WHERE  empno = p_empno;

     DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is ' || v_ename ||   
                    '. He is a ' || v_job ||', earning $' || v_sal ||' a month.' );
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno ||
                          ' NOT exist my friend Shaquille!');
END;
/

-- Example 3: Create a procedure that accepts the employee number and the percentage increase
-- in salary.  The procedure will update the salary of the employee if exist otherwise will
-- insert a default employee with a salary of 2000 named default_e

   CREATE OR REPLACE PROCEDURE p_sep12_ex3(p_empno IN NUMBER, p_percent IN NUMBER) AS
     v_sal NUMBER(7,2);
     v_new_sal NUMBER(7,2);
     v_default_e VARCHAR2(10) := 'default_e';
   BEGIN
     SELECT sal
     INTO v_sal
     FROM  emp
     WHERE empno = p_empno;

     v_new_sal := v_sal + v_sal * p_percent / 100;
     
     DBMS_OUTPUT.PUT_LINE('Old salary of number '|| p_empno || ' is ' || v_sal);
     DBMS_OUTPUT.PUT_LINE('New salary of number '|| p_empno || ' is ' || v_new_sal);

     UPDATE emp 
     SET sal = v_new_sal 
     WHERE empno = p_empno;
     COMMIT;
     DBMS_OUTPUT.PUT_LINE('Salary updated!');
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       INSERT INTO emp(empno,  ename, sal)
       VALUES(p_empno,v_default_e, 2000);
       commit;
     DBMS_OUTPUT.PUT_LINE('New employee inserted!');
END;
/

SELECT empno, ename, sal FROM emp;
EXEC p_sep12_ex3(7934,100)

-------------- Try a select that return MANY rows------------
                   

CREATE OR REPLACE  PROCEDURE p_sep12_ex1(p_empno IN NUMBER) AS
        v_ename VARCHAR2(10);
        v_job   VARCHAR2(9);  
        v_sal   NUMBER(7,2);   
     BEGIN
       SELECT ename, job, sal
       INTO   v_ename, v_job, v_sal
       FROM   emp;
      -- WHERE  empno = p_empno;

  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is ' || v_ename ||
     
   '. He is a ' || v_job ||', earning $' || v_sal ||' a month.' );

END;
/
SELECT  empno,ename, job,  sal FROM emp;
exec p_sep12_ex1(7934)

-- handle pre-defined exception TOO_MANY_ROWS

CREATE OR REPLACE  PROCEDURE p_sep12_ex1(p_empno IN NUMBER) AS
        v_ename VARCHAR2(10);
        v_job   VARCHAR2(9);  
        v_sal   NUMBER(7,2);   
     BEGIN
       SELECT ename, job, sal
       INTO   v_ename, v_job, v_sal
       FROM   emp;
      -- WHERE  empno = p_empno;

  DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno || ' is ' || v_ename ||
     
   '. He is a ' || v_job ||', earning $' || v_sal ||' a month.' );

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee number '|| p_empno ||
                          ' NOT exist my friend Shaquille!');
     WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('The select returns more than one rows my friend Shaquille!');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Some errors occured my friend Shaquille!');

END;
/
SELECT  empno,ename, job,  sal FROM emp;
exec p_sep12_ex1(7934)

------------------------  CURSOR ----------------------

  -- Have 4 steps
-- 1/  DECLARE  (done in the declaration section)
--     Syntax:  CURSOR name_of_cursor IS
--              SELECT statement ;

-- 2/  OPEN (done in executable section)
--     Syntax:   OPEN name_of_cursor ;
--     Result:  The select is EXECUTED, data if found will be send to the memory area named ACTIVE SET
--              Cursor's attribute %ISOPEN is set to TRUE.


-- 3/  FETCH (done in executable section)
--     Syntax:   FETCH name_of_cursor INTO variables ;
--     Result:  a/ successfull fetch
--                 data is send to the variable
--                 Cursor's attribute %FOUND set to TRUE
--                 Cursor's attribute %NOTFOUND set to FALSE
--                 Cursor's attribute %ROWCOUNT increase by 1

--              b/ UN-successfull fetch
--                 NO data is send to the variable
--                 Cursor's attribute %FOUND set to FALSE
--                 Cursor's attribute %NOTFOUND set to TRUE
--                 Cursor's attribute %ROWCOUNT remains the last value

--  4/  CLOSE (done in executable section)
--      Syntax:  CLOSE name_of_cursor ;
--      Result:  Memory occupied by  the ACTIVE SET is returned to the system.
--       Cursor's attribute %ISOPEN is set to FALSE.

------------- The 3 types of LOOP in PL/SQL

-- 1/  BASIC LOOP
--        Syntax:    LOOP
--                   Statement;
--                   EXIT WHEN  condition;
--                   END  LOOP;
--   statement will be loop until the condition is evaluated to TRUE;


   --  Example 1:  Create a procedure named p_sep19_ex1 to isplay the number from 0 to 10 
   --              on the screen using BASIC LOOP


CREATE OR REPLACE PROCEDURE p_sep19_ex1 AS
  v_counter NUMBER := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(v_counter);
    v_counter := v_counter + 1;
  EXIT WHEN v_counter > 10;
  END LOOP;
END;
/
EXEC p_sep19_ex1
    

 -- 2/  WHILE LOOP
--        Syntax:    WHILE condition LOOP
--                   Statement;
--                   END  LOOP;
--   statement will be loop when the condition is evaluated to TRUE;


   --  Example 2:  Create a procedure named p_sep19_ex2 to display the number from 0 to 10 
   --              on the screen using WHILE LOOP                 



CREATE OR REPLACE PROCEDURE p_sep19_ex2 AS
  v_counter NUMBER := 0;
BEGIN
  WHILE v_counter <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_counter);
    v_counter := v_counter + 1;
  END LOOP;
END;
/
EXEC p_sep19_ex2


-- 3/ FOR LOOP
--        Syntax:    FOR index IN [REVERSE] low_end .. high_end LOOP
--                      Statement;
--                   END  LOOP;
--   index need not to be declared and index will be increase automatically
--   statement will be executed from low_end to high_end

 --  Example 3:  Create a procedure named p_sep19_ex3 to display the number from 0 to 10 
   --              on the screen using FOR LOOP                 



CREATE OR REPLACE PROCEDURE p_sep19_ex3 AS
BEGIN
  FOR melinda IN 0 .. 10 LOOP
    DBMS_OUTPUT.PUT_LINE(melinda);
  END LOOP;
END;
/
EXEC p_sep19_ex3



 --  Example 4:  Create a procedure named p_sep19_ex4 to display the number from 10 to 0 
   --              on the screen using FOR LOOP    


CREATE OR REPLACE PROCEDURE p_sep19_ex4 AS
BEGIN
  FOR melinda IN REVERSE 0 .. 10 LOOP
    DBMS_OUTPUT.PUT_LINE(melinda);
  END LOOP;
END;
/
EXEC p_sep19_ex4   

------- Example 5 on CURSOR:
 -- Using cursor to display many rows of data, create a procedure to display all employees (empno, ename, job,sal)
 --  as follow:
  --  Employee X is Y. He is a Z, earning a salary of $D.
  -- where X = empno, Y = ename, Z = job, and D = sal   OF table EMP of C##SCOTT

CREATE OR REPLACE PROCEDURE p_sep18_ex5 AS
  -- step 1 declare
   CURSOR emp_curr IS
     SELECT empno, ename, job, sal 
     FROM   emp;
   v_empno NUMBER;
   v_ename VARCHAR2(10);
   v_job   VARCHAR2(9);
   v_sal   NUMBER(7,2);
BEGIN
  -- step 2  open
  OPEN emp_curr;
  -- step 3  fetch
  FETCH emp_curr INTO v_empno, v_ename, v_job, v_sal;
  WHILE emp_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('Row number: ' || emp_curr%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || ' is ' || v_ename || '. He  is a ' ||
                           v_job ||', earning a salary of $' || v_sal || '.');
    FETCH emp_curr INTO v_empno, v_ename, v_job, v_sal;
  END  LOOP;
  -- step 4 CLOSE
  CLOSE emp_curr;
END;
/
EXEC p_sep18_ex5





       
 
