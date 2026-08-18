--generated always as 

create table rac_sales
sale_id number,
product_name    varchar2(50),
quantity        number
item_price      number(11,2),


CREATE TABLE messages(
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description VARCHAR2(100) NOT NULL
);

--this works fine
INSERT INTO messages(description)
VALUES('Oracle identity column demo with GENERATED ALWAYS');

--this give errror because you cannot enter a value into a generated always column
INSERT INTO messages(id, description)
VALUES(2, 'Oracle identity column example with GENERATED ALWAYS ');

select * from messages;