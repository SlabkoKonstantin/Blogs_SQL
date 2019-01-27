SQL> create table t_table(id primary key, val)
  2  as
  3  select level, level+rownum from dual connect by level<=100000;
