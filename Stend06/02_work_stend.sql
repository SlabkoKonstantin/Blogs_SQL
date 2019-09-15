set serveroutput on size 1000000 format wrapped;
set linesize 300;
set pagesize 9999;
set trimspool on;
set termout on;
set serveroutput on;

alter system flush buffer_cache;
alter system flush shared_pool;

-- autotrace
set timing on;
set autotrace traceonly;

SELECT distinct o.owner,
       o.OBJECT_NAME,
       o.OBJECT_TYPE,
       u.CREATED AS user_creation_date
  FROM t_objects o LEFT JOIN t_users u ON o.OWNER = u.USERNAME
  order by o.owner, o.OBJECT_NAME;
  
alter system flush buffer_cache;
alter system flush shared_pool;

SELECT distinct o.owner,
       o.OBJECT_NAME,
       o.OBJECT_TYPE,
       (SELECT distinct u.CREATED
          FROM t_users u
         WHERE o.OWNER = u.USERNAME)
           AS user_creation_date
  FROM t_objects o
  order by o.owner, o.OBJECT_NAME;
  
exit;