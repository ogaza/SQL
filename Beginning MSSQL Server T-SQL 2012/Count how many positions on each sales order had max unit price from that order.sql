USE [AdventureWorks2008R2]

/*
Get unit prices from positions for each sales order
*/
SELECT 
	[SalesOrderID]
	,[SalesOrderDetailID]
	,[UnitPrice]
FROM 
	[Sales].[SalesOrderDetail]
ORDER BY
	[SalesOrderID], [SalesOrderDetailID]
;

/*
Get min and max unit prices for each sales order
*/
SELECT 
	SOD.[SalesOrderID]
	,MIN(SOD.[UnitPrice]) AS MinUnitPrice
	,MAX(SOD.[UnitPrice]) AS MaxUnitPrice
FROM 
	[Sales].[SalesOrderDetail] AS SOD
GROUP BY
	SOD.[SalesOrderID]
;

/*
Count how many positions on each sales order had max unit price from that order
*/
SELECT 
	SOD.[SalesOrderID]
	,COUNT(SOD.[SalesOrderDetailID]) as [Number Of Positions With Max Unit Price]
FROM
	[Sales].[SalesOrderDetail] SOD
	INNER JOIN(
		SELECT 
			[SalesOrderID], MAX([UnitPrice]) AS MaxUnitPrice 
		FROM 
			[Sales].[SalesOrderDetail] GROUP BY [SalesOrderID]
	) 
	MUP ON (SOD.[SalesOrderID] = MUP.[SalesOrderID] AND SOD.[UnitPrice] = MUP.MaxUnitPrice)
GROUP BY
	SOD.[SalesOrderID]
;
/*
The same as before, but alterbative approach
*/
SELECT 
	SOD.[SalesOrderID]
	,COUNT(SOD.[SalesOrderDetailID]) as [Number Of Positions With Max Unit Price]
FROM
	[Sales].[SalesOrderDetail] AS SOD
	,(SELECT [SalesOrderID], MAX([UnitPrice]) AS MaxUnitPrice FROM [Sales].[SalesOrderDetail] GROUP BY [SalesOrderID]) MUP
WHERE
	(SOD.[SalesOrderID] = MUP.[SalesOrderID] AND SOD.[UnitPrice] = MUP.MaxUnitPrice)
GROUP BY
	SOD.[SalesOrderID]
;