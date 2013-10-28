-- Chapter 2 Exercises

-- 1:  Returns orders placed in June 2007 from the Sales.Orders table
USE TSQL2012;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE DATEADD(month, DATEDIFF(month, '20010101', orderdate), '20010101') = '20070601';

--2: Returns orders placed on the last day of the month from the Sales.Orders table
USE TSQL2012;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders 
WHERE orderdate = EOMONTH(orderdate);

--3: Returns employees from the HR.Employees table that returns employees with last name containing the letter a twice or more.
USE TSQL2012;

SELECT empid, firstname, lastname
FROM HR.Employees 
WHERE 2 = LEN(lastname) - LEN(REPLACE(lastname, 'a', ''));

--4: Returns orders from Sales.OrderDetails if total value is greater than 10,000 sorted by total value
USE TSQL2012;

SELECT orderid, SUM(qty*unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty*unitprice) > 10000
ORDER BY  totalvalue DESC, orderid;

--5: Returns the three shipped-to countries from Sales.Orders with the highest average freight in 2007
USE TSQL2012;

SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC, shipcountry
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


--6: Queries the Sales.Orders table to calculate row numbers for orders based on order date ordering for each customer seperately
USE TSQL2012;

SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum;

--7: Queries the HR.Employees table to return empid, firstname, lastname, title, and gender (if determinate)
USE TSQL2012;

SELECT empid, firstname, lastname, titleofcourtesy, 
  CASE titleofcourtesy 
   WHEN 'Mr.'	THEN 'Male'
   WHEN 'Ms.'	THEN 'Female'
   WHEN 'Mrs.'	THEN 'Female'
   ELSE 'Unknown'
  END AS gender
FROM HR.Employees;

--8: Queries Sales.Customers and for each customer returns the customer ID and region.  Rows are sorted 
-- -- in the output by region with NULL marks last
USE TSQL2012;

SELECT custid, region
FROM Sales.Customers 
ORDER BY 
	CASE 
	 WHEN region IS NULL THEN 2
	 ELSE 1
	END, region;

