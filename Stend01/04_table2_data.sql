truncate table table2;

insert into table2 (id, val)
select level as id
, rownum + level -1 as ext_id
from   dual
connect by level <= 10;

commit;
