USE AdventureWorks2012;

/*
Self-Joins

A self-join is a special type of query that joins a table back to itself.
Normally the EmployeeID would be a primary key column and the
ManagerID would be a foreign key pointing back to the same table. 
This would ensure that only an
existing EmployeeID could be added to the ManagerID column.

Here is the syntax for a self-join:
SELECT 
	<a.col1>
	,<b.col1>
FROM 
	<table1> AS a
	LEFT [OUTER] JOIN 
	<table1> AS b 
		ON a.<col1> = b.<col2>

The important thing to remember is that one table is used twice in the query. 
At least one of the table names must be aliased; it is not an option because 
you can’t have two tables with the same name in the query. 
You will have to qualify all the column names, so you may want to alias both table names to
save typing.
*/


/*
CROSS JOIN

This is actually the same as the Cartesian product. Use CROSS JOIN when you
intend to multiply two tables together—every row from one table matched 
to every row from another table.
*/
--SELECT 
--	p.ProductID, l.LocationID
--FROM 
--	Production.Product AS p
--	CROSS JOIN 
--	Production.Location AS l
--ORDER BY ProductID;


/*
FULL OUTER JOIN

FULL OUTER JOIN is similar to LEFT OUTER JOIN and RIGHT OUTER JOIN, but in this case, 
all the rows from each side of the join are returned. In other words, all rows from 
the left side of the join, even if there is
not a match, and all rows from the right side, 
even if there is not a match, show up in the results.
*/


/*
Adding a Table to the Left Side of a Left Join

The Sales.Territory table joins to the main table, the Sales.Customer table. Since you want to
make sure that all customers show up in the results, use LEFT OUTER JOIN to join this new table.
*/
--SELECT 
--	C.CustomerID
--	,SOH.SalesOrderID
--	,SOD.SalesOrderDetailID
--	,SOD.ProductID
--	,T.Name
--FROM 
--	Sales.Customer AS C
--	LEFT OUTER JOIN 
--	Sales.SalesOrderHeader AS SOH 
--		ON C.CustomerID = SOH.CustomerID
--	LEFT OUTER JOIN 
--	Sales.SalesOrderDetail AS SOD 
--		ON SOH.SalesOrderID = SOD.SalesOrderID
--	LEFT OUTER JOIN 
--	Sales.SalesTerritory AS T 
--		ON C.TerritoryID = T.TerritoryID
--WHERE 
--	C.CustomerID IN (11028,11029,1,2,3,4);



/*
Adding a Table to the Right Side of a Left Join

If you must join another table to the Sales.SalesOrderHeader table, you must use LEFT OUTER JOIN 
because you can’t join on the NULL values.
*/

--SELECT 
--	C.CustomerID 
--	,SOH.SalesOrderID
--	,SOD.SalesOrderDetailID
--	,SOD.ProductID
--FROM 
--	Sales.Customer AS C 
--	LEFT OUTER JOIN 
--	Sales.SalesOrderHeader AS SOH 
--		ON C.CustomerID = SOH.CustomerID 
--	LEFT OUTER JOIN 
--	Sales.SalesOrderDetail AS SOD 
--		ON SOH.SalesOrderID = SOD.SalesOrderID
--WHERE 
--	C.CustomerID IN (11028,11029,1,2,3,4)
--;

/*
Podejscie alternatywne problemu - podlaczamy z prawej strony tabele POZYCJE, bed¹c¹
wynikiem podzapytania. W ten sposób mo¿emy po³¹czyc dwie pierwsze tabele - Customer i SalesOrderHeader -
z³¹czeniem zewnêtrznym, a tebale drug¹ i trzeci¹ - SalesOrderHeader i SalesOrderDetail - 
z³aczeniem wewnêtrznym. To drugie wewnetrzne z³¹czenie gwarantuje, ¿e wynikiem tego podzapytania
sa nag³ówki tych zamówieñ, które maj¹ jakiekolwiek pozycje towarowe. 
*/

--SELECT 
--	C.CustomerID
--	,POZYCJE.SalesOrderID
--	,POZYCJE.SalesOrderDetailID
--	,POZYCJE.ProductID  
--FROM 
--	Sales.Customer AS C 
--	LEFT OUTER JOIN 
--	(
--		select 
--			SOH.CustomerID, SOH.SalesOrderID
--			,SOD.SalesOrderDetailID, SOD.ProductID
--		from
--			Sales.SalesOrderHeader AS SOH 
--			INNER JOIN 
--			Sales.SalesOrderDetail AS SOD 
--				ON SOH.SalesOrderID = SOD.SalesOrderID
--	) AS 
--	POZYCJE
--		ON C.CustomerID = POZYCJE.CustomerID
--WHERE 
--	C.CustomerID IN (11028,11029,1,2,3,4)
--;



/*
Sometimes it’s useful to find all the rows in one table that don’t have corresponding rows in another
table. For example, you may want to find all the customers who have never placed an order. Since the
columns from the nonmatching rows contain NULL values, you can use OUTER JOIN to find rows with no
match by checking for NULL.
*/

--SELECT 
--	COUNT(c.CustomerID) AS 'Ilu Klientów Bez Zamówien'
--	--c.CustomerID
--	--,s.SalesOrderID
--	--,s.OrderDate
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN Sales.SalesOrderHeader AS s 
--		ON c.CustomerID = s.CustomerID
--WHERE 
--	s.SalesOrderID IS NULL
--GROUP BY 
--	s.SalesOrderID 
--	,s.OrderDate
--;

/*
Figure below shows how the Sales.Customer and Sales.SalesOrderHeader tables connect when using LEFT
OUTER JOIN so that all customers show up in the results even if they have not placed any orders.
*/

--SELECT 
--	c.CustomerID, s.SalesOrderID, s.OrderDate
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN Sales.SalesOrderHeader AS s 
--		ON c.CustomerID = s.CustomerID
--WHERE 
--	c.CustomerID IN (11028,11029,1,2,3,4)
--;

--SELECT 
--	 c.CustomerID 
--	,s.SalesOrderID
--	,s.OrderDate
--FROM 
--	Sales.SalesOrderHeader AS s
--	RIGHT OUTER JOIN Sales.Customer AS c 
--		ON c.CustomerID = s.CustomerID
--WHERE 
--	c.CustomerID IN (11028,11029,1,2,3,4)
--;


