--DROP TABLE table1;

CREATE TABLE table1
(
   id            NUMBER
  ,description   VARCHAR2(100)
  ,d_start          DATE
  ,d_end          DATE
)
/

INSERT INTO table1(id, description, d_start, d_end) VALUES (1,'Interval A',TO_DATE('02.02.2018', 'dd.mm.yyyy'),TO_DATE('05.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, d_start, d_end) VALUES (2,'Interval D',TO_DATE('04.02.2018', 'dd.mm.yyyy'),TO_DATE('10.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, d_start, d_end) VALUES (3,'Interval C',TO_DATE('09.02.2018', 'dd.mm.yyyy'),TO_DATE('12.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, d_start, d_end) VALUES (4,'Interval B',TO_DATE('14.02.2018', 'dd.mm.yyyy'),TO_DATE('16.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, d_start, d_end) VALUES (5,'Interval E',TO_DATE('19.02.2018', 'dd.mm.yyyy'),TO_DATE('27.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, d_start, d_end) VALUES (6,'Interval F',TO_DATE('20.02.2018', 'dd.mm.yyyy'),TO_DATE('25.02.2018', 'dd.mm.yyyy'));
COMMIT;

SELECT a.id          a_id
      ,a.description a_descr
      ,a.d_start a_start
      ,a.d_end a_end
      ,d.id
      ,d.DESCRIPTION
      ,d.d_start d_start
      ,d.d_end d_end            
  FROM table1 a, table1 d   
 WHERE 
  (a.d_start <= d.d_end AND a.d_end >= d.d_start) -- в 2-х таблицах находим пересекающиеся интервалы    
  and a.id != d.id -- убираем пересечения интервала с самим собой
