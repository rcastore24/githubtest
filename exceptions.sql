declare
    v_student_id number := &student_id);

begin 
select
    --s.student_id, c.course_no, s1.section_id, count(*)
    count(*)
into     
from student s
inner join enrollment e on s.student_id = e.student_id
inner join section s1 on s1.section_id = e.section_id
inner join course c on c.course_no = s1.course_no
where s.student_id = v_student
group by s.student_id, c.course_no, s1.section_id
order by 1 desc
exception
    when too

--oracle pl/sql by example book, chapter 9 exercise #1
--display rowcount if rowcount > than limit, else, raise exception
--very easy exercise
set serveroutput on
clear screen;
declare
    v_section_id number := &section_id;
    e_too_many_students exception;
    v_ct    number;
begin
    select count(*) into v_ct from enrollment
    where section_id = v_section_id;
    if v_ct > 10 then --10 is the limit
        raise e_too_many_students;
    else
        dbms_output.put_line('section '||v_section_id||' - '||v_ct);
    end if;
exception
    when e_too_many_students then
        dbms_output.put_line('section id '||v_section_id||' has too many students');
end;     

declare
    e_too_many_students exception;
    v_section_id    number := &section_id;
    v_ct            number;
begin
    select count(*) into v_ct from enrollment where section_id = v_section_id;
    if v_ct > 10 then
        raise e_too_many_students;
    end if;
    dbms_output.put_line('section '||v_section_id||' has '||v_ct||' students');
exception
    when e_too_many_students then
        dbms_output.put_line('section '||v_section_id||' has too many students');
end;        
    
--oracle pl/sql by example book, chapter 10 exercise #2
--below isn't the real exercise solution, but the method is the same in terms of displaying error messages
declare
    v_section_id    number := &section_id;
    v_ct            number;
begin
    v_ct := 1/0;
exception
    when others then    
       dbms_output.put_line('error: '||sqlerrm(sqlcode));
end;

select * from enrollment where student_id in (283,282)