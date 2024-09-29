connect sys/sys as sysdba
SPOOL C:\Users\Shaquille\DB2Projectp2\PP2.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

---Question 1 Create a function that accepts 2 numbers to calculate the product of them. Test your function in SQL*Plus  ----

CREATE OR REPLACE FUNCTION product(f_num IN NUMBER, s_num IN NUMBER) RETURN NUMBER AS
   n_result NUMBER;
BEGIN
    n_result := f_num * s_num;
    RETURN n_result;
END;
/

SET SERVEROUTPUT ON
--testing---
SELECT product(3,5) FROM dual;  

--Question 2 Create a procedure that accepts 2 numbers and use the function 
--created in question 1 to display the following For a rectangle of size .x. by .y. the area is .z. 

CREATE OR REPLACE PROCEDURE area(f_num IN NUMBER, s_num IN NUMBER) AS   
   n_result NUMBER;
BEGIN
   n_result := product(f_num, s_num);
   DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || f_num || ' by ' || s_num || ' the area is ' || n_result || '.');
END;
/   

--testing---
EXECUTE area(3,5);


--Question 3  Modify procedure of question 2 to display “square” when x and y are equal in length. --
CREATE OR REPLACE PROCEDURE area_2(f_num IN NUMBER, s_num IN NUMBER) AS   
   n_result NUMBER;
BEGIN
   IF f_num = s_num THEN
       DBMS_OUTPUT.PUT_LINE('square');
   ELSE
   n_result := product(f_num, s_num);
   DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || f_num || ' by ' || s_num || ' the area is ' || n_result || '.');
   END IF;
END;
/   
--square test--
EXECUTE area_2(4,4);
--testing variation---
EXECUTE area_2(4,5);

--Question 4  Create a procedure that accepts a number represent Canadian dollar and a letter represent the new currency--

CREATE OR REPLACE PROCEDURE currency(c_num IN NUMBER, c_letter IN VARCHAR2) AS
   c_result NUMBER;
BEGIN
   IF c_letter = 'E' or c_letter = 'e' THEN
       c_result := c_num * 1.50;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' Euros.');
    ELSIF c_letter = 'Y' or c_letter = 'y' THEN
       c_result := c_num * 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' Yen.');
    ELSIF c_letter = 'V' or c_letter = 'v' THEN
       c_result := c_num * 10000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' DONG.');
    ELSIF c_letter = 'Z' or c_letter = 'z' THEN 
       c_result := c_num * 1000000;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' ZIP.');
    END IF;
END;
/

--testing---    
EXECUTE currency(2, 'Y');

--Question 5: Create a function called YES_EVEN 
--that accepts a number to determine if the number is EVEN or not. 
--The function will return TRUE if the number inserted is EVEN otherwise the function will return FALSE 

CREATE OR REPLACE FUNCTION yes_even(f_num IN NUMBER) RETURN BOOLEAN AS
   v_result BOOLEAN := FALSE;
BEGIN
    IF f_num MOD 2 = 0 THEN
        v_result := TRUE;
    END IF;
RETURN v_result;
END;
/


--Question 6: Create a procedure that accepts a numbers
-- and uses the function of question 5 to print out either the following:  Number … is EVEN OR Number … is ODD
CREATE OR REPLACE PROCEDURE even_odd(f_num IN NUMBER) AS
BEGIN
    IF yes_even(f_num) THEN
        DBMS_OUTPUT.PUT_LINE('Number ' || f_num || ' is EVEN');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Number ' || f_num || ' is ODD');
    END IF;
END;
/

--testing---
EXEC even_odd(5);

--second testing--
EXECUTE even_odd(6);

--BONUS QUESTION  Modify question 4 to convert the money in any direction.  --

CREATE OR REPLACE PROCEDURE currency_3(c_num IN NUMBER, c_letter IN VARCHAR2, c2_letter IN VARCHAR2) AS
 c_result NUMBER;
