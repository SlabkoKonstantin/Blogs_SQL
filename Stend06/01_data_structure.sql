--drop table t_users;

create table t_users as
select a1.*
from all_users a1
     cross join
     all_users a2
     cross join
     all_users a3;
     
-- drop table t_objects

create table t_objects as
select ao.*
from all_objects ao
     cross join
     all_users a2;

-- drop index inx_objects_owner;

create index inx_objects_owner on t_objects(owner);
create index inx_users_name on t_users(username);


exec dbms_stats.gather_table_stats(ownname=>'RF',tabname=>'T_USERS',estimate_percent=>100,cascade=>true);
exec dbms_stats.gather_table_stats(ownname=>'RF',tabname=>'T_OBJECTS',estimate_percent=>100,cascade=>true);