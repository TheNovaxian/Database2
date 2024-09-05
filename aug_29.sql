connect c##scott/tiger
SPOOL C:\BD2\aug_29_spool.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

--my first lecture

--PL/SQL is a BLOCK language.

--  Syntax:
--   BEGIN
--     executable_statement ;
--    END;
--    /
--
--  Example 1: Create an anomimous block
-- that does nothing.

   BEGIN
     NULL;
   END;
   /

-- A procedure is a block with a name and
-- saved in the database.

-- Example 2: Create a procedure named p_ex2 
-- that does nothing.

-- Syntax:
--  CREATE OR REPLACE PROCEDURE name_of_procedure 
--                              [(parameter1 MODE datatype, ..)] AS
--    BEGIN
--     executable_statement ;
--    END;
--    /

CREATE OR REPLACE PROCEDURE p_ex2 AS
   BEGIN
     NULL;
   END;
   /

-- to run the procedure do:
--   EXECUTE name_of_procedure
--  OR  EXEC name_of_prodedure

   EXEC p_ex2

--  Example 3:  Modify the procedure of p_ex2 to add a variable named v_num
-- of datatype number and then assign number 42 to it  (hint: declare the
-- variable in the optional DECLARATION section, and assign the value in the
-- MANDATORY EXECUTABLE section using the assignation operator :=)


     CREATE OR REPLACE PROCEDURE p_ex2 AS
        -- declaration section
        v_num NUMBER; 
   BEGIN
      -- executable section
     v_num  := 42;
   END;
   /

  SPOOL OFF;
