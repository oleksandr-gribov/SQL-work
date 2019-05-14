--  Oleksandr Gribov
-- Assignment 3 


-- Question 1 


-- creating the table 
create table first (x int);
-- populating the table
insert into first (x) values 
	(1),
	(2), 
	(3), 
	(4), 
	(5);
	
-- function declaration 	
create function Exercise1()
returns table (x int,  square_root_x float,  x_squared int,  two_to_the_power_x float,  x_factorial numeric,  logarithm_x double precision) 
as 
$$

	select x, SQRT(x), x*x, power(2, x), x!, log(x) from first x ; 
$$ Language SQL; 
 


---------------------------------------------------------
-- Question 2 
create function exercise2() 
returns table ( empty_a_minus_b boolean,  not_empty_symmetric_difference boolean, 
empty_a_intersection_b boolean) 
as 
$$
	select 
			(select exists( 
			select * 
			from seta, setb 
			where (select count(1)
					from(select *
					from seta
					except 
					select * 
					from setb)a) =0)),
(select exists(
		select 
		from seta, setb
		where (select count(1)
			from(select * 
						from  (
							(select *
							from seta
							except 
							select * 
							from setb)
							union
							(select * 
							from setb
							except 
							select * 
							from seta))a)b)>0)), 
(select exists( 
select * 
from seta, setb
where (select count(1)
			from(select *
					from seta
					intersect 
					select * 
					from setb) b) >0)) 				
 
$$ Language sql; 

-- Question 3 
create table pair (x1 int, y1 int); 
select p1.x1,p1.y1,p2.x1,p2.x2
from pair p1, pair p2
where (p1.x1 + p1.y1) = (p2.x1 + p2.y1) and p1.x1 != p2.x1 and p1.y1 != p2.y1; 




---------------------------------------------------------
-- Question 4 
-- a) set operation solution 
select exists (
select * 
	from (select * 
			from seta
			union 
			select * 
			from setb)a);
-- JOIN solution
select exists (
select * 
	from (select * 
			from seta
			inner join setb on setb.b = seta.a)a); 
-- b) 
-- if A is a subset of B then A-B must be empty
-- set operation solution 
select not exists(
select * 
	from(select * 
	from seta
	except 
	select * 
	from setb)b);
-- JOIN solution 
select not exists(
select * 
	from(select * 
	from seta
	left join setb
	on seta.a = setb.b 
	where setb.b is null)b);

--c) 
-- if A intersect B is equal to B then B-A must be empty 
--set operation solution 
select not exists (
	select * from(
			select setb.b
			from setb
			except 
			select seta.a
			from seta) a); 
-- JOIN solution 
select not exists (
	select * from(
			select * 
			from seta 
			right join setb 
			on seta.a = setb.b 
			where seta.a is null) a); 

-- d)
-- if A and B are not equal then A-B cannot be empty
--set operation solution 
select not exists (
	select * from(
		select setb.b
		from setb
		except 
		select seta.a
		from seta) a);
-- JOIN solution 
select not exists (
	select * from(
		select * 
		from seta
		left join setb
		on seta.a = setb.b 
		where setb.b is null) a);

-- e) 
-- check if there are two distinct numbers in a that are also in b 
-- if not, then the condition is true 
--set operation solution 
select not exists (
	select *
	from (select a1.a, a2.a 
			from seta a1, seta a2
			where a1.a <> a2.a and 
			a1.a in (select * 
					from setb b) and 
			a2.a in (select * 
					from setb b))a);
					
-- another solution 
select exists(
select 1
from
	(select a from a except
		((select a from a except select b from b)
		union
		(select b from b except select a from a))) as a1,
	(select a from a except
		((select a from a except select b from b)
		union
		(select b from b except select a from a))) as a2
where a1.a <> a2.a);

--f)
-- if AUB is a subset of C then (AUB)-C must be empty
--set operation solution  
select not exists(
select *
	from (select * 
		from setc
		except(
		select * 
		from seta
		union 
		select * 
		from setb))b);

-- JOIN solution 
select not exists (
select * 
	from seta
	full outer join setb
	on seta.a = setb.b 
	right join setc
on seta.a = setc.c and setb.b = setc.c 
where setc.c is null);

-- g) 
--set operation solution 
select exists(
select * 
		from (select * 
			from ( (select * 
					from seta
					except 
					select * 
					from setb)
					union 
					(select * 
					from setb
					except 
					select* 
					from setc))a)b); 



---------------------------------------------------------

-- Question 5 
-- a) 
select exists (
select * 
from seta, setb
where (select count(1)
	from (select * 
			from seta
			union 
			select * 
			from setb)a)> 0);
-- b) 
-- if A is a subset of B then A-B must be empty
select exists(
select * 
from seta, setb
where (select count(1)
	from(select * 
	from seta
	except 
	select * 
	from setb)b) = 0);   

