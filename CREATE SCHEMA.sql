--I logged into sys to run the below set of commands
CREATE USER jsmith
  IDENTIFIED BY jsmithjr;
  
GRANT create session TO jsmith;
GRANT create table TO jsmith;
GRANT create view TO jsmith;
GRANT create any trigger TO jsmith;
GRANT create any procedure TO jsmith;
GRANT create sequence TO jsmith;
GRANT create synonym TO jsmith;
  

--i logged into jsmith to run the below stmt (successfully)=>2 tables were created
CREATE SCHEMA AUTHORIZATION jsmith
     CREATE TABLE products
        ( product_id number(10) not null,
          product_name varchar2(50) not null,
          category varchar2(50),
          CONSTRAINT products_pk PRIMARY KEY (product_id)
         )
     CREATE TABLE suppliers
        ( supplier_id number(10) not null,
          supplier_name varchar2(50) not null,
          city varchar2(25),
          CONSTRAINT suppliers_pk PRIMARY KEY (supplier_id)
         );