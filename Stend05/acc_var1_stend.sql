alter system flush buffer_cache;
alter system flush shared_pool;
ALTER SESSION SET TRACEFILE_IDENTIFIER = "ACC_VAR1";

DECLARE
   sid$      v$session.sid%TYPE;
   spid$     v$process.spid%TYPE;
   serial$   v$session.serial#%TYPE;
   
   strt      timestamp;
   cmpl      timestamp;

   TYPE t_table IS TABLE OF rf.table1%ROWTYPE
      INDEX BY PLS_INTEGER;

   v_table   t_table;
   
BEGIN
   SELECT p.spid, s.sid, s.serial#
     INTO spid$, sid$, serial$
     FROM v$process p, v$session s
    WHERE p.addr = s.paddr
      AND s.audsid = USERENV('SESSIONID');

   DBMS_OUTPUT.put_line('SPID: ' || spid$);

   sys.DBMS_SYSTEM.set_ev(sid$
                         ,serial$
                         ,10046
                         ,12
                         ,'');

   strt := systimestamp;
   DBMS_OUTPUT.PUT_LINE(to_char(strt) || ' Started');
   
-- start   
     SELECT dd.acc, dd.dt, dd.summ bulk collect into v_table 
       FROM (SELECT t.acc, t.dt, MAX(dt) KEEP (DENSE_RANK LAST ORDER BY dt) OVER (PARTITION BY t.acc) AS max_dt, t.summ
               FROM rf.table1 t
              WHERE t.dt < TO_DATE('01.02.2018', 'dd.mm.yyyy')) dd
      WHERE dd.dt = dd.max_dt
   ORDER BY dd.acc;
   
   dbms_output.put_line('Overall rows ' || v_table.count);

-- end
   cmpl := systimestamp;
   DBMS_OUTPUT.PUT_LINE(to_char(cmpl) || ' Completed succesfully');
   DBMS_OUTPUT.PUT_LINE('Execution duration = ' || to_char(cmpl - strt));
exception
   when others then
      DBMS_OUTPUT.PUT_LINE(to_char(systimestamp) || ' Error: ' || sqlerrm);
END;

DISCONNECT