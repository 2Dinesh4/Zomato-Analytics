-- Q1 Salespeople table

CREATE TABLE Salespeople (snum INT PRIMARY KEY, sname VARCHAR(50), city VARCHAR(50), comm DECIMAL(4, 2));

INSERT INTO Salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New York', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);
select * from salespeople;

-- Q2 cust table

CREATE TABLE Cust (cnum INT PRIMARY KEY, cname VARCHAR(50), city VARCHAR(50), rating INT, snum INT, FOREIGN KEY (snum) REFERENCES Salespeople(snum));

INSERT INTO Cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007);
select * from cust;

-- Q3 orders table

CREATE TABLE Orders (onum INT PRIMARY KEY, amt DECIMAL(10, 2), odate DATE, cnum INT, snum INT,
FOREIGN KEY (cnum) REFERENCES Cust(cnum),FOREIGN KEY (snum) REFERENCES Salespeople(snum));

INSERT INTO Orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1001),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-04', 2004, 1002),
(3006, 1098.16, '1994-10-04', 2006, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1007),
(3009, 1713.23, '1994-10-06', 2008, 1007),
(3010, 1309.95, '1994-10-06', 2002, 1003),
(3011, 9891.88, '1994-10-06', 2006, 1004);
select * from orders;

-- Q4 Write a query to match the salespeople to the customers according to the city they are living.

SELECT s.sname AS Salesperson_Name, s.city AS Salesperson_City, c.cname AS Customer_Name, 
 c.city AS Customer_City FROM Salespeople s JOIN Cust c ON s.city = c.city;


-- Q5 Write a query to select the names of customers and the salespersons who are providing service to them.

select cust.cname, salespeople.sname from  cust join salespeople on cust.snum = salespeople.snum;
    
-- 6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT o.onum, o.amt, o.odate, c.cname AS Customer_Name, c.city AS Customer_City,
s.sname AS Salesperson_Name, s.city AS Salesperson_City FROM Orders o JOIN Cust c ON o.cnum = c.cnum
JOIN Salespeople s ON o.snum = s.snum WHERE c.city <> s.city;

-- 7.	Write a query that lists each order number followed by name of customer who made that order

SELECT o.onum AS Order_Number, c.cname AS Customer_Name FROM Orders o JOIN Cust c ON o.cnum = c.cnum;

-- 8.	Write a query that finds all pairs of customers having the same rating

SELECT C1.cname AS Customer1_Name, C2.cname AS Customer2_Name, C1.rating AS Rating FROM Cust C1 
INNER JOIN Cust C2 ON C1.rating = C2.rating AND C1.cnum < C2.cnum;
    
-- 9.	Write a query to find out all pairs of customers served by a single salesperson

SELECT c1.cname AS Customer1, c2.cname AS Customer2, c1.snum AS Salesperson
FROM Cust c1 JOIN Cust c2 ON c1.snum = c2.snum AND c1.cnum < c2.cnum; -- Avoid duplicate pairs and self-pairs
    
 -- 10.	Write a query that produces all pairs of salespeople who are living in same city
 
SELECT s1.sname AS Salesperson1, s2.sname AS Salesperson2, s1.city AS City
FROM Salespeople s1 JOIN Salespeople s2 ON s1.city = s2.city AND s1.snum < s2.snum; -- Avoid duplicate pairs and self-pairs
    
-- Q11 Write a Query to find all orders credited to the same salesperson who services Customer 2008

select * from orders where snum = (select snum from Cust where cnum = 2008);

-- Q12 Write a Query to find out all orders that are greater than the average for Oct 4th

select * from orders where amt > (select avg(amt) from orders where odate='1994-10-04');

-- Q13 Write a Query to find all orders attributed to salespeople in London.

SELECT * FROM Orders WHERE snum IN (SELECT snum FROM Salespeople WHERE city = 'London');

-- Q14 Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 
SELECT * FROM cust WHERE cnum = (SELECT snum + 1000 FROM Salespeople WHERE sname = 'Serres');
    
-- Q15	Write a query to count customers with ratings above San Jose’s average rating.

SELECT COUNT(*) AS cnum FROM cust WHERE rating > (SELECT AVG(rating) FROM cust WHERE city = 'San Jose');

-- Q16	Write a query to show each salesperson with multiple customers.

SELECT s.snum AS Salesperson_ID, s.sname AS Salesperson_Name,COUNT(c.cnum) AS Customer_Count
FROM Salespeople s JOIN Cust c ON s.snum = c.snum GROUP BY s.snum, s.sname HAVING COUNT(c.cnum) > 1;

