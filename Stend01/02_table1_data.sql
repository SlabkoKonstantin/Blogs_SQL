--truncate table table1;

declare
  j pls_integer;
begin
  j := 1;
  for i in 1..100000 loop
    insert into table1 (id, name, ext_id) values (i,'item' || i, j);          
    if (j >= 10) then
      j := 1;
    else
      j := j + 1;
    end if;    
  end loop;
  commit;
end;

--SELECT * from table1
