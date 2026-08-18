CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(50),
    quantity NUMBER,
    sale_date DATE
);

INSERT INTO sales (sale_id, product_name, quantity, sale_date) VALUES (1, 'Product A', 10, DATE '2024-01-15');
INSERT INTO sales (sale_id, product_name, quantity, sale_date) VALUES (2, 'Product B', 20, DATE '2024-01-16');
INSERT INTO sales (sale_id, product_name, quantity, sale_date) VALUES (3, 'Product A', 15, DATE '2024-01-17');
INSERT INTO sales (sale_id, product_name, quantity, sale_date) VALUES (4, 'Product C', 5, DATE '2024-01-18');

    SELECT 
        product_name,
        SUM(quantity) AS total_quantity
    FROM 
        sales
    GROUP BY 
        product_name
        
SELECT *
FROM (
    SELECT 
        product_name,
        SUM(quantity) AS total_quantity
    FROM 
        sales
    GROUP BY 
        product_name
) --AS sales_summary
WHERE 
    total_quantity > 10       
    
    
    
--recursive query example

CREATE TABLE recur (
  id        NUMBER,
  parent_id NUMBER,
  CONSTRAINT tab1_pk PRIMARY KEY (id)
  --CONSTRAINT tab1_tab1_fk FOREIGN KEY (parent_id) REFERENCES tab1(id) 
);

CREATE INDEX tab1_parent_id_idx ON recur(parent_id);

INSERT INTO recur VALUES (1, NULL);
INSERT INTO recur VALUES (2, 1);
INSERT INTO recur VALUES (3, 2);
INSERT INTO recur VALUES (4, 2);
INSERT INTO recur VALUES (5, 4);
INSERT INTO recur VALUES (6, 4);
INSERT INTO recur VALUES (7, 1);
INSERT INTO recur VALUES (8, 7);
INSERT INTO recur VALUES (9, 1);
INSERT INTO recur VALUES (10, 9);
INSERT INTO recur VALUES (11, 10);
INSERT INTO recur VALUES (12, 9);
COMMIT;


--this is the recursive query
WITH t1(id, parent_id) AS (
  -- Anchor member.
  SELECT id,
         parent_id
  FROM   recur
  WHERE  parent_id IS NULL
  UNION ALL
  -- Recursive member.
  SELECT t2.id,
         t2.parent_id
  FROM   recur t2, t1
  WHERE  t2.parent_id = t1.id
)
SELECT id,
       parent_id
FROM   t1;