-- создаем таблицу
CREATE TABLE RF.table1
(
  acc   VARCHAR2(50),
  dt    DATE,
  summ  NUMBER
);


-- заполняем ее тестовыми данными
declare
  v_acc table1.acc%type;
  v_dt  table1.dt%type;
  v_summ table1.summ%type;
  v_cnt pls_integer;
begin
  for i in 1..20000 loop
     select trunc(dbms_random.value(100000000000, 999999999999)) num into v_acc from dual;
     select round(dbms_random.value(1,100),0) num into v_cnt from dual;
     for j in 1..v_cnt loop
        SELECT TO_DATE(
              TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J')
                                    ,TO_CHAR(DATE '2019-12-31','J')
                                    )
                    ),'J' 
               ) into v_dt FROM DUAL;
        select round(dbms_random.value(1,100000),2) into v_summ from dual;
        insert into table1 (acc,dt,summ) values (v_acc,v_dt,v_summ);               
     end loop;
  end loop;  
  commit;
  select count(*) into v_cnt from table1;
  dbms_output.put_line('overall rows: ' || v_cnt);
end;

-- создадим индексы
CREATE INDEX RF.ix_table1_acc ON RF.TABLE1(ACC) COMPUTE STATISTICS ONLINE;

CREATE INDEX RF.ix_table1_dt ON RF.TABLE1(DT) COMPUTE STATISTICS ONLINE;

-- соберем статистику
BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'RF'
    ,TabName           => 'TABLE1'
    ,Estimate_Percent  => SYS.DBMS_STATS.AUTO_SAMPLE_SIZE
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE AUTO' 
    ,CASCADE           => TRUE
    ,No_Invalidate  => FALSE);
END;

-- вариант с оконными функциями
select  dd.acc, dd.dt, dd.summ from (
select t.acc, t.dt, max(dt) keep (dense_rank last order by dt) over (partition by t.acc) as max_dt, t.summ from table1 t
where t.dt < to_date('01.02.2016', 'dd.mm.yyyy')
) dd
where dd.dt = dd.MAX_DT
order by dd.acc;

-- вариант через группировку
WITH dd AS
           (  SELECT t.acc, MAX(t.dt) AS max_dt
                FROM table1 t
               WHERE t.dt < TO_DATE('01.02.2018', 'dd.mm.yyyy')
            GROUP BY t.acc)
     SELECT dd.acc, d.dt, d.summ
       FROM dd
            JOIN table1 d
               ON d.acc = dd.acc
              AND d.dt = dd.max_dt
   ORDER BY dd.acc;