ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SESSION SET tracefile_identifier = "ACC_VAR2";

DECLARE
   sid$      v$session.sid%TYPE;
   spid$     v$process.spid%TYPE;
   serial$   v$session.serial#%TYPE;
   strt      TIMESTAMP;
   cmpl      TIMESTAMP;

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
   sys.DBMS_SYSTEM.set_ev(sid$, serial$, 10046, 12, '');
   strt := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line(TO_CHAR(strt) || ' Started');

   -- start
   WITH dd AS
           (  SELECT t.acc, MAX(t.dt) AS max_dt
                FROM rf.table1 t
               WHERE t.dt < TO_DATE('01.02.2018', 'dd.mm.yyyy')
            GROUP BY t.acc)
     SELECT dd.acc, d.dt, d.summ
       BULK COLLECT INTO v_table
       FROM dd
            JOIN rf.table1 d
               ON d.acc = dd.acc
              AND d.dt = dd.max_dt
   ORDER BY dd.acc;

   DBMS_OUTPUT.put_line('Overall rows ' || v_table.COUNT);
   -- end
   cmpl := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line(TO_CHAR(cmpl) || ' Completed succesfully');
   DBMS_OUTPUT.put_line('Execution duration = ' || TO_CHAR(cmpl - strt));
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line(TO_CHAR(SYSTIMESTAMP) || ' Error: ' || SQLERRM);
END;

DISCONNECT