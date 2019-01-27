SQL> DECLARE
  2  	TYPE t_row IS RECORD
  3  	(
  4  	   description	 CHAR(16)
  5  	  ,val_0	 VARCHAR2(10)
  6  	  ,val_5	 VARCHAR2(10)
  7  	  ,val_10	 VARCHAR2(10)
  8  	  ,val_25	 VARCHAR2(10)
  9  	  ,val_50	 VARCHAR2(10)
 10  	  ,val_75	 VARCHAR2(10)
 11  	  ,val_90	 VARCHAR2(10)
 12  	);
 13  
 14  	TYPE t_table IS TABLE OF t_row
 15  	   INDEX BY PLS_INTEGER;
 16  
 17  	v_table   t_table;
 18  	v_count   PLS_INTEGER;
 19  
 20  	FUNCTION get_timing(i_descr IN VARCHAR2, i_count IN NUMBER, i_percent IN NUMBER)
 21  	   RETURN VARCHAR2 IS
 22  	   v_res	  VARCHAR2(8);
 23  	   v_start_time   INTEGER;
 24  	   v_start	  NUMBER;
 25  	   v_end	  NUMBER;
 26  	   v_rows	  NUMBER;
 27  	   v		  INTEGER;
 28  	BEGIN
 29  	   v_rows := (i_percent * i_count) / 100;
 30  
 31  	   IF (v_rows > 0)
 32  	   THEN
 33  	      v_start := v_rows * -1;
 34  	      v_end := i_count - v_rows;
 35  	   ELSE
 36  	      v_start := 1;
 37  	      v_end := i_count;
 38  	   END IF;
 39  
 40  	   v_start_time := DBMS_UTILITY.get_time;
 41  
 42  	   FOR i IN v_start .. v_end
 43  	   LOOP
 44  	      CASE (i_descr)
 45  		 WHEN 'get_val_with_exc'
 46  		 THEN
 47  		    v := get_val_with_exc(i);
 48  		 WHEN 'get_val_max'
 49  		 THEN
 50  		    v := get_val_max(i);
 51  		 WHEN 'get_val_loop'
 52  		 THEN
 53  		    v := get_val_loop(i);
 54  		 WHEN 'get_val_subquery'
 55  		 THEN
 56  		    v := get_val_subquery(i);
 57  		 ELSE
 58  		    NULL;
 59  	      END CASE;
 60  	   END LOOP;
 61  
 62  	   v_res := TO_CHAR(((DBMS_UTILITY.get_time - v_start_time) / 100), '9990.00');
 63  	   RETURN v_res;
 64  	END;
 65  
 66  	FUNCTION fill_row(i_descr IN CHAR, i_count IN NUMBER)
 67  	   RETURN t_row IS
 68  	   v_res   t_row;
 69  	BEGIN
 70  	   v_res.description := i_descr;
 71  	   v_res.val_0 := get_timing(i_descr, i_count, 0);
 72  	   v_res.val_5 := get_timing(i_descr, i_count, 5);
 73  	   v_res.val_10 := get_timing(i_descr, i_count, 10);
 74  	   v_res.val_25 := get_timing(i_descr, i_count, 25);
 75  	   v_res.val_50 := get_timing(i_descr, i_count, 50);
 76  	   v_res.val_75 := get_timing(i_descr, i_count, 75);
 77  	   v_res.val_90 := get_timing(i_descr, i_count, 90);
 78  	   RETURN v_res;
 79  	END;
 80  
 81  BEGIN
 82  	SELECT COUNT(*) INTO v_count FROM t_table;
 83  
 84  	-- header
 85  	v_table(1).description := '';
 86  	v_table(1).val_0 := '0%';
 87  	v_table(1).val_5 := '5%';
 88  	v_table(1).val_10 := '10%';
 89  	v_table(1).val_25 := '25%';
 90  	v_table(1).val_50 := '50%';
 91  	v_table(1).val_75 := '75%';
 92  	v_table(1).val_90 := '90%';
 93  	v_table(2) := fill_row('get_val_with_exc', v_count);
 94  	v_table(3) := fill_row('get_val_max', v_count);
 95  	v_table(4) := fill_row('get_val_loop', v_count);
 96  	v_table(5) := fill_row('get_val_subquery', v_count);
 97  
 98  	-- выводим результат в виде таблицы
 99  	dbms_output.put_line('----------------------------------------------------------------------------');
100  	FOR i IN 1 .. v_table.COUNT
101  	LOOP
102  	   DBMS_OUTPUT.put_line(
103  		 '|'
104  	      || v_table(i).description
105  	      || '|'
106  	      || v_table(i).val_0
107  	      || '|'
108  	      || v_table(i).val_5
109  	      || '|'
110  	      || v_table(i).val_10
111  	      || '|'
112  	      || v_table(i).val_25
113  	      || '|'
114  	      || v_table(i).val_50
115  	      || '|'
116  	      || v_table(i).val_75
117  	      || '|'
118  	      || v_table(i).val_90
119  	      || '|');
120  	END LOOP;
121  	dbms_output.put_line('----------------------------------------------------------------------------');
122  END;
123  /​