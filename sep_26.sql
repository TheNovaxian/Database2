

Test your program of q4 part 3.  Make sure your program meet the request of the client!!!!
EXEC p3q4(105,3,'X')  message: Please insert 'Y' or 'N' only!
EXEC p3q4(8888,3,'Y')  message: Consultant number 8888 NOT EXIST!
EXEC p3q4(105,7777,'N')  message: skill number 7777 NOT EXIST!
EXEC p3q4(105,4,'Y')  message: UPDATE NOT NEEDED old and new value are identical!
EXEC p3q4(105,3,'Y')  message: UPDATED succesfully. Consultant Part Janet CERTIFIED for the
                               skill Java Programming!
EXEC p3q4(105,7,'Y')  message: INSERTED succesfully. Consultant Part Janet CERTIFIED for the
                               skill Oracle Database Administration!-

-------------- REVIEW LAST LECTURE
---------------NEW LECTURE ON CURSOR WITH PARAMETER & CURSOR FOR UPDATE

   -- Syntax:  CURSOR name_of_cursor (p_parameter IN datatype) IS
   --          SELECT column
   --          FROM   name_of_table
   --          WHERE  column = p_parameter;

   --          OPEN name_of_cursor (value);

-- Example 1: Create a procedure to display all departments, under each department display all
-- the employees working in it.



    CREATE OR REPLACE PROCEDURE p_sep26_ex1 AS
       -- outer cursor
         CURSOR dept_curr IS
           SELECT deptno, dname, loc
           FROM dept;
         v_deptno dept.deptno%TYPE;
         v_dname dept.dname%TYPE;
         v_loc dept.loc%TYPE;

      --  inner cursor
         CURSOR emp_curr(p_deptno emp.deptno%TYPE) IS
            SELECT empno, ename, sal , deptno
            FROM   emp
            WHERE  deptno = p_deptno;
          v_empno  emp.empno%TYPE;
          v_ename  emp.ename%TYPE;
          v_sal  emp.sal%TYPE;
          v_emp_deptno  emp.deptno%TYPE;
            
   BEGIN
      OPEN dept_curr;
      FETCH dept_curr INTO v_deptno, v_dname, v_loc;
      WHILE dept_curr%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');  
        DBMS_OUTPUT.PUT_LINE('Department number ' ||v_deptno || ' is ' || v_dname ||
                              ' located in the city of ' || v_loc ||'.');

------             inner loop
                  OPEN emp_curr(v_deptno);
                  FETCH emp_curr INTO v_empno, v_ename, v_sal, v_emp_deptno;
                  WHILE emp_curr%FOUND LOOP
              DBMS_OUTPUT.PUT_LINE('Employee number ' ||v_empno || ' is ' || v_ename ||
                ' earning $ ' || v_sal ||' from department number ' ||v_emp_deptno ||'.');
                       FETCH emp_curr INTO v_empno, v_ename, v_sal, v_emp_deptno;
                END LOOP;
            CLOSE emp_curr;

        FETCH dept_curr INTO v_deptno, v_dname, v_loc;
      END LOOP;
      CLOSE dept_curr;
   END;
/
exec p_sep26_ex1

--------------- CURSOR FOR UPDATE
    -- Syntax:   CURSOR name_of_cursor IS
    --           SELECT  column
    --           FROM    name_of_table
    --           FOR UPDATE OF name_of_column ;

    --           ... WHERE CURRENT OF name_of_cursor;

-- Example 2: Create a procedure that accept a number represent the percentage increase in
-- salary.  The procedure will lock the salary of each employee and update the employee with
--  the new salary calculated using the percentage inserted.  Display the message below:

--   The salary of X is changed from Y to Z.
-- where X is ename, Y is old salary and Z is the new salary.


     CREATE OR REPLACE PROCEDURE p_sep26_ex2 (p_percent IN NUMBER) AS
        CURSOR emp_curr IS
          SELECT ename, sal
          FROM   emp
          FOR UPDATE OF sal;
        v_ename emp.ename%TYPE;
        v_sal emp.sal%TYPE;
        v_new_sal emp.sal%TYPE;
     BEGIN
       OPEN emp_curr;
       FETCH emp_curr INTO v_ename, v_sal;
       WHILE emp_curr%FOUND LOOP
         v_new_sal := v_sal + v_sal * p_percent / 100;
         UPDATE emp SET sal = v_new_sal 
         WHERE CURRENT OF emp_curr;
          DBMS_OUTPUT.PUT_LINE('The salary of ' || v_ename ||' is changed from $' ||
                       v_sal || ' to $' || v_new_sal ||'.'); 
         FETCH emp_curr INTO v_ename, v_sal;
        END LOOP;
       CLOSE emp_curr;
      COMMIT;
    END;
   /
       

EXEC p_sep26_ex2 (100)




---------------Distribute New Project


---------------Continue with Projects