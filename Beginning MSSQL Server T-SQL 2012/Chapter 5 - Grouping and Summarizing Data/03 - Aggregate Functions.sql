USE AdventureWorks2012;

/*Aggregate Functions*/

--1
--SELECT 
--	COUNT(*) AS CountOfRows,
--	MAX(TotalDue) AS MaxTotal,
--	MIN(TotalDue) AS MinTotal,
--	SUM(TotalDue) AS SumOfTotal,
--	AVG(TotalDue) AS AvgTotal
--FROM 
--	Sales.SalesOrderHeader
--;

----2
--SELECT 
--	MIN(Name) AS MinName,
--	MAX(Name) AS MaxName,
--	MIN(SellStartDate) AS MinSellStartDate
--FROM 
--	Production.Product
--;

/*
The first expression in Query 1, CountOfRows, uses an asterisk (*) 
to count all the rows in the table. The other expressions perform
calculations on the TotalDue column. 

Query 2 demonstrates using the MIN and MAX functions on string
and date columns. In these examples, the SELECT clause lists only aggregate expressions.
*/

/*
Grouping on Columns

When nonaggregated columns are in the
SELECT list, you must add the GROUP BY clause and include all the nonaggregated columns.
*/

----1
--SELECT 
--	CustomerID,SUM(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--;
----2
--SELECT 
--	TerritoryID,
--	AVG(TotalDue) AS AveragePerTerritory
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	TerritoryID
--;

/*
Query 1 displays every customer with orders along
with the sum of the TotalDue for each customer. The results are grouped by the CustomerID, and the
sum is applied over each group of rows.

Query 2 returns the average of the TotalDue values grouped by
the TerritoryID. In each case, the nonaggregated column in the SELECT list must appear in the GROUP
BY clause.

If you don’t want to group on a column, don’t
list it in the SELECT list.
*/

/*
Grouping on Expressions

It is possible to group on expressions. In that case you must include the exact expression 
in the GROUP BY clause. 
*/

----1
--SELECT 
--	Count(*) AS CountOfOrders
--	,Year(OrderDate) AS YearOfOrder
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY
--	OrderDate
--;

----2
--SELECT 
--	Count(*) AS CountOfOrders
--	,Year(OrderDate) AS OrderYear
--FROM
--	Sales.SalesOrderHeader
--GROUP BY
--	Year(OrderDate)
--;

/*
Notice that query 1 will run, but instead of returning one row
per year, the query returns multiple rows with unexpected values. Because the GROUP BY clause contains
OrderDate, the grouping is on OrderDate. The CountOfOrders expression is the count by OrderDate, not
OrderYear. The expression in the SELECT list just changes how the data displays; it doesn’t affect the
calculations.

Query 2 fixes this problem by including the exact expression from the SELECT list in the GROUP BY
clause. Query 2 returns only one row per year, and CountOfOrders is correctly calculated.
*/

/*
The ORDER BY Clause

If a nonaggregate column appears in the ORDER BY clause, it must also appear in the
GROUP BY clause, just like the SELECT list.
*/

----1
--SELECT 
--	CustomerID 
--	,Sum(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--ORDER BY
--	CustomerID
--;

----2
--SELECT 
--	TerritoryID
--	,AVG(TotalDue) AS AveragePerTerritory
--FROM
--	Sales.SalesOrderHeader
--GROUP BY
--	TerritoryID
--ORDER BY
--	TerritoryID
--;

----3
--SELECT 
--	CustomerID,
--	SUM(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--ORDER BY 
--	SUM(TotalDue) DESC
--;

/*
The WHERE Clause

The WHERE clause in an aggregate query may contain anything allowed in the WHERE clause in any other
query type. It may not, however, contain an aggregate expression. 

You use the WHERE clause to eliminate rows before the groupings and aggregates are applied.
*/

--SELECT 
--	CustomerID
--	--TerritoryID
--	,SUM(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--WHERE 
--	TerritoryID in (5,6)
--GROUP BY 
--	CustomerID
--	--TerritoryID
--;

/*
The query
eliminates the rows before the grouping is applied.
*/

/*
The HAVING clause

Use the HAVING clause to eliminate rows based on aggregate expressions.

The HAVING clause may contain aggregate expressions that do or do not pappear in the SELECT list.

When you include non aggregate columns in the HAVING clause, these columns must appear in the GROUP BY
clause. Behind the scenes, however, the database engine may move the criteria to the WHERE clause,
because it is more efficient to eliminate rows first. 
*/

----1
--SELECT 
--	CustomerID
--	,SUM(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--HAVING 
--	SUM(TotalDue) > 5000
--;

----2
--SELECT 
--	CustomerID
--	,SUM(TotalDue) AS TotalPerCustomer
--	--,COUNT(*) AS Cnt
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--HAVING 
--	--COUNT(*) = 10 
--	--AND 
--	SUM(TotalDue) > 5000
--;

----3
--SELECT 
--	CustomerID
--	,SUM(TotalDue) AS TotalPerCustomer
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID
--HAVING 
--	CustomerID > 27858
--;

/*
Query 2
demonstrates how an aggregate expression not included in the SELECT list may be used (in this case, the
count of the rows) in the HAVING clause. 
Query 3 
contains a nonaggregated column, CustomerID, in the
HAVING clause, but it is a column in the GROUP BY clause. In this case, you could have moved the criteria to
the WHERE clause instead and received the same results.
*/

/*
Developers often struggle when trying to figure out whether the filter criteria belongs in the WHERE
clause or in the HAVING clause. 
Here’s a tip: you must know the order in which the database engine
processes the clauses. First, review the order in which you write the clauses in an aggregate query.
• SELECT
• FROM
• WHERE
• GROUP BY
• HAVING
• ORDER BY

The database engine processes the WHERE clause before the groupings and aggregates are applied.
Here is the order that the database engine actually processes the query:
• FROM
• WHERE
• GROUP BY
• HAVING
• ORDER BY
• SELECT

The database engine processes the WHERE clause before it processes the groupings and aggregates.
Use the WHERE clause to completely eliminate rows from the query.

The database engine processes the HAVING clause
after it processes the groupings and aggregates. Use the HAVING clause to eliminate rows based on
aggregate expressions or groupings. For example, use the HAVING clause to remove the customers who
have placed fewer than ten orders.
*/

/*
Using DISTINCT vs. GROUP BY
*/

----1
--SELECT 
--	DISTINCT SalesOrderID
--FROM 
--	Sales.SalesOrderDetail
--;

----2
--SELECT 
--	SalesOrderID
--FROM 
--	Sales.SalesOrderDetail
--GROUP BY 
--	SalesOrderID
--;

/*
Queries 1 and 2 return identical results. Even though query 2 contains no aggregate
expressions, it is still an aggregate query because GROUP BY has been added. By grouping on
SalesOrderID, only the unique values show up in the returned rows.
*/

/*
DISTINCT Within an Aggregate Expression

You may use DISTINCT within an aggregate functions to operate on unique values.
For example you could write a query that counts the number of unique values in a column.
*/

----1
--SELECT 
--	COUNT(*) AS CountOfRows
--	,COUNT(SalesPersonID) AS CountOfSalesPeople
--	,COUNT(DISTINCT SalesPersonID) AS CountOfUniqueSalesPeople
--FROM 
--	Sales.SalesOrderHeader
--;

----2
--SELECT 
--	SUM(TotalDue) AS TotalOfAllOrders
--	,SUM(Distinct TotalDue) AS TotalOfDistinctTotalDue
--FROM 
--	Sales.SalesOrderHeader
--;

/*
Query 1 
contains three aggregate expressions all using COUNT. 
The first one counts all rows in the table. T
he second expression counts the values in SalesPersonID.
The expression returns a much smaller value because the data contains many NULL
values, which are ignored by the aggregate function. 
Finally, the third expression returns the count of
unique SalesPersonID values by using the DISTINCT keyword.
Query 2 
demonstrates that DISTINCT works with other aggregate functions, not just COUNT. The
first expression returns the sum of TotalDue for all rows in the table. The second expression 
returns the sum of unique TotalDue values.
*/

--Excercise:
/*
Write a query using the Sales.SalesOrderHeader table that returns the count of
unique TerritoryID values per customer.
*/

--SELECT 
--	--[SalesOrderID]
--	--[OrderDate]
--	CustomerID
--	,TerritoryID
--	,Count(TerritoryID)
--	--,TerritoryID
--FROM 
--	Sales.SalesOrderHeader
--GROUP BY 
--	CustomerID,TerritoryID
--ORDER BY
--	CustomerID
--;

--SELECT 
--	--[SalesOrderID]
--	--[OrderDate]
--	CustomerID
--	,TerritoryID
--FROM 
--	Sales.SalesOrderHeader
--ORDER BY
--	CustomerID

/*
Aggregate Queries with More Than One Table
na stronie 180
*/

----1
--SELECT 
--	 C.CustomerID
--	,C.AccountNumber
--	,Count(*) AS CountOfOrders
--	,Sum(TotalDue) AS SumOfTotalDue
--FROM Sales.Customer AS C
--	INNER JOIN Sales.SalesOrderHeader AS S ON C.CustomerID = S.CustomerID 
--GROUP BY 
--	c.CustomerID, c.AccountNumber
--ORDER BY 
--	c.CustomerID
--;

----2
--SELECT 
--	c.CustomerID
--	,c.AccountNumber
--	,COUNT(*) AS CountOfOrders
--	,SUM(TotalDue) AS SumOfTotalDue
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
--GROUP BY 
--	c.CustomerID
--	,c.AccountNumber
--ORDER BY 
--	c.CustomerID
--;

----3
--SELECT 
--	c.CustomerID
--	,c.AccountNumber
--	,COUNT(s.SalesOrderID) AS CountOfOrders
--	,SUM(COALESCE(TotalDue,0)) AS SumOfTotalDue
--FROM 
--	Sales.Customer AS c
--	LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
--GROUP BY 
--	c.CustomerID, c.AccountNumber
--ORDER BY c.CustomerID
;

/*
Using an INNER JOIN, query 1 includes only the customers who have placed an order. By changing to
a LEFT OUTER JOIN, query 2 includes all customers but incorrectly returns a count of 1 for customers with
no orders and returns a NULL for the SumOfTotalDue when you probably want to see 0. Query 3 solves
the first problem by changing COUNT(*) to COUNT(s.SalesOrderID), which eliminates the NULL values and
correctly returns 0 for those customers who have not placed an order. Query 3 solves the second
problem by using COALESCE to change the NULL value to 0.
*/

/*
EXERCISE 5-5

1.  Write a query joining the Person.Person, Sales.Customer, and
	Sales.SalesOrderHeader tables to return a list of the customer names along with a
	count of the orders placed.
*/

--SELECT
--	c.CustomerID 
--	,c.PersonID
--	--,p.BusinessEntityID 
--	,p.FirstName 
--	,p.LastName
--	--,s.CustomerID
--	,Count(s.SalesOrderID) AS CountOfOrders
--	,Sum(COALESCE(s.TotalDue,0)) AS SumOfTotalDue   	
--FROM
--	Sales.Customer AS c
--	LEFT OUTER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID 
--	LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
--GROUP BY
--	c.CustomerID 
--	,c.PersonID
--	,p.FirstName 
--	,p.LastName
--ORDER BY 
--	c.CustomerID 
--;


/*
Isolating Aggregate Query Logic
str. 187
*/

/*
Using a Correlated Subquery in the WHERE Clause
*/

----1
--SELECT 
--	CustomerID
--	,SalesOrderID
--	,TotalDue
--FROM 
--	Sales.SalesOrderHeader AS soh
--WHERE 10 =
--	(	
--	SELECT 
--		COUNT(*)
--	FROM 
--		Sales.SalesOrderDetail
--	WHERE 
--		SalesOrderID = soh.SalesOrderID
--	)
--;

----2
--SELECT 
--	 CustomerID
--	,SalesOrderID
--	,TotalDue
--FROM 
--	Sales.SalesOrderHeader AS soh
--WHERE 
--	10000 < (SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = soh.CustomerID)
--;

----3
--SELECT 
--	CustomerID
--FROM 
--	Sales.Customer AS c
--WHERE 
--	CustomerID > (SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID)
--;

/*
Query 1 displays the Sales.SalesOrderHeader rows where there are ten matching detail rows. 
Inside the subquery’s WHERE clause, the SalesOrderID from the
subquery must match the SalesOrderID from the outer query. Usually when the same column name is
used, both must be qualified with the table name or alias. In this case, if the column is not qualified, it
refers to the tables in the subquery. Of course, if the subquery contains more than one table, you may
have to qualify the column name.

Query 2 displays rows from the Sales.SalesOrderHeader table but only for customers who have the
sum of TotalDue greater than 10,000. In this case, the CustomerID from the outer query must equal the
CustomerID from the subquery. 

Query 3 demonstrates how you can compare a column to the results of
the aggregate expression in the subquery. The query compares the CustomerID to the sum of the orders
and displays the customers who have ordered less than the CustomerID. Of course, this particular
example may not make sense from a business rules perspective, but it shows that you can compare a
column to the value of an aggregate function using a correlated subquery.
*/

/*
Inline Correlated Subqueries
*/

/*
You may also see correlated subqueries used within the SELECT list. It is not rocemmended
technique because if the query contains more than one correlated subquery, performance deteriorates
quickly.
*/

----1
--SELECT 
--	CustomerID,
--	(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS CountOfSales
--FROM 
--	Sales.Customer AS C
--ORDER BY 
--	CountOfSales DESC
--;

----2
--SELECT 
--	CustomerID,
--	(SELECT COUNT(*) AS CountOfSales FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS CountOfSales,
--	(SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS SumOfTotalDue,
--	(SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS AvgOfTotalDue
--FROM 
--	Sales.Customer AS C
--ORDER BY 
--	CountOfSales DESC
--;

/*
The subquery must produce only one row for each row of the outer query, and only one expression
may be returned from the subquery.
*/

/*
Query 1 demonstrates how an inline correlated subquery
returns one value per row. Notice the WHERE clause in the subquery. The CustomerID column must be
equal to the CustomerID in the outer query. The alias for the column must be added right after the
subquery definition, not the column definition.
Normally, when working with the same column name from two tables, both must be qualified.
Within the subquery, if the column is not qualified, the column is assumed to be from the table within
the subquery. If the subquery involves multiple tables, well, then you will probably have to qualify the
columns.

Query 2 contains three correlated subqueries because three values are required.
Although one correlated subquery doesn’t usually cause a problem, performance quickly deteriorates as
additional correlated subqueries are added to the query. Luckily, other techniques exist to get the same
results with better performance.
*/

/*
Using Derived Tables str. 191
*/

--SELECT 
--	 c.CustomerID
--	,CountOfSales
--	,SumOfTotalDue
--	,AvgOfTotalDue
--FROM 
--	Sales.Customer AS c 
--	INNER JOIN 
--	(
--		-- Derived Table
--		SELECT 
--			 CustomerID
--			,COUNT(*) AS CountOfSales
--			,SUM(TotalDue) AS SumOfTotalDue
--			,AVG(TotalDue) AS AvgOfTotalDue
--		FROM 
--			Sales.SalesOrderHeader
--		GROUP BY 
--			CustomerID
--	) AS s ON c.CustomerID = s.CustomerID
--;

/*
Besides the increase in performance, the derived table may return more than one row for each row
of the outer query, and multiple aggregates may be included. If you are working with some legacy SQL
Server 2000 systems, keep derived tables in mind for solving complicated T-SQL problems.
*/


/*
Common Table Expressions - CTE

The CTE is not stored as an object; it just makes the data
available during the query.
*/

--WITH S AS 
--(
--	SELECT
--		 CustomerID
--		,COUNT(*) AS CountOfSales 
--		,SUM(TotalDue) AS SumOfTotalDue
--		,AVG(TotalDue) AS AvgOfTotalDue
--	FROM
--		Sales.SalesOrderHeader
--	GROUP BY 
--		CustomerId
--)
--SELECT 
--	C.CustomerID
--	,S.AvgOfTotalDue
--	,S.CountOfSales
--	,S.SumOfTotalDue
--FROM
--	Sales.Customer AS C
--	INNER JOIN S ON C.CustomerID = S.CustomerID
--;


/*
Using Derived Tables and CTEs to Display Details 
str.193

Suppose you want to display several nonaggregated columns along with some aggregate expressions
that apply to the entire result set or to a larger grouping level. For example, you may need to display
several columns from the Sales.SalesOrderHeader table and calculate the percent of the TotalDue for
each sale compared to the TotalDue for all the customer’s sales. If you group by CustomerID, you can’t
include other nonaggregated columns from Sales.SalesOrderHeader unless you group by those columns.
To get around this, you can use a derived table or a CTE.
*/ 

----1
--SELECT 
--	c.CustomerID
--	,SalesOrderID
--	,TotalDue
--	,AvgOfTotalDue
--	,TotalDue/SumOfTotalDue * 100 AS SalePercent
--	,CountOfTransactions
--FROM 
--	Sales.SalesOrderHeader AS soh
--	INNER JOIN
--	(
--		SELECT 
--			 CustomerID
--			,Sum(TotalDue) AS SumOfTotalDue
--			,AVG(TotalDue) AS AvgOfTotalDue
--			,Count(CustomerID) AS CountOfTransactions
--		FROM
--			Sales.SalesOrderHeader
--		GROUP BY 
--			CustomerID
--	) AS c
--	ON soh.CustomerID = c.CustomerID
--ORDER BY 
--	c.CustomerID
--;

----2
--WITH c AS
--(
--	SELECT 
--		 CustomerID
--		,SUM(TotalDue) AS SumOfTotalDue
--		,AVG(TotalDue) AS AvgOfTotalDue
--		,Count(CustomerID) AS CountOfTransactions
--	FROM 
--		Sales.SalesOrderHeader
--	GROUP BY 
--		CustomerID
--)
--SELECT 
--	 c.CustomerID
--	,SalesOrderID
--	,TotalDue
--	,AvgOfTotalDue
--	,TotalDue/SumOfTotalDue * 100 AS SalePercent
--	,CountOfTransactions
--FROM 
--	Sales.SalesOrderHeader AS soh
--	INNER JOIN c ON soh.CustomerID = c.CustomerID
--ORDER BY 
--	c.CustomerID;

/*
Both queries return the same results and just use different
techniques. Inside the derived table or CTE, the data is grouped by CustomerID. The outer query
contains no grouping at all, and any columns can be used. Either of these techniques performs much
better than the equivalent query written with correlated subqueries.
*/


/*
The OVER Clause

The OVER clause provides a way to add aggregate values to a nonaggregate query. For example, you may
need to write a report that compares the total due of each order to the total due of the average order. The
query is not really an aggregate query, but one aggregate value from the entire results set or a grouping
level is required to perform the calculation.
*/

/*
SELECT CustomerID, SalesOrderID, TotalDue,
AVG(TotalDue) OVER(PARTITION BY CustomerID) AS AvgOfTotalDue,
SUM(TotalDue) OVER(PARTITION BY CustomerID) AS SumOfTOtalDue,
TotalDue/(SUM(TotalDue) OVER(PARTITION BY CustomerID)) * 100
AS SalePercentPerCustomer,
SUM(TotalDue) OVER() AS SalesOverAll
FROM Sales.SalesOrderHeader
ORDER BY CustomerID;
*/

--SELECT 
--	CustomerID
--	,SalesOrderID
--	,TotalDue
--	,AVG(TotalDue) OVER (PARTITION BY CustomerID) AS AvgOfTotalDue
--	,SUM(TotalDue) OVER (PARTITION BY CustomerID) AS SumOfTotalDue
--	,TotalDue/(SUM(TotalDue) OVER (PARTITION BY CustomerId)) * 100 AS SalePercentPerCustomer
--	,SUM(TotalDue) OVER () AS SalesOverAll
--FROM
--	Sales.SalesOrderHeader
--ORDER BY 
--	CustomerID
--;

/*
The PARTITION BY part of the expressions specifies the grouping
over which the aggregate is calculated. In this example, when partitioned by CustomerID, the function
calculates the value grouped over CustomerID. When no PARTITION BY is specified, as in the
SalesOverAll column, the aggregate is calculated over the entire result set.

You can also include a GROUP BY in the overall query. Be careful here because any columns that are
part of the OVER clause aggregate must be grouped. If you need to do this, you are probably better off
solving the problem with a CTE.
*/


/*
GROUPING SETS

GROUPING SETS, when added to an aggregate query, allows you to combine different grouping levels
within one statement. This is equivalent to combining multiple aggregate queries with UNION. For
example, suppose you want the data summarized by one column combined with the data summarized
by a different column. Just like MERGE, this feature is very valuable for loading data warehouses and data
marts. When using GROUPING SETS instead of UNION, you can see increased performance, especially when
the query includes a WHERE clause and the number of columns specified in the GROUPING SETS clause
increases.
*/

--1
--SELECT 
--	 NULL AS SalesOrderID
--	,SUM(UnitPrice) AS SumOfPrice
--	,ProductID
--FROM 
--	Sales.SalesOrderDetail
--WHERE 
--	SalesOrderID BETWEEN 44175 AND 44180
--GROUP BY ProductID

--UNION

--SELECT 
--	 SalesOrderID
--	,SUM(UnitPrice)
--	,NULL
--FROM 
--	Sales.SalesOrderDetail
--WHERE 
--	SalesOrderID BETWEEN 44175 AND 44180
--GROUP BY 
--	SalesOrderID
--;


----2
--SELECT 
--	SalesOrderID
--	,SUM(UnitPrice) AS SumOfPrice
--	,ProductID
--FROM 
--	Sales.SalesOrderDetail
--WHERE 
--	SalesOrderID BETWEEN 44175 AND 44180
--GROUP BY 
--	GROUPING SETS(SalesOrderID,ProductID)
--;

/*
Query 1 
is a UNION query that calculates the sum of the
UnitPrice. The first part of the query supplies a NULL value for SalesOrderID. That is because
SalesOrderID is just a placeholder. The query groups by ProductID, and SalesOrderID is not needed. The
second part of the query supplies a NULL value for ProductID. In this case, the query groups by
SalesOrderID, and ProductID is not needed. The UNION query combines the results. 

Query 2
demonstrates how to write the equivalent query using GROUPING SETS.
*/



/*
CUBE and ROLLUP

You can add subtotals to your aggregate queries by using CUBE or ROLLUP in the GROUP BY clause. CUBE and
ROLLUP are very similar, but there is a subtle difference. CUBE will give subtotals for every possible
combination of the grouping levels. ROLLUP will give subtotals for the hierarchy. For example, if you are
grouping by three columns, CUBE will provide subtotals for every grouping column. ROLLUP will provide
subtotals for the first two columns but not the last column in the GROUP BY list.
*/

----1
--SELECT 
--	 COUNT(*) AS CountOfRows
--	,Color
--	,ISNULL(Size,CASE WHEN GROUPING(Size) = 0 THEN 'UNK' ELSE 'ALL' END) AS Size
--FROM 
--	Production.Product
--GROUP BY 
--	CUBE(Color,Size)
--ORDER BY 
--	Size;

----2
--SELECT 
--	COUNT(*) AS CountOfRows
--	,Color
--	,ISNULL(Size,CASE WHEN GROUPING(Size) = 0 THEN 'UNK' ELSE 'ALL' END) AS Size
--FROM 
--	Production.Product
--GROUP BY 
--	ROLLUP(Color,Size)
--ORDER BY 
--	Size;


/*
Thinking About Performance

Inline correlated subqueries are very popular among developers. Unfortunately, the performance is poor
compared to other techniques, such as derived tables and CTEs. 
*/

--1
SELECT 
	CustomerID
	,(
		SELECT 
			COUNT(*) AS CountOfSales 
		FROM 
			Sales.SalesOrderHeader 
		WHERE CustomerID = c.CustomerID
	) AS CountOfSales
	,(
		SELECT 
			SUM(TotalDue)
		FROM 
			Sales.SalesOrderHeader
		WHERE 
			CustomerID = c.CustomerID
	) AS SumOfTotalDue
	,(
		SELECT 
			AVG(TotalDue)
		FROM 
			Sales.SalesOrderHeader
		WHERE 
			CustomerID = c.CustomerID
	) AS AvgOfTotalDue
FROM 
	Sales.Customer AS c
ORDER BY 
	CountOfSales DESC;

--2
WITH Totals AS
(
	SELECT 
		 COUNT(*) AS CountOfSales
		,SUM(TotalDue) AS SumOfTotalDue
		,AVG(TotalDue) AS AvgOfTotalDue
		,CustomerID
	FROM 
		Sales.SalesOrderHeader
	GROUP BY 
		CustomerID
)
SELECT 
	c.CustomerID
	,CountOfSales
	,SumOfTotalDue
	,AvgOfTotalDue
FROM 
	Totals
	LEFT OUTER JOIN Sales.Customer AS c 
		ON Totals.CustomerID = c.CustomerID
ORDER BY 
	CountOfSales DESC;

/*
The execution plan windows for above querries shows that query 1, with the correlated subqueries, 
takes up 62 percent of the resources. Query 2, with the CTE, produces the same results but requires 
only 38 percent of the resources.
*/

/*
SUMMARY

Keep the following rules in mind when writing an aggregate query:

• Any column not contained in an aggregate function in the SELECT list or ORDER BY
clause must be part of the GROUP BY clause.

• Once an aggregate function, the GROUP BY clause, or the HAVING clause appears in a
query, it is an aggregate query.

• Use the WHERE clause to filter out rows before the grouping and aggregates are
applied. The WHERE clause doesn’t allow aggregate functions.

• Use the HAVING clause to filter out rows using aggregate functions.

• Don’t include anything in the SELECT list or ORDER BY clause that you don’t want as
a grouping level.

• Use common table expressions or derived tables instead of correlated subqueries
to solve tricky aggregate query problems.

• To combine more than one grouping combination, use GROUPING SETS.

• Use CUBE and ROLLUP to produce subtotal rows.

• Remember that aggregate functions ignore NULL values except for COUNT(*).
*/

