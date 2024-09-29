SPOOL C:\Users\Shaquille\DB2pt6\p6.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;


---Question1---
--Run script 7northwoods in schemas des03 Create a procedure to display all the 
--faculty member (f_id, f_last, f_first, f_rank), under each faculty member, 
--display all the student advised by that faculty member (s_id, s_last, s_first, s_dob, s_class). 

-- START "C:\Users\Shaquille\Databse2\7Northwoods.sql"
connect c##des03/tiger;
CREATE OR REPLACE PROCEDURE q1 AS
CURSOR F_cur IS
SELECT f_id, f_last, f_first, f_rank
FROM faculty;
v_fid faculty.f_id%TYPE;
v_flast faculty.f_last%TYPE;
v_ffirst faculty.f_first%TYPE;
v_frank faculty.f_rank%TYPE;


CURSOR s_cur (p_f_id faculty.f_id%TYPE) IS
SELECT s_id, s_last, s_first, s_dob, s_class
FROM student
WHERE f_id = p_f_id;
v_sid student.s_id%TYPE;
v_slast student.s_last%TYPE;
v_sfirst student.s_first%TYPE;
v_bdate student.s_dob%TYPE;
v_sclass student.s_class%TYPE;

BEGIN
    OPEN F_cur;
    FETCH F_cur INTO v_fid, v_flast, v_ffirst, v_frank;
    WHILE F_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_fid);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_flast || ', ' || v_ffirst);
    DBMS_OUTPUT.PUT_LINE('Rank: ' || v_frank);

    OPEN s_cur(v_fid);
    FETCH s_cur INTO v_sid, v_slast, v_sfirst, v_bdate, v_sclass;
    WHILE s_cur%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_sid);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_slast || ', ' || v_sfirst);
        DBMS_OUTPUT.PUT_LINE('Birthdate: ' || v_bdate);
        DBMS_OUTPUT.PUT_LINE('Class: ' || v_sclass);
        FETCH s_cur INTO v_sid, v_slast, v_sfirst, v_bdate, v_sclass;
    END LOOP;
CLOSE s_cur;

    FETCH F_cur INTO v_fid, v_flast, v_ffirst, v_frank;
   END LOOP;
   CLOSE F_cur;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q1;

---Question 2---
--Run script 7software in schemas des04 Create a procedure to display all the consultants.  
--Under each consultant display all his/her skill (skill description) and the status of the skill (certified or not) 

-- START "C:\Users\Shaquille\Databse2\7Software.sql"
connect c##des04/tiger;

CREATE OR REPLACE PROCEDURE q2 AS
CURSOR c_cur IS
SELECT c_id, c_last, c_first
FROM consultant;
v_cid consultant.c_id%TYPE;
v_clast consultant.c_last%TYPE;
v_cfirst consultant.c_first%TYPE;

CURSOR s_cur (p_c_id consultant.c_id%TYPE) IS
SELECT skill_description, certification
FROM skill, consultant_skill
WHERE skill.skill_id = consultant_skill.skill_id
AND c_id = p_c_id;
v_skill_desc skill.skill_description%TYPE;
v_skill_status consultant_skill.certification%TYPE;

BEGIN
    OPEN c_cur;
    FETCH c_cur INTO v_cid, v_clast, v_cfirst;
    WHILE c_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_cid);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_clast || ', ' || v_cfirst);

    OPEN s_cur(v_cid);
    FETCH s_cur INTO v_skill_desc, v_skill_status;
    WHILE s_cur%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skill_desc);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_skill_status);
        FETCH s_cur INTO v_skill_desc, v_skill_status;
    END LOOP;
CLOSE s_cur;

    FETCH c_cur INTO v_cid, v_clast, v_cfirst;  
   END LOOP;
   CLOSE c_cur;
END;    
/

SET SERVEROUTPUT ON;
EXECUTE q2;

--Question 3--

--Run script 7clearwater in schemas des02 Create a procedure to display all items 
--(item_id, item_desc, cat_id) under each item, display all the inventories belong to it

-- START "C:\Users\Shaquille\Databse2\7Clearwater.sql"
connect c##des02/tiger;

CREATE OR REPLACE PROCEDURE q3 AS
CURSOR c_cur IS
SELECT item_id, item_desc, cat_id
FROM item;
v_item_id item.item_id%TYPE;
v_item_desc item.item_desc%TYPE;
v_cat_id item.cat_id%TYPE;

CURSOR i_cur (p_item_id item.item_id%TYPE) IS
SELECT inv_id
FROM inventory
WHERE item_id = p_item_id;
v_inv_id inventory.inv_id%TYPE;

BEGIN
    OPEN c_cur;
    FETCH c_cur INTO v_item_id, v_item_desc, v_cat_id;
    WHILE c_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id);
    DBMS_OUTPUT.PUT_LINE('Description: ' || v_item_desc);
    DBMS_OUTPUT.PUT_LINE('Category ID: ' || v_cat_id);

    OPEN i_cur(v_item_id);
      DBMS_OUTPUT.PUT_LINE('Inventories belonging to this Item');
    FETCH i_cur INTO v_inv_id;
    WHILE i_cur%FOUND LOOP
      
        DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id);
        -- DBMS_OUTPUT.PUT_LINE('Price: $' || v_inv_price);
        -- DBMS_OUTPUT.PUT_LINE('Quantity on hand: ' || v_inv_qoh);
        FETCH i_cur INTO v_inv_id;
    END LOOP;
