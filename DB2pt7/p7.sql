SPOOL C:\Users\Shaquille\DB2pt7\p7.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

connect c##des03/tiger;

---Question 1---
---Run script 7northwoods in schemas des03 Using CURSOR FOR LOOP syntax 1 in a procedure to 
--display all the faculty member (f_id, f_last, f_first, f_rank), under each faculty member, 
--display all the student advised by that faculty member (s_id, s_last, s_first, birthdate, s_class). 

connect c##des03/tiger;

CREATE OR REPLACE PROCEDURE q1 AS
CURSOR f_curr IS
SELECT f_id, f_last, f_first, f_rank
FROM faculty;

CURSOR s_cur(p_fid NUMBER) IS 
SELECT s_id, s_last, s_first, s_dob, s_class
FROM student
WHERE f_id = p_fid;

BEGIN
FOR faculty IN f_curr LOOP
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || faculty.f_id);
DBMS_OUTPUT.PUT_LINE('Name: ' || faculty.f_last || ', ' || faculty.f_first);
DBMS_OUTPUT.PUT_LINE('Rank: ' || faculty.f_rank);

FOR student IN s_cur(faculty.f_id) LOOP
DBMS_OUTPUT.PUT_LINE('Student ID: ' || student.s_id);
DBMS_OUTPUT.PUT_LINE('Name: ' || student.s_last || ', ' || student.s_first);
DBMS_OUTPUT.PUT_LINE('Birthdate: ' || student.s_dob);
DBMS_OUTPUT.PUT_LINE('Class: ' || student.s_class);
END LOOP;

DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');

END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q1;



---Question 2---
---Run script 7software in schemas des04 Using %ROWTYPE in a procedure,
-- display all the consultants. 
-- Under each consultant display all his/her skill (skill description) 
--and the status of the skill (certified or not) 

connect c##des04/tiger;

CREATE OR REPLACE PROCEDURE q2 AS
CURSOR c_cur IS
SELECT c_id, c_last, c_first
FROM consultant;
v_consultant_row c_cur%ROWTYPE;

CURSOR s_cur(p_c_id NUMBER) IS
SELECT skill_description, certification
FROM skill,consultant_skill
WHERE skill.skill_id = consultant_skill.skill_id
AND c_id = p_c_id;
v_skill_row s_cur%ROWTYPE;

BEGIN 
OPEN c_cur;
FETCH c_cur INTO v_consultant_row;
WHILE c_cur%FOUND LOOP
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_consultant_row.c_id);
DBMS_OUTPUT.PUT_LINE('Name: ' || v_consultant_row.c_last || ', ' || v_consultant_row.c_first);

OPEN s_cur(v_consultant_row.c_id);
FETCH s_cur INTO v_skill_row;
WHILE s_cur%FOUND LOOP
DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skill_row.skill_description);
DBMS_OUTPUT.PUT_LINE('Certified?: ' || v_skill_row.certification);

FETCH s_cur INTO v_skill_row;

END LOOP;

CLOSE s_cur;

FETCH c_cur INTO v_consultant_row;

END LOOP;

CLOSE c_cur;

END;
/

SET SERVEROUTPUT ON;
EXECUTE q2;





----Question 3----
--Run script 7clearwater in schemas des02 Using CURSOR FOR LOOP syntax 2 
--in a procedure to display all items (item_id, item_desc, cat_id)
-- under each item, display all the inventories belong to it. 

connect c##des02/tiger;
CREATE OR REPLACE PROCEDURE q3 AS
  BEGIN
    FOR items IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Item ID: ' || items.item_id);
    DBMS_OUTPUT.PUT_LINE('Description: ' || items.item_desc);
    DBMS_OUTPUT.PUT_LINE('Category ID: ' || items.cat_id);

    FOR inventorys IN (SELECT inv_id FROM inventory WHERE item_id = items.item_id) LOOP
      DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || inventorys.inv_id);
    END LOOP;
    END LOOP;
  END;
  /

SET SERVEROUTPUT ON;
EXECUTE q3;


---Question 4---
--Modify question 3 to display 
--beside the item description the value of the item (value = inv_price * inv_qoh). 

CREATE OR REPLACE PROCEDURE q4 AS
 v_value NUMBER(7,2);
  BEGIN
    FOR items IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
    v_value := 0;
    
    FOR inventorys IN (SELECT inv_id, inv_price, inv_qoh FROM inventory WHERE item_id = items.item_id) LOOP
        v_value := inventorys.inv_price * inventorys.inv_qoh;


    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Item ID: ' || items.item_id);
    DBMS_OUTPUT.PUT_LINE('Description: ' || items.item_desc);
    DBMS_OUTPUT.PUT_LINE('Value: $' || v_value);
    DBMS_OUTPUT.PUT_LINE('Category ID: ' || items.cat_id);
     DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || inventorys.inv_id);

     DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
      
    END LOOP;
    END LOOP;
  END;
  /

SET SERVEROUTPUT ON;
EXECUTE q4;

SPOOL OFF;