-- c)
-- if A intersect B is equal to B then B-A must be empty 
select exists (
	select *
	from seta, setb
	where 0=(select count(*) from(
			select setb.b
			from setb
			except 
			select seta.a
			from seta) a)); 

-- d)
-- if A and B are not equal then A-B cannot be empty
select exists (
	select *
	from seta, setb
	where 0<=(select count(*) from(
		select setb.b
		from setb
		except 
		select seta.a
		from seta) a)); 



-- e) 
-- count the number of items in the intersect
select exists (
	select *
	from seta, setb
	where 2 >=(select count(*) from(
			select seta.a
			from seta
			intersect 
			select setb.b
			from setb) a)); 
			
--f)
-- if AUB is a subset of C then (AUB)-C must be empty 
select exists(
select * 
from setc
where (select count(1)
	from (select * 
		from setc
		except(
		select * 
		from seta
		union 
		select * 
		from setb))b) =0);
		
		
-- g) 
select exists(
select * 
from seta,setb,setc
where (select count(1)
		from (select * 
			from ( (select * 
					from seta
					except 
					select * 
					from setb)
					union 
					(select * 
					from setb
					except 
					select* 
					from setc))a)b) = 1) ;

--------------------------------------------------------- 
-- Question 6 

-- creating tables
create table Student (
	Sid integer primary key not null,
	Sname varchar(15));
	
create table Major (
	Sid integer not null,
	Major varchar(15),
	primary key (Sid, Major));

create table Book (
	BookNo integer primary key not null,
	Title varchar(30),
	Price integer); 
	
create table Cites (
	BookNo integer,
	CitedBookNo integer,
	primary key (BookNo, CitedBookNo),
	foreign key (BookNo) references Book(BookNo),
	foreign key (CitedBookNo) references Book(BookNo));
	
create table Buys (
	Sid integer not null, 
	BookNo integer,
	primary key (Sid, BookNo),
	foreign key (BookNo) references Book(BookNo),
	foreign key (Sid) references Student(Sid));


-- populating tables

insert into Book (BookNo, Title, Price) values 
	(2001,  'Databases',  40),
	(2002,  'OperatingSystems', 25),
	(2003,  'Networks',   20),
	(2004,  'AI',    45),
	(2005,  'DiscreteMathematics',    20),
	(2006,  'SQL',   25),
	(2007,  'ProgrammingLanguages',   15),
	(2008,  'DataScience', 50),
	(2009,  'Calculus',   10),
	(2010,  'Philosophy', 25),
	(2012,  'Geometry',   80),
	(2013,  'RealAnalysis',     35),
	(2011, 'Anthropology',     500),
	(2014,  'Topology',   70);


insert into buys (Sid, bookno) values 
	(1023,2012),
	(1023,2014),
	(1040,2002),
	(1001,2002),
	(1001,2007),
	(1001,2009),
	(1001,2011),
	(1001,2013),
	(1002,2001),
	(1002,2002),
	(1002,2007),
	(1002,2011),
	(1002,2012),
	(1002,2013),
	(1003,2002),
	(1003,2007),
	(1003,2011),
	(1003,2012),
	(1003,2013),
	(1004,2006),
	(1004,2007),
	(1004,2008),
	(1004,2011),
	(1004,2012),
	(1004,2013),
	(1005,2007),
	(1005,2011),
	(1005,2012),
	(1005,2013),
	(1006,2006),
	(1006,2007),
	(1006,2008),
	(1006,2011),
	(1006,2012),
	(1006,2013),
	(1007,2001),
	(1007,2002),
	(1007,2003),
	(1007,2007),
	(1007,2008),
	(1007,2009),
	(1007,2010),
	(1007,2011),
	(1007,2012),
	(1007,2013),
	(1008,2007),
	(1008,2011),
	(1008,2012),
	(1008,2013),
	(1009,2001),
	(1009,2002),
	(1009,2011),
	(1009,2012),
	(1009,2013),
	(1010,2001),
	(1010,2002),
	(1010,2003),
	(1010,2011),
	(1010,2012),
	(1010,2013),
	(1011,2002),
	(1011,2011),
	(1011,2012),
	(1012,2011),
	(1012,2012),
	(1013,2001),
	(1013,2011),
	(1013,2012),
	(1014,2008),
	(1014,2011),
	(1014,2012),
	(1017,2001),
	(1017,2002),
	(1017,2003),
	(1017,2008),
	(1017,2012),
	(1020,2001),
	(1020,2012),
	(1022,2014);

insert into major (Sid, major) values 
	(1001,'Math'),
	(1001,'Physics'),
	(1002,'CS'),
	(1002,'Math'),
	(1003,'Math'),
	(1004,'CS'),
	(1006,'CS'),
	(1007,'CS'),
	(1007,'Physics'),
	(1008,'Physics'),
	(1009,'Biology'),
	(1010,'Biology'),
	(1011,'CS'),
	(1011,'Math'),
	(1012,'CS'),
	(1013,'CS'),
	(1013,'Psychology'),
	(1014,'Theater'),
	(1017,'Anthropology'),
	(1022,'CS'),
	(1015,'Chemistry');

