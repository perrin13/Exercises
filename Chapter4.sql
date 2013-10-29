-- Chapter 4 Exercises

--1: Queries Sales.Orders to return all orders placed on the last day of activity found.
USE TSQL2012;

SELECT O1.orderid, O1.orderdate, O1.custid, O1.empid
FROM Sales.Orders AS O1
WHERE O1.orderdate
	= (SELECT MAX(O2.orderdate)
		FROM Sales.Orders AS O2);

--2: Queries Sales.Orders in order to return all orders placed by customer(s) who
--	placed the highest number of orders
USE TSQL2012;

SELECT O1.custid, O1.orderid, O1.orderdate, O1.empid
FROM Sales.Orders AS O1
WHERE O1.custid IN(
	SELECT O2.custid
	FROM Sales.Orders AS O2
	GROUP BY O2.custid
	HAVING NOT EXISTS(
		SELECT O3.custid
		FROM Sales.Orders AS O3
		GROUP BY O3.custid 
		HAVING COUNT(O3.orderid) > COUNT(O2.orderid) ));

--3: Queries HR.Employees and Sales.Orders to return employees that did not place
--	orders on or after May 1, 2008
USE TSQL2012;

SELECT E.empid, E.firstname AS FirstName, E.lastname
FROM HR.Employees AS E
WHERE NOT EXISTS( 
	SELECT *
	FROM Sales.Orders AS O
	WHERE E.empid = O.empid AND
		O.orderdate >= '20080501');

--4: Queries Sales.Customers and HR.Employees to return countries where there
--	are customers but not employees
USE TSQL2012;

SELECT country
FROM Sales.Customers
WHERE country NOT IN(
	SELECT country
	FROM HR.Employees 
) 
GROUP BY country; 

--5: Queries Sales.Orders to return all orders each customer placed on their 
--	last day of activity
USE TSQL2012;

SELECT O1.custid, O1.orderid, O1.orderdate, O1.empid
FROM Sales.Orders AS O1
WHERE O1.orderdate  IN(
	SELECT TOP(1) WITH TIES O2.orderdate
	FROM Sales.Orders AS O2
	WHERE O2.custid = O1.custid
	ORDER BY O2.orderdate DESC
)
ORDER BY O1.custid;

--6: Queries Sales.Customers and Sales.Orders in order to return customers who
--	placed orders in 2007 but not in 2008
USE TSQL2012

SELECT C.custid, C.companyname
FROM Sales.Customers AS C
WHERE C.custid NOT IN(
	SELECT custid
	FROM Sales.Orders
	WHERE '2008' IN(YEAR(orderdate))
) AND C.custid IN(
	SELECT custid
	FROM Sales.Orders
	WHERE '2007' IN(YEAR(orderdate)) 
);
	
--7: Queries Sales.Customers, Sales.Orders, and Sales.OrderDetails to return
--	customers who ordered product 12
USE TSQL2012;

SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN(
	SELECT custid
	FROM Sales.Orders
	WHERE orderid IN(
		SELECT orderid
		FROM Sales.OrderDetails
		WHERE productid = '12'
	)
);

--8: Queries Sales.CustOrders to calculate the running-total quantity for 
--	each customer and month.
USE TSQL2012;

SELECT C1.custid, C1.ordermonth, C1.qty, 
	(
	 SELECT SUM(qty)
	 FROM Sales.CustOrders AS C2
	 WHERE C1.custid = C2.custid AND
		C2.ordermonth <= C1.ordermonth
	) AS runqty
FROM Sales.Custorders AS C1
ORDER BY C1.custid, C1.ordermonth;
	  