CLOSE i_cur;

    FETCH c_cur INTO v_item_id, v_item_desc, v_cat_id;
   END LOOP;
   CLOSE c_cur;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q3;


--Question 4--
--Modify question 3 to display beside the item description the value of the item (value = inv_price * inv_qoh).

CREATE OR REPLACE PROCEDURE q4 AS
CURSOR c_cur IS
SELECT item_id, item_desc, cat_id
FROM item;
v_item_id item.item_id%TYPE;
v_item_desc item.item_desc%TYPE;
v_cat_id item.cat_id%TYPE;

CURSOR i_cur (p_item_id item.item_id%TYPE) IS
SELECT inv_id, inv_price, inv_qoh
FROM inventory
WHERE item_id = p_item_id;
v_inv_id inventory.inv_id%TYPE;
v_inv_price inventory.inv_price%TYPE;
v_inv_qoh inventory.inv_qoh%TYPE;
v_value inventory.inv_price%TYPE;

BEGIN
    OPEN c_cur;
    FETCH c_cur INTO v_item_id, v_item_desc, v_cat_id;
    WHILE c_cur%FOUND LOOP
     v_value := v_inv_price * v_inv_qoh;
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id);
    DBMS_OUTPUT.PUT_LINE('Description: ' || v_item_desc);
    DBMS_OUTPUT.PUT_LINE('Value: $' || v_value);
    DBMS_OUTPUT.PUT_LINE('Category ID: ' || v_cat_id);

    OPEN i_cur(v_item_id);
      DBMS_OUTPUT.PUT_LINE('Inventories belonging to this Item');
    FETCH i_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
    WHILE i_cur%FOUND LOOP
      
        DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id);
        -- DBMS_OUTPUT.PUT_LINE('Price: $' || v_inv_price);
        -- DBMS_OUTPUT.PUT_LINE('Quantity on hand: ' || v_inv_qoh);
        FETCH i_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
    END LOOP;
CLOSE i_cur;

    FETCH c_cur INTO v_item_id, v_item_desc, v_cat_id;
   END LOOP;
   CLOSE c_cur;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q4;



----Question 5---
---Run script 7software in schemas des04 Create a procedure that accepts a consultant id, 
--and a character used to update the status (certified or not) of all the SKILLs belonged to 
--the consultant inserted.  

---Display 4 information about the consultant such as id, name, …Under each consultant display 
--all his/her skill (skill description) and the OLD and NEW status of the skill (certified or not). 

-- START "C:\Users\Shaquille\Databse2\7Software.sql"
connect c##des04/tiger;

CREATE OR REPLACE PROCEDURE q5(p_cons_id IN NUMBER, p_status IN VARCHAR2) AS
CURSOR c_cur IS
SELECT c_last, c_first,c_city,c_email
FROM consultant
WHERE c_id = p_cons_id;
v_c_last VARCHAR2(20);
v_c_first VARCHAR2(20);
v_c_city VARCHAR2(20);
v_c_email VARCHAR2(20);

CURSOR s_cur IS
SELECT skill_description, certification
FROM skill,consultant_skill
WHERE skill.skill_id = consultant_skill.skill_id
AND c_id = p_cons_id
FOR UPDATE OF consultant_skill.certification;
v_skill_desc skill.skill_description%TYPE;
v_skill_status consultant_skill.certification%TYPE;
v_newcert consultant_skill.certification%TYPE;

BEGIN
    OPEN c_cur;
    FETCH c_cur INTO v_c_last, v_c_first,v_c_city,v_c_email;
    WHILE c_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || p_cons_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_c_last || ', ' || v_c_first);
    DBMS_OUTPUT.PUT_LINE('City: ' || v_c_city);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_c_email);

    OPEN s_cur;
    DBMS_OUTPUT.PUT_LINE('Skills------ ');
    FETCH s_cur INTO v_skill_desc, v_skill_status;
    WHILE s_cur%FOUND LOOP
        v_newcert := p_status;
        UPDATE consultant_skill
        SET certification = v_newcert
        WHERE CURRENT OF s_cur;
        DBMS_OUTPUT.PUT_LINE('Skill: ' || v_skill_desc);
        DBMS_OUTPUT.PUT_LINE(' Old Status: ' || v_skill_status);
        DBMS_OUTPUT.PUT_LINE(' New Status: ' || v_newcert);
        FETCH s_cur INTO v_skill_desc, v_skill_status;
    END LOOP;
CLOSE s_cur;

    FETCH c_cur INTO v_c_last, v_c_first,v_c_city,v_c_email;  
   END LOOP;
   CLOSE c_cur;
   COMMIT;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q5(100,'N');

SPOOL OFF;