SPOOL C:\Users\Shaquille\DB2pt5\p5.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;


----Question 1------
---Run script 7northwoods. Using cursor to display many rows of data, create a procedure to display the all the rows of table term.

-- START "C:\Users\Shaquille\Databse2\7Northwoods.sql"
connect c##des03/tiger;

CREATE OR REPLACE PROCEDURE q1 AS
CURSOR c1 IS
SELECT * FROM term;
v_term term%ROWTYPE;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_term;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Term ID: ' || v_term.term_id);
        DBMS_OUTPUT.PUT_LINE('Term Description: ' || v_term.term_desc);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_term.status);
    END LOOP;
    CLOSE c1;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q1;


----Question 2-----
--Run script 7clearwater. Using cursor to display many rows of data, create a procedure to display the following data from the database: Item description, price, color, and quantity on hand.

-- START "C:\Users\Shaquille\Databse2\7Clearwater.sql"
connect c##des02/tiger;

CREATE OR REPLACE PROCEDURE q2 AS
CURSOR c2 IS
SELECT item_desc, inv_price, color, inv_qoh
FROM inventory, item
WHERE inventory.item_id = item.item_id;
v_idesc item.item_desc%TYPE;
v_price inventory.inv_price%TYPE;
v_color inventory.color%TYPE;
v_inv_qoh inventory.inv_qoh%TYPE;
BEGIN
    OPEN c2;
    LOOP
        FETCH c2 INTO v_idesc, v_price, v_color, v_inv_qoh;
        EXIT WHEN c2%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Item description: ' || v_idesc);
        DBMS_OUTPUT.PUT_LINE('Price: $' || v_price);
        DBMS_OUTPUT.PUT_LINE('Color: ' || v_color);
        DBMS_OUTPUT.PUT_LINE('Quantity on hand: ' || v_inv_qoh);
    END LOOP;
    CLOSE c2;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q2;


---Question 3----
-----Run script 7clearwater. Using cursor to update many rows of data,
-- create a procedure that accepts a number represent the percentage increase in price. 
--The procedure will display the old price, new price and update the database with the new price.  

CREATE OR REPLACE PROCEDURE q3(p_increase IN NUMBER) AS
CURSOR C3 IS 
SELECT item_desc, inv_price
FROM inventory, item
WHERE inventory.item_id = item.item_id
FOR UPDATE OF inventory.inv_price;
v_itdesc item.item_desc%TYPE;
v_iprice inventory.inv_price%TYPE;
v_newprice inventory.inv_price%TYPE;

BEGIN
     OPEN c3;
     FETCH c3 INTO v_itdesc, v_iprice;
     WHILE c3%FOUND LOOP
        v_newprice := v_iprice+ (v_iprice * p_increase/100) ;
        UPDATE inventory
        SET inv_price = v_newprice
        WHERE CURRENT OF c3;
        DBMS_OUTPUT.PUT_LINE('Item : ' || v_itdesc);
        DBMS_OUTPUT.PUT_LINE('Old price : $' || v_iprice);
        DBMS_OUTPUT.PUT_LINE('New price : $' || v_newprice);

        FETCH c3 into v_itdesc, v_iprice;
        END LOOP;
        CLOSE c3;
        COMMIT;
END;
/

exec q3(10);


----qUESTION 4----
--Run script scott_emp_dept. Create a procedure that accepts a number represent 
--the number of employees who earns the highest salary. 
--Display employee name and his/her salary Ex: SQL> exec L5Q4(2)  SQL> top 2 employees are KING 5000 FORD 3000 

-- START "C:\Users\Shaquille\Databse2\scott_emp_dept.sql"
connect c##scott/tiger;

CREATE OR REPLACE PROCEDURE q4(p_num IN NUMBER) AS
CURSOR c4 IS
SELECT ename, sal
FROM EMP
ORDER BY sal DESC;
v_ename VARCHAR2(10);
v_sal NUMBER(7,2);
c_counter INTEGER := 0 ;
BEGIN
    OPEN c4;
     DBMS_OUTPUT.PUT_LINE('top ' || p_num || ' employees are ');
    LOOP
    FETCH c4 INTO v_ename, v_sal;
    EXIT WHEN c_counter = p_num OR c4%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE(v_ename || ' ' || v_sal);
        FETCH c4 INTO v_ename, v_sal;

        c_counter := c_counter + 1;
    END LOOP;
    CLOSE c4;
END;
/

SET SERVEROUTPUT ON;
EXECUTE q4(2);

------Question 5----
--Modify question 4 to display ALL employees who make the top salary entered  

CREATE OR REPLACE PROCEDURE q5(p_num IN NUMBER) AS
CURSOR c5 IS
SELECT ename, sal
FROM EMP
WHERE sal IN (
            SELECT DISTINCT sal
            FROM EMP
            ORDER BY sal DESC
            FETCH FIRST p_num ROWS ONLY
        )
ORDER BY sal DESC;

v_ename VARCHAR2(10);
v_sal NUMBER(7,2);

BEGIN
    OPEN c5;
    DBMS_OUTPUT.PUT_LINE('Employees who make the top ' || p_num || ' Salaries are ');
    FETCH c5 INTO v_ename, v_sal;
    WHILE c5%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE( v_ename || ' ' || v_sal);
        FETCH c5 INTO v_ename, v_sal;

    END LOOP;
    CLOSE c5;
END;
/
 
EXECUTE q5(2);

SPOOL OFF;