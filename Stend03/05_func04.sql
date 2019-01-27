SQL> CREATE OR REPLACE FUNCTION get_val_subquery(i_id IN NUMBER)
  2  	RETURN NUMBER AS
  3  	v_res	NUMBER;
  4  BEGIN
  5  	SELECT coalesce( (SELECT t.val
  6  		  FROM t_table t
  7  		 WHERE t.id = i_id), 0)
  8  		  AS val
  9  	  INTO v_res
 10  	  FROM DUAL;
 11  
 12  	RETURN v_res;
 13  END;
 14  /