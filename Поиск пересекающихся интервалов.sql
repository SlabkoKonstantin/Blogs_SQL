--DROP TABLE table1;

CREATE TABLE table1
(
   id            NUMBER
  ,description   VARCHAR2(100)
  ,dt_s          DATE
  ,dt_e          DATE
)
/

INSERT INTO table1(id, description, dt_s, dt_e) VALUES (1,'Interval A',TO_DATE('01.02.2018', 'dd.mm.yyyy'),TO_DATE('07.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, dt_s, dt_e) VALUES (4,'Interval B',TO_DATE('09.02.2018', 'dd.mm.yyyy'),TO_DATE('12.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, dt_s, dt_e) VALUES (3,'Interval C',TO_DATE('10.02.2018', 'dd.mm.yyyy'),TO_DATE('14.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, dt_s, dt_e) VALUES (2,'Interval D',TO_DATE('13.02.2018', 'dd.mm.yyyy'),TO_DATE('16.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, dt_s, dt_e) VALUES (5,'Interval E',TO_DATE('18.02.2018', 'dd.mm.yyyy'),TO_DATE('28.02.2018', 'dd.mm.yyyy'));
INSERT INTO table1(id, description, dt_s, dt_e) VALUES (6,'Interval F',TO_DATE('20.02.2018', 'dd.mm.yyyy'),TO_DATE('25.02.2018', 'dd.mm.yyyy'));
COMMIT;

SELECT a.id          a_id
      ,a.description a_descr
      ,a.dt_s        a_start
      ,a.dt_e        a_end
      ,b.id          b_id
      ,b.description b_descr
      ,b.dt_s        b_start
      ,b.dt_e        b_end
  FROM table1 a , table1 b 
 WHERE 
   a.id < b.id
   and (a.dt_s <= b.dt_e
    AND a.dt_e >= b.dt_s)
    