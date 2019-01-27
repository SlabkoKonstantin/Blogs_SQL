SQL> CREATE OR REPLACE FUNCTION get_val_max(i_id IN NUMBER)
  2   	RETURN NUMBER AS
  3   	v_res	NUMBER;
  4  BEGIN
  5   	SELECT COALESCE(MIN(t.val), 0) AS val
  6   	  INTO v_res
  7   	  FROM t_table t
  8   	 WHERE t.id = i_id;
  9  
 10   	RETURN v_res;
 11  END;
 12  /