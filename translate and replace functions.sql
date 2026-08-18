--translate and replace

select replace('abcdef', 'abc', '123')
from dual

select TRANSLATE('abcdef', 'abc', '123')
from dual

--notice each character are individual rather than a 3 letter string
select TRANSLATE('abcccc', 'abc', '123')
from dual

--resultt=>123331
select TRANSLATE('abccca', 'abc', '123')
from dual

--notice the result is different than the translate above as replace looks for the entire string to replace
--result->123cca
select replace('abccca', 'abc', '123')
from dual

--notice string f does not have a corrresponding value in the to_string position, therefore it is stripped off the result
select TRANSLATE('abcdef', 'abcf', '123')
from dual