-- Chapter 8 Exercises

--1: setup
USE TSQL2012;

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;

CREATE TABLE dbo.Customers
(
	custid		INT			 NOT NULL PRIMARY KEY,
	companyname	NVARCHAR(40) NOT NULL,
	country		NVARCHAR(15) NOT NULL,
	region		NVARCHAR(15) NULL,
	city		NVARCHAR(15) NOT NULL
);

--1.1:  Insert into dbo.Customers a row defined as follows
USE TSQL2012;
INSERT INTO dbo.Customers (custid, companyname, country, region, city)
	VALUES(100, N'Coho Winery', N'USA', N'WA', N'Redmond');

--test
SELECT * FROM dbo.Customers;

--1.2:  Insert into dbo.Customers all customers from Sales.Customers who
--	placed orders
USE TSQL2012;

INSERT INTO dbo.Customers(custid, companyname, country, region, city) 
 SELECT C.custid, C.companyname, C.country, C.region, C.city
 FROM Sales.Customers AS C JOIN Sales.Orders AS O ON C.custid = O.custid
 GROUP BY C.custid, C.companyname, C.country, C.region, C.city; 
 
--1.3: Uses SELECT INTO to create and populate the dbo.Orders table with
--	orders placed in ther years 2006-2008
USE TSQL2012;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders; 

SELECT *
INTO dbo.Orders
FROM Sales.Orders
WHERE YEAR(orderdate) > '2005' AND YEAR(orderdate) < '2009';

--2:  Delete from dbo.Orders any order placed before Aug 2006, and 
--	output the orderid and date of deleted orders
USE TSQL2012;

DELETE FROM dbo.Orders
	OUTPUT
		deleted.orderid, deleted.orderdate
WHERE orderdate < '20060801';

--3: Delete from dbo.Orders table orders placed by customers from Brazil
USE TSQL2012;

DELETE FROM O
	FROM dbo.Orders AS O JOIN Sales.Customers AS C
	ON O.custid = C.custid
WHERE C.country = N'Brazil';

--4: Update dbo.Customers table and change NULL region vales to <none>,
-- use OUTPUT to demonstrate the change
SELECT * FROM dbo.Customers;

USE TSQL2012;
UPDATE dbo.Customers
	SET region = N'<none>'
OUTPUT inserted.custid, deleted.region AS oldregion, inserted.region AS newregion
WHERE region IS NULL;

--5: Update all orders in the dbo.orders table that were placed by United Kingdom
--	customers and set their shipcountry, shipregion, and shipcity values to the
-- country, region, and city values of the corresponding customers
USE TSQL2012;

UPDATE O
	SET shipcountry = country, shipregion = region, shipcity = city
FROM dbo.Orders AS O JOIN dbo.Customers as C
	ON O.custid = C.custid
WHERE country = N'UK';


--Test 
SELECT O.orderid, C.custid, C.country, O.shipcountry, shipregion, region, shipcity, city
FROM dbo.Orders AS O JOIN dbo.Customers as C
	ON O.custid = C.custid
WHERE country = N'UK';

--6: Cleanup code
USE TSQL2012;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders; 
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;