insert into Student (Sid, Sname) values 
	(1001,' Jean'),
	(1002,'Maria'),
	(1003,'Anna '),
	(1004,'Chin '),
	(1005,'John '),
	(1006,' Ryan'),
	(1007,'rine '),
	(1008,'Emma '),
	(1009,' Jan '),
	(1010,'Linda'),
	(1011,'Nick '),
	(1012,'Eric '),
	(1013,'Lisa '),
	(1014,'Filip'),
	(1015,'Dirk '),
	(1016,'Mary '),
	(1017,'llen '),
	(1020,'Greg '),
	(1022,' Qin '),
	(1023,'anie '),
	(1040,', Pam');


-- 6.a 
create function booksBoughtByStudent (sid1 int)
returns table (bookno int, title varchar(30), price int) 
as 
 $$
	select distinct c.bookno, c.title, c.price 
	from buys b, book c, student s
	where s.sid = b.sid and c.bookno = b.bookno and S.sid = sid1;
$$ language sql; 

select bookno, title, price
from booksboughtbystudent(1001) t;

select bookno, title, price
from booksboughtbystudent(1015) t;


-- 6.b 
-- i) 
create function studentswhoboughtbook (bookno1 int) 
returns table (sid int, sname varchar(15))
as 
$$
select distinct S.sid, S.sname
from student s, buys b, book c
where S.sid = b.sid and b.bookno = c.bookno and b.bookno = bookno1
 $$language sql;
 
--ii)

select sid, sname 
from studentswhoboughtbook (2001);

select sid, sname 
from studentswhoboughtbook (2010);

--iii)

-- 6.c.i
select M.sid, M.major
from major m
where (select count(1) 
		from (select Bu.bookno
				from Buys bu
				where bu.Sid = m.sid
				intersect 
				select b.bookno
				from book b
				where b.price > 30)b) >=4; 

-- c.ii
select S.s1, S.s2
from Student s 
where (select sum()
		from (select Bu.bookno
				from Buys bu
				where bu.s1 = m.s2
				intersect 
				select b.bookno
				from book b)b) = (select sum() 
					from (select Bu.bookno
					from Buys bu
					where bu.s1 = m.s2
					intersect 
					select b.bookno)) ; 

-- c.iii
create function amountspentonbook(sid int) 
returns table (sid int, price int) 
as 
$$ 
	select select from Buys bu
				where bu.Sid = m.sid
				intersect 
				select b.bookno
				from book b
$$ language sql; 

select Sid, sname 
from student s
where amoutspentonbook(sid) > (avg(amountspentonbook(select sid 
													from student s)));
													

-- c.iv
	select bookno, price 
from books b
except (select b2.id 
		from books b2 
		where b2.bookno=book.bookno)
except (select b1.id 
		from books b1 
		where b1.bookno=book.bookno) except (select (b.id = book.bookno) and b.price = max(b.price)); 

-- c.v
	(select distinct b.bookno, b.title
 		from book b
 		union 
 		select distinct b.bookno, b.title
 		from book b, buys bu, major m
 		where b.bookno = bu.bookno and bu.sid = m.sid and m.major = 'CS')
 			except
		(select distinct b.bookno, b.title
 		from book b, buys bu, major m
 		where b.bookno = bu.bookno and bu.sid = m.sid and m.major <> 'CS');
 		

-- c.vi
select bookno, price 
from books b
except (select b2.id 
		from books b2 
		where b2.bookno=book.bookno)
except (select b1.id 
		from books b1 
		where b1.bookno=book.bookno) except (select (b.id = book.bookno) and b.price = max(b.price)); 

-- c.vii
select s.Sid, B.bookno
from student s, book b
where amoutspentonbook(sid) < (avg(amountspentonbook(select sid 
													from student s)/ (booksBoughtByStudent(select s.Sid
																						from student s))));	
																					
																					
-- c.viii
(select distinct s1.sid, s2.sid
 		from major s1, major s2
 		union 
 		select distinct b.bookno, b.title
 		from book b, buys bu, major m
 		where b.bookno = bu.bookno and bu.sid = m.sid and s1.major = s2.major)
 			union
		(select count (booksBoughtByStudent(sid)
 		from book b, buys bu, major m
 		where b.bookno = bu.bookno and bu.sid = m.sid));

-- c.ix
select distinct s1.sid, s2.sid, n
 		from major s1, major s2
 		union 
 		select distinct b.bookno, b.title
 		from book b, buys bu, major m
 		where b.bookno = bu.bookno and bu.sid = m.sid and s1.major = s2.major and s1.major = 'CS' and s2.major = 'CS')
 			union
		(select count (booksBoughtByStudent(sid)
 		from buys Bu
 		where b1.bookno=book.bookno)); 