--Chapter 7 Exercises	

--Setup: 
	--Create dbo.Orders
	USE TSQL2012;

	IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;

	CREATE TABLE dbo.Orders
	(
		orderid		INT			NOT NULL,
		orderdate	DATE		NOT NULL,
		empid		INT			NOT NULL,
		custid		VARCHAR(5)	NOT NULL,
		qty			INT			NOT NULL,
		CONSTRAINT PK_Orders	
			PRIMARY KEY(orderid)
	);

	INSERT INTO dbo.Orders(orderid, orderdate, empid, custid, qty)
	VALUES
		(30001, '20070802', 3, 'A', 10),
		(10001, '20071224', 2, 'A', 12),
		(10005, '20071224', 1, 'B', 20),
		(40001, '20080109', 2, 'A', 40),
		(10006, '20080118', 1, 'C', 14),
		(20001, '20080212', 2, 'B', 12),
		(40005, '20090212', 3, 'A', 10),
		(20002, '20090216', 1, 'C', 20),
		(30003, '20090418', 2, 'B', 15),
		(30004, '20070418', 3, 'C', 22),
		(30007, '20090907', 3, 'D', 30);
	-- Test Insertion
	SELECT * FROM dbo.Orders;

--1: Queries dbo.Orders to compute for each customer both a rank and a
--	dense rank, partitioned by custid and  ordered by qty
USE TSQL2012

SELECT custid, orderid, qty, RANK() OVER(PARTITION BY custid ORDER BY qty) AS rnk,
		DENSE_RANK() OVER(PARTITION BY custid ORDER BY qty) AS drnk
FROM dbo.Orders;

--2: Queries dbo.Orders to compute for each customer order both the difference
--	between the current order quanitity and the previous order quantity and the
--	difference between the current order quantity and the customer's next order
--	quantity
USE TSQL2012;

SELECT custid, orderid, qty, qty - LAG(qty,1) OVER(PARTITION BY custid ORDER BY orderdate)
	AS diffprev, qty - LEAD(qty, 1) OVER(PARTITION BY custid ORDER BY orderdate) AS diffnext
FROM dbo.Orders;

--3: Queries dbo.Orders to return a row for each employee, column for each order
--	year, and the count of orders for each employee and order year.
USE TSQL2012;

SELECT empid, cnt2007, cnt2008, cnt2009
FROM (SELECT empid, CASE YEAR(orderdate) WHEN '2007' THEN 'cnt2007' 
		WHEN '2008' THEN 'cnt2008' WHEN '2009' THEN 'cnt2009' ELSE NULL END AS orderyear, orderid
		FROM dbo.Orders
	) AS O 
	PIVOT(COUNT(orderid) FOR orderyear IN(cnt2007, cnt2008, cnt2009)) AS P;

--4: Creates and Queries EmpYearOrders table to unpivot data, returning a row for
--	each employee and order year with the number of orders. Excludes rows in which
--	the number of orders is 0.
USE TSQL2012;

	--Given Code
IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;

CREATE TABLE dbo.EmpYearOrders
(
	empid INT NOT NULL
		CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
	cnt2007 INT NULL,
	cnt2008 INT NULL,
	cnt2009 INT NULL
);

INSERT INTO dbo.EmpYearOrders(empid, cnt2007, cnt2008, cnt2009)
	SELECT empid, [2007] AS cnt2007, [2008] AS cnt2008, [2009] AS cnt2009
	FROM (SELECT empid, YEAR(orderdate) AS orderyear
			FROM dbo.Orders) AS D
		PIVOT(COUNT(orderyear) FOR orderyear IN([2007], [2008], [2009])) AS P;

SELECT * FROM dbo.EmpYearOrders;

	-- My code
SELECT empid, orderyear, qty
FROM (SELECT empid, cnt2007 AS [2007], cnt2008 AS [2008], cnt2009 AS [2009]
		FROM dbo.EmpYearOrders) AS D
	UNPIVOT(qty FOR orderyear IN([2007], [2008], [2009])) AS U
WHERE qty <> 0;

--5: Queries dbo.Orders table to return the total quantities for each:
--	(employee, customer, and order year), (employee and orderyear), and 
--	(customer and orderyear).  Includes a column that identifies which 
--	grouping set each row belongs to.
USE TSQL2012;

SELECT 
	GROUPING_ID(empid,custid,YEAR(orderdate)) AS groupingset,
	empid, custid, YEAR(orderdate) AS orderyear, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY
	GROUPING SETS
	(
	 (empid,custid,YEAR(orderdate)),
	 (empid, YEAR(orderdate)),
	 (custid, YEAR(orderdate))
	);

--cleanup
USE TSQL2012;

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;
