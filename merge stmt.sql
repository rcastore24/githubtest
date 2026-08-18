--my own merge is at the end of this script

CREATE TABLE source_tab AS
SELECT object_id, owner, object_name, object_type
FROM   all_objects;

ALTER TABLE source_tab ADD (
  CONSTRAINT source_tab_pk PRIMARY KEY (object_id)
);

CREATE TABLE dest_tab AS
SELECT object_id, owner, object_name, object_type
FROM   all_objects WHERE ROWNUM <= 25000;

ALTER TABLE dest_tab ADD (
  CONSTRAINT dest_tab_pk PRIMARY KEY (object_id)
);

EXEC DBMS_STATS.gather_table_stats(USER, 'source_tab', cascade=> TRUE);
EXEC DBMS_STATS.gather_table_stats(USER, 'dest_tab', cascade=> TRUE);

--The following code compares the performance of four merge operations. 
--The first uses the straight MERGE statement. 
--The second also uses the MERGE statement, but in a row-by-row manner. 
--The third performs an update, and conditionally inserts the row if the update touches zero rows. 
--The fourth inserts the row, then performs an update if the insert fails with a duplicate value on index exception.

SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF source_tab%ROWTYPE;
  
  l_tab   t_tab;
  l_start NUMBER;
BEGIN

  l_start := DBMS_UTILITY.get_time;
  
  --#1
  MERGE INTO dest_tab a
    USING source_tab b
    ON (a.object_id = b.object_id)
    WHEN MATCHED THEN
      UPDATE SET
        owner       = b.owner,
        object_name = b.object_name,
        object_type = b.object_type
    WHEN NOT MATCHED THEN
      INSERT (object_id, owner, object_name, object_type)
      VALUES (b.object_id, b.owner, b.object_name, b.object_type);

  DBMS_OUTPUT.put_line('MERGE        : ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  ROLLBACK;

  l_start := DBMS_UTILITY.get_time;

  SELECT *
  BULK COLLECT INTO l_tab
  FROM source_tab;
    
  FOR i IN l_tab.first .. l_tab.last LOOP
    MERGE INTO dest_tab a
      USING (SELECT l_tab(i).object_id AS object_id,
                    l_tab(i).owner AS owner,
                    l_tab(i).object_name AS object_name,
                    l_tab(i).object_type AS object_type
             FROM dual) b
      ON (a.object_id = b.object_id)
      WHEN MATCHED THEN
        UPDATE SET
          owner       = b.owner,
          object_name = b.object_name,
          object_type = b.object_type
      WHEN NOT MATCHED THEN
        INSERT (object_id, owner, object_name, object_type)
        VALUES (b.object_id, b.owner, b.object_name, b.object_type);
  END LOOP;

  DBMS_OUTPUT.put_line('ROW MERGE    : ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  ROLLBACK;

  l_start := DBMS_UTILITY.get_time;

  SELECT *
  BULK COLLECT INTO l_tab
  FROM source_tab;
    
  FOR i IN l_tab.first .. l_tab.last LOOP
    UPDATE dest_tab SET
      owner       = l_tab(i).owner,
      object_name = l_tab(i).object_name,
      object_type = l_tab(i).object_type
    WHERE object_id = l_tab(i).object_id;
    
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO dest_tab (object_id, owner, object_name, object_type)
      VALUES (l_tab(i).object_id, l_tab(i).owner, l_tab(i).object_name, l_tab(i).object_type);
    END IF;
  END LOOP;

  DBMS_OUTPUT.put_line('UPDATE/INSERT: ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  ROLLBACK;

  l_start := DBMS_UTILITY.get_time;

  SELECT *
  BULK COLLECT INTO l_tab
  FROM source_tab;
    
  FOR i IN l_tab.first .. l_tab.last LOOP
    BEGIN
      INSERT INTO dest_tab (object_id, owner, object_name, object_type)
      VALUES (l_tab(i).object_id, l_tab(i).owner, l_tab(i).object_name, l_tab(i).object_type);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        UPDATE dest_tab SET
          owner       = l_tab(i).owner,
          object_name = l_tab(i).object_name,
          object_type = l_tab(i).object_type
        WHERE object_id = l_tab(i).object_id;
    END;    
  END LOOP;

  DBMS_OUTPUT.put_line('INSERT/UPDATE: ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  ROLLBACK;
END;
/
--RAC 4 rows are the stats gathered by the above script=>shows straight merge is, by far, the fastest merge technique
MERGE        : 21 hsecs
ROW MERGE    : 111 hsecs
UPDATE/INSERT: 93 hsecs
INSERT/UPDATE: 428 hsecs


PL/SQL procedure successfully completed.

--rac ran on 9/4/25 and below is the results
MERGE        : 38 hsecs
ROW MERGE    : 207 hsecs
UPDATE/INSERT: 217 hsecs
INSERT/UPDATE: 771 hsecs


--below 4 statistic rows and the comment are taken from this article = https://oracle-base.com/articles/9i/merge-statement
--The output shows the straight MERGE statement is an order of magnitude faster than its nearest rival. 
--The update/insert performs almost twice the speed of the insert/update and even out performs the row-by-row MERGE.
MERGE	     : 119 hsecs
ROW MERGE    : 1453 hsecs
UPDATE/INSERT: 1280 hsecs
INSERT/UPDATE: 2443 hsecs

PL/SQL procedure successfully completed.



--below is my handwritten merge stmt

create table dest_tab2 as select * from dest_tab;
alter table dest_tab2 add(action varchar2(10));

--25000	10/18/2024 00:14:42
--56492	10/18/2024 00:23:37
--25000	09/05/2025 02:09:39
select count(*), to_char(sysdate, 'mm/dd/yyyy hh24:mi:ss') from dest_tab2;

--Update	25000
--Insert	31492
select action, count(*)
from dest_tab2
group by action

--25000
--25000	09/05/2025 02:10:51 AM
select count(*), to_char(sysdate,'mm/dd/yyyy hh:mi:ss AM') curr_time
from source_tab s, dest_tab b
where s.object_id = b.object_id

--my handwritten merge (works)
merge into dest_tab2 d
    using source_tab s
    on (d.object_id = s.object_id)
    when matched then
        update set
            action = 'Update'
    when not matched then
        insert (object_id, owner, object_name, object_type, action)
        values(s.object_id, s.owner, s.object_name, s.object_type,'Insert');

--snap review of regexp_like (success)
select *
from jobs
where regexp_like (job_title,'clerk','i');

--snap regexp_like query => don't forget ' ' around your []
select *
from jobs
where regexp_like (job_title,'[mc]')

--my merge effort on 9/4/25 (it works)
merge into dest_tab2 d2
using source_tab s
on (d2.object_id = s.object_id)
when matched then 
    update set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, object_type, action)
    values (s.object_id, s.owner, s.object_name, s.object_type, 'Inserted');
    
--my merge from top of head (it works), remember you don't need table names in update/insert sections
merge into dest_tab2 dt2
using source_tab s
on (s.object_id = dt2.object_id)
when matched then
    update set action = 'Updated'
when not matched then 
    insert values(s.object_id, s.owner, s.object_name, s.object_type, null, 'Inserted');
    
merge into dest_tab2 d2
using source_tab s
on (d2.object_id = s.object_id)
when matched then
    update set d2.action = 'Updated'
when not matched then    
    insert values (s.object_id, s.owner, s.object_name, s.object_type, null, 'Inserted');
    
select action, count(*) 
from dest_tab2    
group by action



merge into dest_tab2 d2
using source_tab s
on (s.object_id = d2.object_id)
when matched then
    update set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, object_type, action)
    values (s.object_id, s.owner, s.object_name, s.object_type, 'Inserted');
    
select action, count(*)
from dest_tab2
group by action;

merge into dest_tab2 d2
using source_tab s
on (s.object_id = d2.object_id)
when matched then
    update set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, object_type, action)
    values (s.object_id, s.owner, s.object_name, s.object_type, 'Inserted');

--refresh my memory on 11/11/25
merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id
when matched then
    update set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, object_type, obj_name1, action)
    values(s.object_id, s.owner, s.object_name, s.object_type, null,'insert');

