-- Create table
create table table1
(
  id     number not null,
  name   varchar2(100) not null,
  ext_id number not null
)
tablespace USERS
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table table1
  add constraint pk_table1 primary key (ID);
