connect sys/sys as sysdba
SPOOL C:\Users\Shaquille\DB2Projectp1\PP1.txt
SELECT to_char(sysdate, 'DD Day Month HH:MI:SS Am') FROM dual;

--- Question 1-----

CREATE OR REPLACE PROCEDURE triple_of(ans IN NUMBER) AS
  ans1 NUMBER;
BEGIN
  ans1 := ans * 3;
  dbms_output.put_line('The triple of ' || ans || ' is ' || ans1);
END;
/

SET SERVEROUTPUT ON

EXECUTE triple_of(5);



---Question 2----

CREATE OR REPLACE PROCEDURE temp(celc IN NUMBER) AS
  fah NUMBER;
BEGIN
  fah := (9 / 5) * celc + 32;
  dbms_output.put_line( celc ||' degree in C is equivalent to ' || fah || ' in F');

END;
/

EXECUTE temp(32);
EXECUTE temp(0);
EXECUTE temp(15);

---Question 3----

CREATE OR REPLACE PROCEDURE temp_r(fah IN NUMBER) AS
celc NUMBER;
BEGIN
  celc := (5 / 9) * (fah - 32);
  dbms_output.put_line( fah ||' degree in F is equivalent to ' || celc || ' in C');
END;
/

EXECUTE temp_r(32);
EXECUTE temp_r(101);
EXECUTE temp_r(51);

----testing based on results for temp_r------
EXECUTE temp(0);
EXECUTE temp(38.33333333333333333333333333333333333334);
EXECUTE temp(10.55555555555555555555555555555555555556);


----Question 4----  

CREATE OR REPLACE PROCEDURE tax(price IN NUMBER) AS
gst NUMBER;
qst NUMBER;
total NUMBER;
gtotal NUMBER;
BEGIN
  gst := price * 0.05;
  qst := price * 0.0998;
  total := gst + qst;
  gtotal := price + total;
  dbms_output.put_line('For the price of $'|| price);
  dbms_output.put_line('You will have to pay $'|| gst || ' GST ');
  dbms_output.put_line('$'|| qst || ' QST for a total of $'|| total);
  dbms_output.put_line('The GRAND TOTAL is $'|| gtotal);

END;
/

EXECUTE tax(100);
----second test ---
EXECUTE tax(300);



---Question 5----
CREATE OR REPLACE PROCEDURE rectangle(w IN NUMBER, h IN NUMBER) AS
  area NUMBER;
  peri NUMBER;
BEGIN
  area := w * h;
  peri := (w + h) * 2;
  dbms_output.put_line('the area of a ' || w ||' by ' || h || ' rectangle is ' || area || '. It''s parameter is '|| peri);
END;
/

EXECUTE rectangle(10, 5);


---Question 6----   

CREATE OR REPLACE FUNCTION temp_f(celc IN NUMBER) 
RETURN NUMBER AS
  fah NUMBER;
BEGIN
  fah := (9 / 5) * celc + 32;
  RETURN fah;

END;
/

SELECT temp_f(32) FROM dual;
SELECT temp_f(24) FROM dual;
SELECT temp_f(16) FROM dual;



---Question 7---
CREATE OR REPLACE FUNCTION temp_c(fah IN NUMBER) 
RETURN NUMBER AS
celc NUMBER;
BEGIN
  celc := (5 / 9) * (fah - 32);
  RETURN celc;
END;
/

SELECT temp_c(32) FROM dual;
SELECT temp_c(98) FROM dual;
SELECT temp_c(69) FROM dual;




SPOOL OFF;