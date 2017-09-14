-- Create table
create table table2
(
  id     number not null,
  val    number not null
)
tablespace USERS
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table table2
  add constraint pk_table2 primary key (ID);
