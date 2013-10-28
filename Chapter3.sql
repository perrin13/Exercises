-- Chapter 3 Excercises

--1.1: Queries HR.Employees and dbo.Nums to generate five copies of each employee row
USE TSQL2012;

SELECT E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E
	INNER JOIN dbo.Nums AS N
	 ON N.n < 6;

--1.2: Queries HR.Employees and dbo.Nums to generate five copies of each employee row
USE TSQL2012;

SELECT E.empid, CAST(DATEADD(day, N.n, '20090611') AS DATETIME)
FROM HR.Employees AS E
	JOIN dbo.Nums AS N
	 ON N.n < 6;

--2: Queries Sales.Customers, Sales.Orders, and Sales.OrderDetails in order to return the toatl number of orders and quantities 
--		for each customer from the United States.
USE TSQL2012;

SELECT C.custid, COUNT(DISTINCT OD.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C LEFT JOIN 
	(
	 Sales.Orders AS O JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
	) ON C.custid = O.custid
WHERE C.country = N'USA'
GROUP BY C.custid;

--3: Queries Sales.Customers and Sales.Orders to return customers and their orders
USE TSQL2012;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C 
	LEFT JOIN Sales.Orders AS O
	 ON C.custid = O.custid;

--4:  Queries Sales.Customers and Sales.Orders to return customers who placed no orders
USE TSQL2012;

SELECT C.custid, C.companyname
FROM Sales.Customers AS C 
	LEFT JOIN Sales.Orders AS O
	 ON C.custid = O.custid
WHERE O.orderid IS NULL;

--5: Queries Sales.Customers and Sales.Orders to return customers along with their orders if 
--	those orders were placed on February 12, 2007 (Does not return customers who placed no
--	orders on that date)
USE TSQL2012;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C 
	JOIN Sales.Orders AS O
	 ON C.custid = O.custid
WHERE O.orderdate = '20070212';

--6: Queries Sales.Customers and Sales.Orders to return customers along with their orders if 
--	those orders were placed on February 12, 2007 (Returns only the cust id and company name  
--	of customers who placed no orders on that date)
USE TSQL2012;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C 
	LEFT JOIN Sales.Orders AS O
	 ON C.custid = O.custid AND O.orderdate = '20070212';

--7: Queries Sales.Customers and Sales.Orders to return all customers with a Yes/No depending on whether
--	the customer placed an order on February 12, 2007 or not.
USE TSQL2012;

SELECT C.custid, C.companyname, 
	CASE
		WHEN O.orderid IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS HasOrderOn20070212
FROM Sales.Customers AS C 
	LEFT JOIN Sales.Orders AS O
	 ON C.custid = O.custid AND O.orderdate = '20070212'
