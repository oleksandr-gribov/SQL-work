-- Assignment 1
-- Oleksandr Gribov


-- 1.
CREATE DATABASE OG_db;
\c OG_db;

CREATE TABLE Sailor ( 
	Sid INTEGER NOT NULL PRIMARY KEY,
	Bname  VARCHAR(20),
	Rating INTEGER, 
    Age INTEGER); 


CREATE TABLE Boat ( 
	Bid INTEGER NOT NULL PRIMARY KEY,
	Bname VARCHAR(15), 
	Color VARCHAR (15)); 	
	
CREATE TABLE Reserves ( 
	Sid INTEGER NOT NULL, 
	Bid INTEGER NOT NULL,
	DayOf VARCHAR (10),
    PRIMARY KEY (Sid, Bid), 
	FOREIGN KEY (Sid) REFERENCES Sailor(Sid),
	FOREIGN KEY (Bid) REFERENCES Boat(Bid));

INSERT INTO Boat (Bid, Bname, Color)
VALUES 
	(101,	'Interlake',	'blue'),
	(102,	'Sunset',	'red'),
	(103,	'Clipper',	'green'),
	(104,	'Marine',	'red');

INSERT INTO Sailor (Sid, Bname, Rating, Age)
VALUES 
	(22,   'Dustin',       7,      45),
	(29,   'Brutus',       1,      33),
	(31,   'Lubber',       8,      55),
	(32,   'Andy',         8,      25),
	(58,   'Rusty',        10,     35),
	(64,   'Horatio',      7,      35),
	(71,   'Zorba',        10,     16),
	(74,   'Horatio',      9,      35),
	(85,   'Art',          3,      25),
	(95,   'Bob',          3,      63);


INSERT INTO Reserves (Sid, Bid, DayOf) 
VALUES 
	(22,	101,	'Monday'),
(22,	102,	'Tuesday'),
(22,	103,	'Wednesday'),
(31,	102,	'Thursday'),
(31,	103,	'Friday'),
(31,      104,	'Saturday'),
(64,	101,	'Sunday'),
(64,	102,	'Monday'),
(74,	102,	'Saturday');

	
/* 2. If the Reserves table didn't have primary key component consisting of two 
	  fields, then it would be hard to insert multiple reservations for the same boat
	  or the same sailor into it. For example, if the Boat ID was the primary key, then 
	  we would only be able to insert one reservation for one boat into it. Conversely,
	  if the Sailor ID was the primary key then only one reservation per sailor could have
	  been entered because all others would result in a conflict. However, having the 
	  primary key be a pairing of sailor and boat allows us to most accurately represent 
	  the reservations. 
*/



--3.a)
SELECT Rating FROM Sailor;
--b)
SELECT 
    Bid, 
    Color
FROM 
    Boat;
    
--c) 
SELECT 
    Bname
FROM 
    Sailor
WHERE 
    Age >= 15 AND Age <=30;
--d)
SELECT Bname
    FROM Boat
    WHERE Bid IN (
        SELECT Bid
            FROM Reserves
            WHERE DayOf = 'Saturday' OR DayOf = 'Sunday'
        );
--e) 
SELECT Bname 
FROM sailor 
WHERE Sid IN ( 
    SELECT Sid 
    FROM Reserves 
    WHERE Bid IN (
        SELECT Bid
        FROM Boat
        WHERE Color = 'green' OR Color ='red')); 
--f)
SELECT Sid
FROM Reserves
WHERE Bid IN (
    SELECT s."Sid", s."Bname" 
    FROM "boat" B, "sailor" S, "reserves" R 
    WHERE b.Color = 'red' AND b.Bid = r.Bid AND s.Sid = R.Sid
    EXCEPT 
        SELECT Bid
        FROM Boat
        WHERE Color = 'green' OR Color = 'blue');

        
-- g)
SELECT Bname 
FROM sailor 
WHERE Sid IN ( 
    SELECT Sid 
    FROM Reserves 
    GROUP BY Sid 
    HAVING COUNT (Sid) >=2);  
--h) 
SELECT Sid 
FROM sailor
EXCEPT  
        SELECT Sid
        FROM reserves;

-- i) 
SELECT Sid 
FROM Reserves
WHERE DayOf = 'Saturday';

--j)








        
        
        
        
           