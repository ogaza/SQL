
USE AdventureWorks2012;

/*
Using a Subquery in an IN List
*/

--SELECT 
--	CustomerID
--	,AccountNumber
--FROM 
--	Sales.Customer
--WHERE 
--	CustomerID IN (SELECT CustomerID FROM Sales.SalesOrderHeader)
--;

/*
This query returns a list of the customers who have placed an order. The difference
between this approach and joining these tables is that the columns from
the Sales.SalesOrderHeader table don’t show up in the results. 
Each customer displays only once in the results, not once for each order placed.
*/


/*
Using a Subquery and NOT IN

A subquery in the WHERE clause can also be used to find rows that don’t match the values from another
table by adding the NOT operator.
*/

--SELECT 
--	CustomerID, AccountNumber
--FROM 
--	Sales.Customer
--WHERE 
--	CustomerID NOT IN (SELECT CustomerID FROM Sales.SalesOrderHeader)
--;

/*
The querry above returns the customers who have not placed an order.
*/

/*
Using a Subquery Containing NULL with NOT IN

You will often get incorrect results if you don’t take NULL values into account.
If the subquery contains any NULL values, using NOT IN will incorrectly produce no rows. 
For example, the values returned by a subquery are NULL, 1, 2, and 3. 
The values from the outer query (1, 2, and 10) must each be
compared to that list. The database engine can tell that 10 is not 1, 2, or 3, but it can’t tell whether 
it is the same as NULL and the comparison returns no results at all.
*/

--1
--SELECT 
--	CurrencyRateID, FromCurrencyCode, ToCurrencyCode
--FROM 
--	Sales.CurrencyRate
--WHERE 
--	CurrencyRateID NOT IN (SELECT CurrencyRateID FROM Sales.SalesOrderHeader)
--;

----2
--SELECT 
--	CurrencyRateID, FromCurrencyCode, ToCurrencyCode
--FROM 
--	Sales.CurrencyRate
--WHERE 
--	CurrencyRateID NOT IN 
--		(SELECT CurrencyRateID FROM Sales.SalesOrderHeader WHERE CurrencyRateID IS NOT NULL)
--;

/*
Query 1 does not return any results because NULL values exist in the
values returned by the subquery. Since any value from CurrencyRateID compared to NULL returns
UNKNOWN, it is impossible to know whether any of the values meet the criteria. Query 2 corrects the
problem by adding a WHERE clause to the subquery that eliminates NULL values.
*/


/*
Writing UNION Queries

A UNION query combines two or more queries, and the results are returned in one
result set. Each individual query must contain
the same number of columns and be of compatible data types.

UNION ALL returns all rows, even if they are duplicates. Leaving out the keyword ALL eliminates the
duplicates. 

When using a UNION query, only one ORDER BY clause can be used, and it will be located at the
end of the statement.
*/

--SELECT 
--	BusinessEntityID AS ID
--FROM 
--	HumanResources.Employee

--UNION

--SELECT 
--	BusinessEntityID
--FROM 
--	Person.Person

--UNION

--SELECT 
--	SalesOrderID
--FROM 
--	Sales.SalesOrderHeader

--ORDER BY ID;

/*
Using Derived Tables

A derived table is a subquery that appears in the FROM clause. 

Actually, you may see derived tables with SQL Server 2005 and 2008 code, 
but starting with 2005, another option, Common Table Expressions(CTE), is available.

Derived tables allow developers to join to queries instead of tables.
*/

--SELECT 
--	c.CustomerID
--	,s.SalesOrderID
--FROM 
--	Sales.Customer AS c
--	INNER JOIN 
--	(
--		SELECT 
--			SalesOrderID, CustomerID 
--		FROM 
--			Sales.SalesOrderHeader
--	) 
--	AS s 
--		ON c.CustomerID = s.CustomerID
--;

/*
Keep in mind three rules when using derived tables. 

First, any columns that will be needed outside the derived table must be included in its SELECT list. 
Even though only SalesOrderID appears in the main SELECT list, CustomerID is required for joining. 

Second, the derived table requires an alias. Use the alias
to refer to columns from the derived table in the outer query. 

Finally, the derived table may contain
multiple tables, a WHERE clause, and even another derived table.
*/

/*
Using CTE - Common Table Expressions

Microsoft introduced the common table expression (CTE) feature with SQL Server 2005.

When writing a CTE, you define one or more queries up front, which you can then immediately use. 

For simple problems, there is no advantage over derived
tables, but this technique will come in handy when solving more advanced problems. 
*/

--WITH orders AS 
--(
--	SELECT 
--		SalesOrderID
--		,CustomerID
--	FROM 
--		Sales.SalesOrderHeader
--)

--SELECT 
--	c.CustomerID, 
--	orders.SalesOrderID
--FROM 
--	Sales.Customer AS c
--	INNER JOIN orders ON c.CustomerID = orders.CustomerID
--;

/*
The CTE begins with the word WITH. Because WITH is a keyword in several T-SQL commands, 
it must be either the first word in the batch or proceeded by a semicolon.
*/

----1
--SELECT 
--	c.CustomerID, s.SalesOrderID, s.OrderDate
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN 
--	Sales.SalesOrderHeader AS s 
--		ON c.CustomerID = s.CustomerID
--WHERE 
--	s.OrderDate = '2005/07/01'
--ORDER BY
--	c.CustomerID
--;

------2
--WITH orders AS 
--(
--	SELECT 
--		SalesOrderID, CustomerID, OrderDate
--	FROM 
--		Sales.SalesOrderHeader
--	WHERE 
--		OrderDate = '2005/07/01'
--)
--SELECT 
--	c.CustomerID, orders.SalesOrderID, orders.OrderDate
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN 
--	orders 
--		ON c.CustomerID = orders.CustomerID
--ORDER BY 
--	orders.OrderDate DESC
--;

/*
Query 1 returns only the 43 rows with the specified order
date. The nonmatching rows dropped out of the query because of the NULLs and values other than
2005/07/01 in the OrderDate column.

If you want to show all customers even if there is not an order placed on the specified date, 
then by adding the WHERE clause to the CTE instead, the NULL values and
other OrderDate values do not cause any problems, and the correct results are returned.
*/
