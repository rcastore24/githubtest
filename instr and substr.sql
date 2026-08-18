--instr returns 0 when string is not found, see below
--notice col instr2 returns the column number of the second A for first row when specifying, start position of 2, see below
--column instr2 below looks for the 2nd occurence of A starting at col1, see below
--when missing the length, substr will return the entire string beginning at the start position, see substr1 below
--when substr has negative start point, it will count backwards from the end of the string and then go forward the specified length, see substr2 below
select j.*, instr(job_id,'A',2) instr1, instr(job_id,'A',1,2) str2, substr(job_id,2) substr1, substr(job_id,-3,3) substr2,
    regexp_substr(job_title,'Account')
from jobs j
order by 1


