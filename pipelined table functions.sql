 --pipelined functions
 
 
   CREATE OR REPLACE EDITIONABLE TYPE "HR"."ADDRESS_T" AS OBJECT (
   street  VARCHAR2(30),
   city    VARCHAR2(20),
   state   CHAR(2),
   zip     CHAR(5) );
   
   
 SELECT l.*, validate_conversion(postal_code AS NUMBER)
 FROM LOCATIONS l
 where validate_conversion(postal_code AS NUMBER) = 1
 
 SELECT VALIDATE_CONVERSION('123' AS NUMBER) FROM DUAL;
 
 --create nested table type of address based on type address_t
CREATE TYPE RAC_ADDR_TAB AS TABLE OF ADDRESS_T

CREATE OR REPLACE FUNCTION generate_data (p_num_rows IN NUMBER)
RETURN RAC_ADDR_TAB PIPELINED
AS
    cursor c1 is SELECT substr(street_address,1,30) street, city, substr(state_province,1,2) st, substr(postal_code,1,5) zip
                 FROM LOCATIONS l
                 where validate_conversion(postal_code AS NUMBER) = 1  
                 and rownum <= p_num_rows;
    v_row ADDRESS_T;
BEGIN
    FOR i IN c1 LOOP
        v_row := address_t(i.street, i.city, i.st, i.zip);
        PIPE ROW (v_row);
    END LOOP;
    RETURN; -- Returns control, no explicit collection returned
END;
/

--it works!!!!
--the output can be queried like a table
--select nvl(state,'xxx'), count(*)
select *
from table(generate_data(10))
--where city like 'South%'
--where state is  null
group by nvl(state,'xxx')

--oracle base example( it works but remember to regenerate all objects before running function and following query)
--example taken from https://oracle-base.com/articles/misc/pipelined-table-functions
DROP TYPE t_tf_tab;
DROP TYPE t_tf_row;

CREATE TYPE t_tf_row AS OBJECT (
  id           NUMBER,
  description  VARCHAR2(50)
);
/
--created nested table type
CREATE TYPE t_tf_tab IS TABLE OF t_tf_row;
/

-- Build the table function itself.
CREATE OR REPLACE FUNCTION get_tab_tf (p_rows IN NUMBER) RETURN t_tf_tab AS
  l_tab  t_tf_tab := t_tf_tab();
BEGIN
  FOR i IN 1 .. p_rows LOOP
    l_tab.extend;
    l_tab(l_tab.last) := t_tf_row(i, 'Description for ' || i);
  END LOOP;

  RETURN l_tab;
END;
/

--this works
SELECT *
FROM   TABLE(get_tab_tf(10))
ORDER BY id DESC;


--google ai example (this works)
DROP TYPE t_tf_tab;
DROP TYPE t_tf_row;

CREATE or replace TYPE t_tf_row AS OBJECT (id NUMBER, description VARCHAR2(50));
/
CREATE TYPE t_tf_tab AS TABLE OF t_tf_row;
/

CREATE OR REPLACE FUNCTION get_tab_ptf (p_rows IN NUMBER)
  RETURN t_tf_tab PIPELINED AS
BEGIN
  FOR i IN 1 .. p_rows LOOP
    PIPE ROW(t_tf_row(i, 'Description for ' || i));
  END LOOP;
  RETURN;
END;
/

SELECT * FROM TABLE(get_tab_ptf(10)) WHERE rownum <= 5 order by id desc