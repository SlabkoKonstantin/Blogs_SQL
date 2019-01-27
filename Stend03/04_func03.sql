SQL> CREATE OR REPLACE FUNCTION get_val_loop(i_id IN NUMBER)
  2  	RETURN NUMBER AS
  3  BEGIN
  4  	FOR rec IN (SELECT t.val
  5  		      FROM t_table t
  6  		     WHERE t.id = i_id)
  7  	LOOP
  8  	   RETURN rec.val;
  9  	END LOOP;
 10  
 11  	RETURN 0;
 12  END;
 13  /