select *
from dba_DIRECTORIES

--external tables
--run the create directory and grant to hr as sys logged into ORCLPDB1 (not CDB)

drop directory ext_tab_dir;
create directory ext_tab_dir as '/opt/oracle/upload';

grant read, write on directory ext_tab_dir to hr;

--move the text file to linux file system inside the docker container
--i ran the below command from dos prompt to copy my text file into docker container
    --docker cp movies_to_buy.txt bb5e3a21b8b3dcb2df7926963f06dbba70c7b6c3e97b106b6ce93304868781ec:/opt/oracle/upload
--note: I created the linux directory upload within the existing /opt/oracle directory 
    --I also changed the permissions on upload directory using =>chgmod 777 upload (not sure I need to do this but it did work)
    
--last thing i did was to create the table based on the file (it worked)
    --I can see my movie titles within sqlplus
    --note: i used a google search to provide my parameter values below and I didn't really research how it should be done
drop table movies_to_buy;
create table movies_to_buy (
column1 varchar2(100)
)
organization external (
    type ORACLE_LOADER
    default directory ext_tab_dir
    access parameters (
        records delimited by newline
        )
    location ('movies_to_buy.txt')
    );
    
show user    
connect hr/hrpass1@//my.domain.com:1521/ORCLPDB1

select *
from movies_to_buy
