-- Chapter 5 Exercises

--1.1: Queries Sales.Orders to return the maximum value in the order column
--	for each employee.
USE TSQL2012;

SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid;

--1.2: Queries Sales.Orders to return the last order each employee has been
--	associated with.
USE TSQL2012;

SELECT O.empid, O.orderdate, O.orderid, O.custid
FROM Sales.Orders AS O 
	JOIN(SELECT empid, MAX(orderdate) AS maxorderdate
		FROM Sales.Orders
		GROUP BY empid) AS D
	ON O.empid = D.empid AND O.orderdate = D.maxorderdate;

--2.1:  Queries Sales.Orders to calculate a row number for each order based on
--	orderdate, orderid ordering
USE TSQL2012;

SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY 
	orderdate,orderid) AS rownum
FROM Sales.Orders

--2.2: Queries Sales.Orders to return the 11-20 orders placed as defined in 2.1
USE TSQL2012;

WITH RowOrders AS
(
	SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY 
		orderdate,orderid) AS rownum
	FROM Sales.Orders
)
SELECT orderid, orderdate, custid, empid, rownum
FROM RowOrders
ORDER BY rownum
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY; 


--3: Queries Hr.Employees to return the management chain leading to Zoya
--	Dolgopyatova
USE TSQL2012;

WITH MngCTE AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT C.empid, C.mgrid, C.firstname, C.lastname
	FROM MngCTE AS P
		JOIN HR.Employees AS C
		ON C.empid = P.mgrid
)
SELECT empid, mgrid, firstname, lastname
FROM MngCTE;

--4.1: Creates a view that uses Sales.Orders and Sales.OrderDetails to 
--	return the total quantity for each employee and year
USE TSQL2012;

IF OBJECT_ID('Sales.VEmpOrders') IS NOT NULL
	DROP VIEW Sales.VEmpOrders
GO
	CREATE VIEW Sales.VEmpOrders WITH SCHEMABINDING
	AS

	SELECT empid, YEAR(orderdate) AS orderyear, SUM(D.qty) AS qty
	FROM Sales.Orders AS O 
		JOIN Sales.OrderDetails AS D
		ON O.orderid = D.orderid 
	GROUP BY YEAR(orderdate), empid
GO

--4.2: Queries preconstructed view Sales.VEmpOrders to return the running
--	total quantity for each employee and year.
USE TSQL2012;

SELECT V1.empid, V1.orderyear, V1.qty, SUM(V2.qty) AS runqty
FROM Sales.VEmpOrders AS V1 JOIN Sales.VEmpOrders AS V2
	ON V1.empid = V2.empid AND
		V1.orderyear >= V2.orderyear
GROUP BY V1.empid, V1.orderyear, V1.qty
ORDER BY V1.empid, V1.orderyear;     

--5.1: Creates an inline function that queries Production.Products and 
--	accepts as inputs a supplier ID and a number of products.  Returns 
--	the n most expensive products.
USE TSQL2012;

IF OBJECT_ID('Production.TopProducts') IS NOT NULL
	DROP FUNCTION Production.TopProducts
GO
CREATE FUNCTION Production.TopProducst
	(@supid AS INT, @n AS INT) RETURNS TABLE
AS
RETURN
	SELECT TOP(@n) productid, productname, unitprice
	FROM Production.Products
	WHERE supplierid = @supid
	ORDER BY unitprice, productid
GO      

--5.2: Queries Production.Suppliers and uses inline function
--	Production.TopProduct in order to return the two most expensive
--	products from each supplier
USE TSQL2012;

IF OBJECT_ID('Production.TopProducts') IS NOT NULL
	DROP FUNCTION Production.TopProducts
GO
CREATE FUNCTION Production.TopProducts
	(@supid AS INT, @n AS INT) RETURNS TABLE
AS
RETURN
	SELECT TOP(@n) productid, productname, unitprice
	FROM Production.Products
	WHERE supplierid = @supid
	ORDER BY unitprice DESC, productid
GO  
SELECT S.supplierid, S.companyname, P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S CROSS APPLY Production.TopProducts(S.supplierid, 2) AS P;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    