select action, count(*)
from dest_tab2
group by action

--from memeory
merge into dest_tab2 d2
using source_tab s
on (s.object_id = d2.object_id)
when matched then 
    update set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name, 'inserted');
    
    
merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id)
when matched then 
    update set action ='updated'
when not matched then
    insert  (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name, 'inserted');
    
    
   
select action, count(*)
from dest_tab2
group by action

merge into dest_tab2 d
using source_tab s
on (d.object_id = s.object_id)
when matched then
    update set action = 'updated'
when not matched then
    insert   (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name, 'inserted');

--did this from memory=>got a lot wrong
--remember use the set keyword in the update stmt
--remember to list out the columns to populate in the when not matched section
--remember the keyward is matched after when stmt (not found)
--remember to use parentheses around the join condition
merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id)
when matched then
    update set action = 'Updated'
when not matched then
    insert  (object_id, owner, object_name, object_type, action)
    values (s.object_id, s.owner, s.object_name, s.object_type,'Inserted');
    
--don't forget to put parenthese around your join clause
--don't forget the update clause doesn't require a table name (i.e. correct is update set col1 = whatever, wrong is update table_name set col1 = whatever)
--don't forget the insert clause doesn't require a table name
merge into dest_tab2 d
using source_tab s
on (d.object_id = s.object_id)
when matched then
    update 
        set action = 'Updated'
when not matched then
    insert (object_id, owner, object_name, object_type, action)
    values (s.object_id, s.owner, s.object_name, s.object_type,'Inserted');
    
--don't forget to enclose your join in parentheses    
merge into dest_tab2 d2
using source_tab s
on (s.object_id = d2.object_id)
when matched then
    update 
        set d2.action = 'Updated'
when not matched then 
    insert (object_id, owner,object_name, action)
        values (s.object_id, s.owner, s.object_name,'Inserted');
        
merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id)
when matched then
    update
        set action = 'updated'
when not matched then
    insert (object_id, owner, object_name, action)
    values(s.object_id, s.owner, s.object_name,'inserted');

merge into dest_tab2 d
using source_tab s
on (d.object_id = s.object_id)
when matched then
    update set obj_name1 = s.object_name,
                action = 'updated'
when not matched then
    insert (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name,'inserted');
    
merge into dest_tab2 d2
using source_tab s
on (d2.object_id = s.object_id)
where s.obect_type = 'WINDOW')
when matched then
    update
        set action = 'Updated'
--        where d2.object_id = s.object_id
when not matched then
    insert (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name, 'Inserted');


merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id)
when matched then
    update
        set action = 'updated'
        where s.object_id = d.object_id
when not matched then
    insert (object_id, owner, object_name, action)
    values (s.object_id, s.owner, s.object_name, 'insert');

clear screen;    
merge into dest_tab2 d
using source_tab s
on (s.object_id = d.object_id)
when matched then 
    update
        set action = 'update',
        obj_name1 = s.object_name
when not matched then
    insert (object_id, owner, object_name, action, obj_name1)
    values (s.object_id, s.owner, s.object_name, 'insert', s.object_name);
    
select action, count(*)
from dest_tab2
group by action
