--old school cursor from the nineties
declare
    cursor c1 is select * from employees fetch first 5 rows only;
    emp_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into emp_rec;
        exit when c1%notfound;
        dbms_output.put_line('emp full name: '||emp_rec.first_name||' '||emp_rec.last_name);
    end loop;
    close c1;
end;    

--parameterized cursors
set serveroutput on
DECLARE
    CURSOR emp_cursor (p_deptno IN NUMBER) IS
        SELECT deptno, ename, sal FROM emp WHERE deptno = p_deptno;
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
    v_deptno emp.deptno%type;
BEGIN
    -- Open cursor for department 10
    OPEN emp_cursor(10);
    LOOP
        FETCH emp_cursor INTO v_deptno, v_ename, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('deptno: '||v_deptno||' Employee: ' || v_ename || ', Salary: ' || v_sal);
    END LOOP;
    CLOSE emp_cursor;

    -- Open cursor for department 20
    OPEN emp_cursor(20);
    LOOP
        FETCH emp_cursor INTO v_deptno, v_ename, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('deptno: '||v_deptno||' Employee: ' || v_ename || ', Salary: ' || v_sal);
    END LOOP;
    CLOSE emp_cursor;
END;
/

set serveroutput on
begin
    for x in 1..10 loop
        dbms_output.put_line('rac');
    end loop;
end;    

--nested implicit cursor loops
--could have used explicit cursor if you wanted to 
begin
    for x in (select * from student.course c where c.course_no in (10,20,420,430,450)) loop
       dbms_output.put_line('course#: '||x.course_no||' '||x.description);
       for y in (select s.first_name||' '||s.last_name full_name, s.student_id, e.section_id, sec.course_no
                 from student.student s
                 inner join student.enrollment e on s.student_id = e.student_id
                 inner join student.section sec on e.section_id = sec.section_id
                 where sec.course_no = x.course_no) loop
            dbms_output.put_line('student name: '||y.full_name);
       end loop;                  
    end loop;
end;

declare
    cursor c1 is 
        select * from student.course c where c.course_no in (10,20,420,430,450);
    c1_rec  c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        dbms_output.put_line(c1_rec.course_no||' - '||c1_rec.description);
        
        for x in (
            select s.first_name||' '||s.last_name full_name, s.student_id, e.section_id, sec.course_no
            from student.student s
            inner join student.enrollment e on s.student_id = e.student_id
            inner join student.section sec on e.section_id = sec.section_id
            where sec.course_no = c1_rec.course_no) loop
            
            dbms_output.put_line('   '||x.student_id||' - '||x.full_name);     
        end loop;
    end loop;        
    close c1;
end;        

  SELECT c.course_no, c.description, t.student_id, t.first_name, t.last_name
     FROM student.course     c
     JOIN student.section    s ON c.course_no = s.course_no
     JOIN student.enrollment e ON s.section_id = e.section_id
     JOIN student.student    t ON e.student_id = t.student_id
   ORDER BY c.course_no;

select *
from student.course

set serveroutoutput on
DECLARE
   CURSOR c_course (p_prereq IN student.course.prerequisite%TYPE) 
   IS
   SELECT course_no, description 
     FROM student.course
    WHERE prerequisite = p_prereq;

   v_prereq student.course.prerequisite%TYPE;
BEGIN
   v_prereq := 20;
   DBMS_OUTPUT.PUT_LINE ('v_prereq: '||v_prereq);
   
   -- The value of v_prereq is evaluated once when 
   -- cursor is opened and the cursor result set is based
   -- on the value of v_prereq passed here
   FOR rec IN c_course (v_prereq) 
   LOOP
      DBMS_OUTPUT.PUT_LINE 
         (rec.course_no||', '||rec.description);
      
      -- The new value of v_prereq does not affect the cursor 
      v_prereq := 10; 
   END LOOP;
   
   DBMS_OUTPUT.PUT_LINE ('v_prereq: '||v_prereq);
END;


DECLARE
   CURSOR course_cur
   IS
   SELECT course_no, description
     FROM student.course
     where course_no in (125,135,140,10,20)
     order by course_no;
     
   cursor c1_student (p_course_no in number) is 
        SELECT s.student_id, s.first_name, s.last_name
        FROM student.student    s
        JOIN student.enrollment e ON s.student_id = e.student_id
        JOIN student.section    c ON e.section_id = c.section_id
        WHERE c.course_no = p_course_no;
BEGIN
   FOR course_rec in course_cur LOOP
      DBMS_OUTPUT.PUT_LINE (course_rec.course_no||' - '||course_rec.description);
      FOR student_rec in c1_student(course_rec.course_no) loop
         DBMS_OUTPUT.PUT_LINE ('   '||student_rec.student_id||' - '||
            student_rec.first_name||' '||student_rec.last_name);
      END LOOP;
   END LOOP;  
END;


--chapter 12 problem #2
--uses a cursor expression and places the resultset into a cursor variable
--this is a very interesting exercise combining cursor expressions and cursor variables
--don't overthink this => this still requires 2 looops to account for the parent child relationship (1 loop for parent and 1 loop for the child)
DECLARE
    type t_student is ref cursor;
    cv_student  t_student;
    
   CURSOR course_cur
   IS
   SELECT course_no, description, cursor (
        SELECT s.student_id, s.first_name, s.last_name
        FROM student.student    s
        JOIN student.enrollment e ON s.student_id = e.student_id
        JOIN student.section    c ON e.section_id = c.section_id
        WHERE c.course_no = c1.course_no)   
     FROM student.course c1
     where c1.course_no in (125,135,140,10,20)
     order by c1.course_no;

    v_course_no     course.course_no%type;
    v_desc          course.description%type;
    v_student_id    student.student_id%type;
    v_student_first_name    student.first_name%type;
    v_student_last_name     student.last_name%type;
BEGIN
    open course_cur;
    loop
        fetch course_cur into v_course_no, v_desc, cv_student;
        exit when course_cur%notfound;
        dbms_output.put_line('course: '||v_course_no||' - '||v_desc);  
        loop
            fetch cv_student into v_student_id, v_student_first_name, v_student_last_name;
            exit when cv_student%notfound;
            dbms_output.put_line(v_student_first_name||' '||v_student_last_name);            
        end loop;
    end loop;

    dbms_output.put_line('ct: '||course_cur%rowcount);    
    
    close course_cur;    
end;
        
--oracle by example book, chapter 11 exercise #1
clear screen;
declare
    cursor c1 is select * from course;
    c1_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into c1_rec;
        exit when c1%notfound;
        dbms_output.put_line('course info: '||c1_rec.course_no||' - '||c1_rec.description);
        for i in (  select first_name, last_name 
                    from student.section c
                    inner join student.enrollment e on e.section_id = c.section_id
                    inner join student.student s on s.student_id = e.student_id
                    where c.course_no = c1_rec.course_no) loop
            dbms_output.put_line('student info: '||i.first_name||' '||i.last_name);
                    
        end loop;
    end loop;
end;
        
select c.* , e.student_id
from student.section c
inner join student.enrollment e on e.section_id = c.section_id
where c.course_no = 430

select * from student where student_id in (196,198)

where course_no = 20