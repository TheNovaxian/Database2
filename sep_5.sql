-- Sep 5 gr 7548
-- The IF statement
-- Use function in a procedure
-- Function that return BOOLEAN
SPOOL C:\BD2\sep_5_spool.txt
SELECT to_char(sysdate, 'DD Month YYYY Day Year HH:MI:SS Am') FROM dual;

CREATE OR REPLACE FUNCTION f_seven_time (p_num_in IN NUMBER) RETURN NUMBER AS
     v_num NUMBER ;
     v_result NUMBER;
  BEGIN
     v_num := p_num_in;
     v_result := v_num * 7;
   RETURN v_result;
  END;
  /
-- 2nd
CREATE OR REPLACE FUNCTION f_seven_time_B (p_num_in IN NUMBER) RETURN NUMBER AS
     v_num NUMBER := p_num_in;
     v_result NUMBER;
  BEGIN
     v_result := v_num * 7;
   RETURN v_result;
  END;
  /
select f_seven_time_B(2) from dual;
-- 3rd
CREATE OR REPLACE FUNCTION f_seven_time_C (p_num_in IN NUMBER) RETURN NUMBER AS
     v_result NUMBER;
  BEGIN
     v_result := p_num_in * 7;
   RETURN v_result;
  END;
  /
select f_seven_time_C(2) from dual;

-- 4TH
CREATE OR REPLACE FUNCTION f_seven_time_D (p_num_in IN NUMBER) RETURN NUMBER AS
  BEGIN
   RETURN p_num_in * 7;
  END;
  /
select f_seven_time_D(2) from dual;

Example 1: Create a procedure named p_sep5_ex1 that accepts a number and use the
function f_seven_time to display the following:

    Seven time of X is Y!
where X is the input and Y is the value returned from the function.

   CREATE OR REPLACE PROCEDURE p_sep5_ex1 (p_num_in IN NUMBER) AS
       v_result NUMBER;
    BEGIN
      v_result := f_seven_time (p_num_in);
      DBMS_OUTPUT.PUT_LINE('Seven time of ' || p_num_in || ' is ' ||v_result || '!');
    END;
    /

-- The IF statement
--  Syntax:      IF condition1 THEN
          --         executable_statement1  ;
        --       END IF;
-- executable_statement1 will be executed when the condition1 is evaluated to TRUE

                 IF condition1 THEN
          --         executable_statement1  ;
            --   ELSE
                     executable_statement2  ;
        --       END IF;
-- executable_statement1 will be executed when the condition1 is evaluated to TRUE, otherwise
-- the executable_statement2 will be executed.

-- We can have an IF inside anotther IF  (nested IF)


              -- IF condition1 THEN
          --         executable_statement1  ;
            --   ELSE
                 --    IF condition2 THEN
                       executable_statement2  ;
                 --    END IF;

                 --    IF condition2 THEN
                       executable_statement2  ;
                 --    END IF;
        --       END IF;

-- We can remove the END IF by joinning the ELSE and IF  as follow

      -- IF condition1 THEN
          --         executable_statement1  ;
            --   ELSIF condition2 THEN
                       executable_statement2  ;
            --   ELSIF condition3 THEN
                       executable_statement2  ;
            --   ELSIF condition4 THEN
                       executable_statement2  ;
      -- END IF;

Example2:  Create a procedure named p_mark_to_grade that accepts a numerical mark to convert
   the input mark into letter grade using the scale below:

    >= 90     A
    >= 80     B
    >= 70     C
    >= 60     D
    <  60     See you again my friend!

  and diplay the following:
     For a mark of X, you will have a Y!
where X is the numerical mark, Y is the letter grade.


CREATE OR REPLACE PROCEDURE p_mark_to_grade (p_mark IN NUMBER) AS v_grade VARCHAR(40);
BEGIN
IF p_mark > 100 OR p_mark < 0 THEN
  DBMS_OUTPUT.PUT_LINE('Please insert number from 0 to 100!');
ELSE
   IF p_mark >=90 THEN
     v_grade := 'an A';
   ELSIF p_mark >= 80 then
     v_grade := 'a B';
   ELSIF p_mark >= 70 then
     v_grade := 'a C';
   ELSIF p_mark >= 60 then
     v_grade := 'a D';
   ELSE
     v_grade := 'to repeat the course!';
   END  IF;
   DBMS_OUTPUT.PUT_LINE('For a Mark of ' || p_mark || ', you will have ' || v_grade || '!');
END IF;
END ;
/
     
EXEC p_mark_to_grade (86)

-- Function that return a BOOLEAN datatype
Example3:  Create a function that accept a number to return TRUE if the number
inserted is greater than 10 otherwise return FALSE. create a procedure that
accepts a  number to display the following:

   The number X inserted is less than 10 
OR The number X inserted is greater or equal 10 
using the function just created.

CREATE OR REPLACE FUNCTION f_compair (p_num IN NUMBER) RETURN BOOLEAN AS
  v_result BOOLEAN := FALSE;
BEGIN
  IF p_num >= 10 THEN 
    v_result := TRUE;
  END IF;
RETURN v_result;
END;
/

CREATE OR REPLACE PROCEDURE p_sep5_3 (P1 IN NUMBER) AS
  BEGIN
    IF f_compair(P1) THEN 
      DBMS_OUTPUT.PUT_LINE('The number ' || p1 || ' is greater or equal 10!');
    ELSE
      DBMS_OUTPUT.PUT_LINE('The number ' || p1 || ' is less than 10!');
    END IF;
  END;
/
exec p_sep5_3(5)

SPOOL OFF;
  




