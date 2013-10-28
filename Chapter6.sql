-- Chapter 6 Exercises

--1: Generates a virtual auxiliary table of 10 numbers in the range of 
--	1-10 without using a looping construct. (LAME...)
USE TSQL2012;
SELECT 1 AS n
UNION ALL SELECT 2
UNION ALL SELECT 3
UNION ALL SELECT 4
UNION ALL SELECT 5
UNION ALL SELECT 6
UNION ALL SELECT 7
UNION ALL SELECT 8
UNION ALL SELECT 9
UNION ALL SELECT 10;

--2: Queries Sales.Orders to return all customer and employee pairs that 
--	had order activity in Jan. 2008 but not in Feb. 2008
USE TSQL2012;

Select custid, empid
FROM Sales.Orders
WHERE '20080101' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101')
EXCEPT
Select custid, empid
FROM Sales.Orders
WHERE '20080201' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101');

--3: Queries Sales.Orders to return all customer and employee pairs that 
--	had order activity in Jan. 2008 and in Feb. 2008
USE TSQL2012;

Select custid, empid
FROM Sales.Orders
WHERE '20080101' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101')
INTERSECT
Select custid, empid
FROM Sales.Orders
WHERE '20080201' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101');

--4: Queries Sales.Orders to return all customer and employee pairs that 
--	had order activity in Jan. 2008 and in Feb. 2008 but not in 2007.
USE TSQL2012;

Select custid, empid
FROM Sales.Orders
WHERE '20080101' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101')
INTERSECT
Select custid, empid
FROM Sales.Orders
WHERE '20080201' = DATEADD(month,DATEDIFF(month,'20010101',orderdate),'20010101')
EXCEPT
Select custid, empid
FROM Sales.Orders
WHERE '20070101' = DATEADD(year,DATEDIFF(year,'20010101',orderdate),'20010101');

--5: Given a specific query add logic to guarantee that the rows from Employees
--	are returned in the output before the rows from suppliers and sort by country
--	region and city in each.
USE TSQL2012;

SELECT L.country, L.region, L.city
FROM (
	SELECT country, region, city, 1 AS n
	FROM HR.Employees
	UNION ALL
	SELECT country, region, city, 2
	FROM Production.Suppliers ) AS L
ORDER BY L.n, L.country, L.region, L.city;