BEGIN
IF (c_letter = 'C' or c_letter = 'c') AND ( c2_letter = 'C' or c2_letter = 'c') THEN --- CANADIAN TO canadian---
       c_result := c_num * 1;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' canadian dollars.');
    ELSIF (c_letter = 'C' or c_letter = 'c') AND (c2_letter = 'E' or c2_letter = 'e') THEN ---CANADIAN to euro---
       c_result := c_num * 1.50;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' Euros.');
    ELSIF (c_letter = 'C' or c_letter = 'c') AND ( c2_letter = 'Y' or c2_letter = 'y') THEN --- CANADIAN TO YEN---
       c_result := c_num * 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' Yen.');
    ELSIF (c_letter = 'C' or c_letter = 'c') AND  (c2_letter = 'V' or c2_letter = 'v') THEN ---CANADIAN TO DONG---
       c_result := c_num * 10000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' DONG.');
    ELSIF (c_letter = 'C' or c_letter = 'c') AND (c2_letter = 'Z' or c2_letter = 'z') THEN ---CANADIAN TO ZIP---
       c_result := c_num * 1000000;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Canadian dollars, you will have ' || c_result || ' ZIP.'); 
    ELSIF (c_letter = 'E' or c_letter = 'e') AND ( c2_letter = 'E' or c2_letter = 'e') THEN --- euro TO euro---
       c_result := c_num * 1;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' euros, you will have ' || c_result || ' euros.');
    ELSIF (c_letter = 'E' or c_letter = 'e') AND (c2_letter = 'C' or c2_letter = 'c') THEN ---EURO to canadian dollar----
       c_result := c_num / 1.50;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Euro, you will have ' || c_result || ' Canadian dollars.');
    ELSIF (c_letter = 'E' or c_letter = 'e') AND (c2_letter = 'Y' or c2_letter = 'y') THEN --euro to yen--
       c_result := c_num * 150;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Euro, you will have ' || c_result || ' YEN.');
    ELSIF (c_letter = 'E' or c_letter = 'e') AND (c2_letter = 'V' or c2_letter = 'v') THEN --euro to dong--
       c_result := c_num * 15000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Euro, you will have ' || c_result || ' DONG.');
    ELSIF (c_letter = 'E' or c_letter = 'e') AND   (c2_letter = 'Z' or c2_letter = 'z') THEN --Euro to zip--
       c_result := c_num * 1500000;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Euro, you will have ' || c_result || ' ZIP.');
       ELSIF (c_letter = 'Y' or c_letter = 'y') AND ( c2_letter = 'Y' or c2_letter = 'y') THEN --- YEN TO YEN---
       c_result := c_num * 1;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' YEN, you will have ' || c_result || ' yen.');
          ELSIF (c_letter = 'Y' or c_letter = 'y') AND (c2_letter = 'C' or c2_letter = 'c') THEN ---YEN to canadian dollar----
       c_result := c_num / 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Yen, you will have ' || c_result || ' Canadian dollars.');
    ELSIF (c_letter = 'Y' or c_letter = 'y') AND (c2_letter = 'E' or c_letter = 'e') THEN --yen to euro--
       c_result := c_num / 150;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Yen, you will have ' || c_result || ' Euro.');
    ELSIF (c_letter = 'Y' or c_letter = 'y') AND (c2_letter = 'V' or c2_letter = 'v') THEN --yen to dong--
       c_result := c_num * 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Yen, you will have ' || c_result || ' DONG.');
    ELSIF (c_letter = 'Y' or c_letter = 'y') AND   (c2_letter = 'Z' or c2_letter = 'z') THEN --yen to zip--
       c_result := c_num * 10000;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Yen, you will have ' || c_result || ' ZIP.');
        ELSIF (c_letter = 'Y' or c_letter = 'y') AND ( c2_letter = 'Y' or c2_letter = 'y') THEN --- DONG TO DONG---
       c_result := c_num * 1;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Dong, you will have ' || c_result || ' dong.');
          ELSIF (c_letter = 'V' or c_letter = 'v') AND (c2_letter = 'C' or c2_letter = 'c') THEN ---DONG to canadian dollar----
       c_result := c_num / 10000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Dong, you will have ' || c_result || ' Canadian dollars.');
    ELSIF (c_letter = 'V' or c_letter = 'v') AND (c2_letter = 'E' or c_letter = 'e') THEN --DONG to euro--
       c_result := c_num / 15000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Dong, you will have ' || c_result || ' Euro.');
    ELSIF (c_letter = 'V' or c_letter = 'v') AND (c2_letter = 'Y' or c2_letter = 'y') THEN --DONG to YEN--
       c_result := c_num / 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Dong, you will have ' || c_result || ' Yen.');
    ELSIF (c_letter = 'V' or c_letter = 'v') AND   (c2_letter = 'Z' or c2_letter = 'z') THEN --DONG to zip--
       c_result := c_num * 100;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' Dong, you will have ' || c_result || ' ZIP.');
     ELSIF (c_letter = 'Z' or c_letter = 'z') AND ( c2_letter = 'Z' or c2_letter = 'z') THEN --- zip TO zip---
       c_result := c_num * 1;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' ZIP, you will have ' || c_result || ' ZIP.');
          ELSIF (c_letter = 'Z' or c_letter = 'z') AND (c2_letter = 'C' or c2_letter = 'c') THEN ---zip to canadian dollar----
       c_result := c_num / 1000000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' ZIP, you will have ' || c_result || ' Canadian dollars.');
    ELSIF (c_letter = 'Z' or c_letter = 'z') AND (c2_letter = 'E' or c2_letter = 'e') THEN --zip to euro--
       c_result := c_num / 1500000;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' ZIP, you will have ' || c_result || ' Euro.');
    ELSIF (c_letter = 'Z' or c_letter = 'z') AND (c2_letter = 'V' or c2_letter = 'v') THEN --zip to dong--
       c_result := c_num / 100;
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' ZIP, you will have ' || c_result || ' DONG.');
    ELSIF (c_letter = 'Z' or c_letter = 'z') AND   (c2_letter = 'Y' or c2_letter = 'y') THEN --zip to yen--
       c_result := c_num / 10000;  
       DBMS_OUTPUT.PUT_LINE('For '|| c_num || ' ZIP, you will have ' || c_result || ' Yen.');
    END IF;
END;
/

--testing all the variations of currency_3---    
EXECUTE currency_3(1,'Y','Y');
EXECUTE currency_3(1,'Y','C');
EXECUTE currency_3(1,'Y','E');
EXECUTE currency_3(1,'Y','V');
EXECUTE currency_3(1,'Y','Z');
EXECUTE currency_3(1,'C','Y');
EXECUTE currency_3(1,'C','C');
EXECUTE currency_3(1,'C','E');
EXECUTE currency_3(1,'C','V');
EXECUTE currency_3(1,'C','Z');
EXECUTE currency_3(1,'E','Y');
EXECUTE currency_3(1,'E','C');
EXECUTE currency_3(1,'E','E');
EXECUTE currency_3(1,'E','V');
EXECUTE currency_3(1,'E','Z');
EXECUTE currency_3(1,'V','Y');
EXECUTE currency_3(1,'V','C');
EXECUTE currency_3(1,'V','E');
EXECUTE currency_3(1,'V','V');
EXECUTE currency_3(1,'V','Z');
EXECUTE currency_3(1,'Z','Y');
EXECUTE currency_3(1,'Z','C');
EXECUTE currency_3(1,'Z','E');
EXECUTE currency_3(1,'Z','V');
EXECUTE currency_3(1,'Z','Z');







SPOOL OFF;

