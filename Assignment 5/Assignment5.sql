-- Oleksandr Gribov


-- Question 1


-- non optimized query 
select distinct s.sid,s.sname, b.bookno, b.title 
from student s 
	cross join book b 	inner join buys t on ((s.sname = 'Eric' or s.sname = 'Anna') and 
						s.sid = t.sid and 
						b.price > 20 and 
						t.bookno = b.bookno); 
	
--intermediate					
select distinct s.sid,s.sname, b.bookno, b.title
from (select sid, sname from student where sname = 'Eric' or sname = 'Anna') s
      cross join book b
	  inner join buys t on
	             s.sid = t.sid and
				 b.price > 20 and
				 t.bookno = b.bookno;

--intermediate
select distinct s.sid,s.sname, b.bookno, b.title
from (select sid, sname from student where sname = 'Eric' or sname = 'Anna') s
natural join buys t
cross join book b 
where b.price > 20 and t.bookno = b.bookno;
						
						
-- Optimized query
select distinct q1.sid,q1.sname, q1.bookno, q1.title 
from (((select sid, sname from Student where sname = 'Eric' or sname = 'Anna') s natural join 
	(select sid,bookno from Buys) t natural join 
	(select bookno, title from Book where price >20) b))q1;
	
------------------------------------------------------------------

-- Question 2

-- Non Optimized query 
select distinct s.sid
	from student s 
	cross join book b
	inner join buys t on ((s.sname = 'Eric' or s.sname = 'Anna') and 
							s.sid = t.sid and 
							b.price > 20 and 
							t.bookno = b.bookno); 
--intermediate
select sid from student where sname = 'Eric' or sname = 'Anna'
intersect
select sid
from buys t
cross join book b 
where b.price > 20 and t.bookno = b.bookno;
							
--Optimized Query		
select distinct q1.sid 
from (((select sid from student where sname = 'Anna' or sname = 'Eric') s natural join 
	(select distinct sid from Buys ) t natural join 
	(select distinct bookno from Book where price > 20)b))q1; 	
------------------------------------------------------------------

-- Question 3 

-- Non Optimized query
select distinct s.sid, b1.price as b1_price, b2.price as b2_price 
from (select s.sid from student s where s.sname <> 'Eric') s 
	cross join book b2 
	inner join book b1 on (b1.bookno <> b2.bookno and b1.price > 60 and b2.price >= 50)
	inner join buys t1 on (t1.bookno = b1.bookno and t1.sid = s.sid) 
	inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = s.sid); 

-- Optimized query 
With 
E1 as (select distinct sid, bookno from
			((select bookno from book where price> 60)e1 natural join
			(select sid, bookno from Buys)q2)q1), 
E2 as (select sid, bookno from Buys), 
E3 as (select bookno, price from Book where price >= 50), 
E4 as (select * from E2 natural join (select * from E3)q4), 
E5 as (select * from E4 natural join (select * from E4)q5), 
E6 as (select e5.price as price1, e5.price as price2 from E5 where bookno<>bookno and e5.price<> e5.price), 
E7 as (select sid from Student where sname <> 'Eric') 
Select sid, e6.price1 as price1, e6.price2 as price2 from E6 natural join (Select * from E7) q; 

------------------------------------------------------------------
-- Question 4 

-- Non Optimized query
select q.sid 
from (select s.sid, s.sname 
 		from student s 
		except 		select s.sid, s.sname 
		from student s 
			inner join buys t on (s.sid = t.sid)  inner join 
			book b on (t.bookno = b.bookno and b.price > 50)) q;
			
--intermediate			
select s.sid
from student s
except
select s.sid
from student s
	 inner join buys t on (s.sid = t.sid)
         inner join book b on (t.bookno = b.bookno and b.price > 50);			

-- Optimized query 
select distinct q.sid
from (select s.sid 
	from student s
	except 
	 (select sid from 
	 ((select sid, bookno from Buys) t natural join 
					(select bookno from Book where price >50)b)))q; 
------------------------------------------------------------------
-- Question 5 

-- Non Optimized query
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
      from student s
 	   cross join book b
      intersect
      select s.sid, s.sname, b.bookno
      from student s
           cross join book b
           inner join buys t on (s.sid = t.sid and t.bookno = b.bookno and b.price <25)) q;

--intermediate
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
	  from student s
	  intersect 
	  select s.sid, s.sname, b.bookno
	  from student s
	  	   cross join book b
	  	   inner join buys t on (s.sid = t.sid and t.bookno = b.bookno and b.price < 25)) q;

-- Optimized query 
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
	  from student s
	  intersect
	  select s.sid, s.sname, b.bookno
	  from student s
	  natural join buys
	  natural join (select bookno from book where price < 25) b) q;


------------------------------------------------------------------

-- Non Optimized query
select distinct q.bookno
from (select s.sid, s.sname, b.bookno, b.title
      from student s
           cross join book b
      except
      select s.sid, s.sname, b.bookno, b.title
      from student s
           cross join book b
           inner join buys t on (s.sid = t.sid and t.bookno = b.bookno and b.price <20)) q;

-- intermediate
select distinct q.bookno
from (select s.sid, b.bookno
	  from student s
	       cross join book b
	  except 
	  select s.sid, b.bookno
	  from student s
	         natural join buys
	         natural join (select bookno from book where price < 20) b) q;

-- Optimized query 
select bookno
from book
intersect 
select q.bookno
from (select s.sid, b.bookno
	  from student s
	       natural join book b
	  except 
	  select s.sid, b.bookno
	  from student s
	       natural join buys
	       natural join (select bookno from book where price < 20) b) q;














