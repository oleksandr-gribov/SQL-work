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



-- Question 1 
-- a) 
select distinct s.sid, s.sname
from student s, buys by, cites c
where s.sid = by.sid and by.bookNo = c.bookNo

-- b) 

select distinct s.sid, s.sname
from student s, major m, major m1
where s.sid = m.sid and s.sid = m1.sid and m1.major <> m.major;


-- c)
select distinct t.sid
from buys t
except 
(select t1.sid 
from buys t1, buys t
where t.sid = t1.sid and t.bookno <> t1.bookno); 

-- d) 

(select b.bookno, b.title
from book b, buys t
where t.sid = '1001')
except 
select distinct b.bookno, b.title
from book b, buys t
where t.sid != '1001'; 

-- e)
 select distinct s.sid, s.sname 
from student s, buys t, buys t1, book b
where s.sid = t.sid and s.sid = t1.sid and t1.bookno <> t.bookno and b.price < 50; 

-- f) 
with 
E1 as (select s.sid from major s where major = 'CS'), 
E2 as (select t.sid, t.bookno from buys t, E1 where E1.sid = t.sid), 
E3 as (select t.bookno from buys t)
(select bookno from E3) except (select bookno from E2);


-- g) 
select t.bookno 
from buys t
except 
select c.bookno
from cites c, book b
where c.citedbookno = b.bookno and b.price > 50; 

-- h) 
select distinct  t.sid, t.bookno
from buys t 
except 
(select t.sid, t.bookno
from buys t, cites c
where t.sid = c.bookno); 

-- i) 

select distinct  t.bookno, t1.bookno 
from buys t, major m, buys t1
where t.sid = t1.sid and t.sid = m.sid and m.major = 'CS' and t1.bookno <> t.bookno; 

-- j) 
select distinct s1.sid id1, s2.sid id2
from student s1, student s2, buys b1
where s1.sid <> s2.sid 
	and (exists(select bookno 
	            from buys by 
	            where s1.sid = by.sid and by.bookno = b1.bookno) 
	      		and exists(select bookno 
			 	from buys by
			 	where s2.sid = by.sid and by.bookno = b1.bookno)); 





--------------------------------------
-- Question 2

-- a)
select distinct  m.sid, m.major
       from   major m,buys t, book b
       where  m.sid = t.sid and t.bookno = b.bookno and b.price < 20; 
       
       
       
-- b) 

select distinct q.sid, q.bookno
       from   (select t.bookno, b.price, t.sid
       		   from buys t,book b
       		   except 
       		   select t1.bookno, b1.price,t1.sid
       		   from buys t1, book b1, book b
       		   where not b.price <= b1.price)q; 
-- c) 
with 
E1 as (select m.sid, m.name from major m intersect (select s.sid from student s)),
E2 as (select t.bookno from buys t, cites c where (E1.sid in t.sid ) and (t.bookno in c.bookno)), 
E3 as (select b.price from book b)
(select s.sid, s.sname from ((E2 join E2 on bookno = bookno) join E3 on bookno = bookno) 
where E2.price > E2.price and bookno <> bookno);    		   

-- d) 

