connect sys/sys as sysdba;
SPOOL C:\Users\Shaquille\DB2projectp3\p3.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

connect c##scott/tiger;


---Question 1---
---Create a procedure that accepts an employee number to display 
---the name of the department where he works, his name, his annual salary (do not forget his one time commission) 

CREATE OR REPLACE PROCEDURE q1(p_empno IN NUMBER) AS
v_deptname VARCHAR2(14);
v_ename VARCHAR2(10);
v_sal NUMBER;
v_comm NUMBER;
BEGIN
    SELECT dname, ename, sal, comm
    INTO v_deptname, v_ename, v_sal, v_comm
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND emp.empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('Department name: ' || v_deptname);
    DBMS_OUTPUT.PUT_LINE('Employee name: ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('Annual salary: ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('One time commission: ' || v_comm);
END;
/

SET SERVEROUTPUT ON;
EXECUTE q1(7654);

--question 2
---Create a procedure that accepts 
--an inv_id to display the item description, price, color, inv_qoh, and the value of that inventory. 


connect c##des02/tiger;

CREATE OR REPLACE PROCEDURE q2(p_inv_id IN NUMBER) AS
v_idesc VARCHAR2(20);
v_price NUMBER;
v_color VARCHAR2(20);
v_inv_qoh NUMBER;
v_value NUMBER;
BEGIN
   SELECT item_desc, inv_price, color, inv_qoh
   INTO v_idesc, v_price, v_color, v_inv_qoh
   FROM inventory, item
   WHERE inventory.item_id = item.item_id
   AND inventory.inv_id = p_inv_id;
   v_value := v_inv_qoh * v_price;
   DBMS_OUTPUT.PUT_LINE('Item description: ' || v_idesc);
   DBMS_OUTPUT.PUT_LINE('Price: $' || v_price);
   DBMS_OUTPUT.PUT_LINE('Color: ' || v_color);
   DBMS_OUTPUT.PUT_LINE('Quantity on hand: ' || v_inv_qoh);
   DBMS_OUTPUT.PUT_LINE('Value: $' || v_value);

    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Inventory item number '|| p_inv_id || ' was not found');
END;
/   


--testing---
SET SERVEROUTPUT ON;
EXECUTE q2(1);

--testing exceptipon
EXECUTE q2(9999999);

--Question 3
--Create a function called find_age 
--that accepts a date and return a number.  
--The function will use the sysdate and the date inserted 
--to calculate the age of the person with the birthdate inserted.  

connect c##des03/tiger;

CREATE OR REPLACE FUNCTION find_age(p_date IN DATE) RETURN NUMBER AS
v_age NUMBER;
BEGIN
    v_age := TRUNC((sysdate - p_date) / 365);
    RETURN v_age;
END;
/

--TESTING function---
SET SERVEROUTPUT ON;
SELECT find_age(TO_DATE('03-31-1996', 'MM-DD-YYYY')) FROM dual;

---Create a procedure that accepts a student number
-- to display his name, his birthdate, 
--and his age using the function find_age created above

CREATE OR REPLACE PROCEDURE q3(p_studno IN NUMBER) AS
v_studf VARCHAR2(10);
v_studl VARCHAR2(10);
v_bdate DATE;
v_age NUMBER;
BEGIN
    SELECT s_first, s_last, s_dob
    INTO v_studf, v_studl, v_bdate
    FROM student
    WHERE s_id = p_studno;
    v_age := find_age(v_bdate);
    DBMS_OUTPUT.PUT_LINE('Student name: ' || v_studf || ' ' || v_studl);
    DBMS_OUTPUT.PUT_LINE('Birthdate: ' || v_bdate);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);

    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student number '|| p_studno || ' was not found');
END;
/


EXECUTE q3(1);

---Question 4---
-- START "C:\Users\Shaquille\DB2projectp3\7Software.sql"
connect c##des04/tiger;


----We need to INSERT or UPDATE data of table consultant_skill , 
--create needed functions, procedures … that accepts consultant id, skill id,
-- and certification status for the task. 
--The procedure should be user friendly enough to handle all possible errors such as 
--consultant id, skill id do not exist OR certification status is different than ‘Y’, ‘N’.
--Make sure to display: Consultant last, first name, skill description and the confirmation of the DML performed 
--(hint: Do not forget to add COMMIT inside the procedure) 

CREATE OR REPLACE FUNCTION verify_consultant(p_consultant_id IN NUMBER) RETURN BOOLEAN AS
v_consultant_id NUMBER;
BEGIN
    SELECT c_id
    INTO v_consultant_id
    FROM consultant
    WHERE c_id = p_consultant_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Consultant number '|| p_consultant_id || ' was not found');
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION verify_skill(p_skill_id IN NUMBER) RETURN BOOLEAN AS
v_skill_id NUMBER;
BEGIN
    SELECT skill_id
    INTO v_skill_id
    FROM skill
    WHERE skill_id = p_skill_id;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Skill number '|| p_skill_id || ' was not found');
        RETURN FALSE;
END;
/

CREATE OR REPLACE PROCEDURE q4(
    p_consultant_id IN NUMBER, 
    p_skill_id IN NUMBER, 
    p_certification_status IN VARCHAR2
) AS
    v_fname VARCHAR2(20);
    v_lname VARCHAR2(20);
    v_skill_desc VARCHAR2(200);
BEGIN
   
    IF p_certification_status NOT IN ('Y', 'N') THEN
        DBMS_OUTPUT.PUT_LINE('Error: Certification status must be Y or N.');
        RETURN;
    END IF;

 
    IF NOT verify_consultant(p_consultant_id) THEN
        RETURN;
    END IF;

   
    IF NOT verify_skill(p_skill_id) THEN
        RETURN;
    END IF;

 
    SELECT c.c_first, c.c_last, s.skill_description
    INTO v_fname, v_lname, v_skill_desc
    FROM consultant c
    JOIN skill s ON s.skill_id = p_skill_id
    WHERE c.c_id = p_consultant_id;

  
    BEGIN
        UPDATE consultant_skill
        SET certification = p_certification_status
        WHERE c_id = p_consultant_id
          AND skill_id = p_skill_id;

        IF SQL%ROWCOUNT = 0 THEN
         
            INSERT INTO consultant_skill(c_id, skill_id, certification)
            VALUES(p_consultant_id, p_skill_id, p_certification_status);
            DBMS_OUTPUT.PUT_LINE('Consultant inserted!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Consultant updated!');
        END IF;

        COMMIT; 

       
        DBMS_OUTPUT.PUT_LINE('Consultant Name: ' || v_fname || ' ' || v_lname);
        DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_skill_desc);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: A record with this consultant ID and skill ID already exists.');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Consultant or skill not found in the database.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    END;
END;
/


SET SERVEROUTPUT ON;
--TESTING EXISTING CONSULTANT
EXECUTE q4(100, 1, 'Y');

---TESTING NON EXISTING CONSULTANT
EXECUTE q4(99999, 1, 'Y');

---TESTING EXISTING SKILL
EXECUTE q4(100, 5, 'Y');

---TESTING NON EXISTING SKILL
EXECUTE q4(100, 99999, 'Y');

---TESTING INVALID CERTIFICATION STATUS
EXECUTE q4(100, 1, 'Z');

---TESTING UPDATING CERTIFICATION STATUS
EXECUTE q4(100, 1, 'N');

---TESTING INSERTING CONSULTANT
EXECUTE q4(102, 3, 'Y');

SPOOL OFF;