SQL> CREATE OR REPLACE FUNCTION get_val_with_exc(i_id IN NUMBER)
  2   	RETURN NUMBER AS
  3   	v_res	NUMBER;
  4  BEGIN
  5   	-- простая обработка исключений
  6   	SELECT t.val
  7   	  INTO v_res
  8   	  FROM t_table t
  9   	 WHERE t.id = i_id;
 10  
 11   	RETURN v_res;
 12  EXCEPTION
 13   	WHEN NO_DATA_FOUND
 14   	THEN
​
 15   	   RETURN 0;
 16   	WHEN OTHERS
 17   	THEN
 18   	   RAISE;
 19  END;
 20  /