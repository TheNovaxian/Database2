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
                   










