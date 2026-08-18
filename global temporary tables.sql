CREATE GLOBAL TEMPORARY TABLE suppliers
( supplier_id numeric(10) NOT NULL,
  supplier_name varchar2(50) NOT NULL,
  contact_name varchar2(50)
);


insert into suppliers values(1,'RAC','RAC1');

select count(*) from suppliers

--NEED TO RESEARCH THIS TOPIC FURTHER