/* Using DELETE (p. 218) */

Use AdventureWorks2012;

/*
Copies of the existing tables
*/ 

---------------------------------------------------------------------
-- [dbo].[demoProduct]
---------------------------------------------------------------------

--If exists(
--	select 
--		* 
--	from 
--		sys.objects 
--	where 
--		object_id = OBJECT_ID(N'[dbo].[demoProduct]')
--		and type in (N'U')
--)
--	DROP TABLE [dbo].[demoProduct];

-- Select * into [dbo].[demoProduct] from Production.Product;

---------------------------------------------------------------------
-- [dbo].[demoCustomer]
---------------------------------------------------------------------

--IF EXISTS (
--	SELECT * FROM sys.objects
--	WHERE 
--		object_id = OBJECT_ID(N'[dbo].[demoCustomer]')
--		AND type in (N'U')
--	)	
--	DROP TABLE [dbo].[demoCustomer];

--GO

--SELECT * INTO dbo.demoCustomer FROM Sales.Customer;


---------------------------------------------------------------------
-- [dbo].[demoAddress]
---------------------------------------------------------------------

--IF EXISTS (
--	SELECT * FROM sys.objects
--	WHERE 
--		object_id = OBJECT_ID(N'[dbo].[demoAddress]')
--		AND type in (N'U')
--	)

--DROP TABLE [dbo].[demoAddress];
--GO

--SELECT 
--	* 
--INTO 
--	dbo.demoAddress 
--FROM 
--	Person.Address;

---------------------------------------------------------------------
-- [dbo].[demoSalesOrderHeader]
---------------------------------------------------------------------

--IF EXISTS (
--	SELECT 
--		* 
--	FROM 
--		sys.objects
--	WHERE 
--		object_id = OBJECT_ID(N'[dbo].[demoSalesOrderHeader]')
--		AND type in (N'U')
--	)
--	DROP TABLE [dbo].[demoSalesOrderHeader];

--GO
--SELECT * INTO dbo.demoSalesOrderHeader FROM Sales.SalesOrderHeader;

---------------------------------------------------------------------
-- [dbo].[demoSalesOrderDetail]
---------------------------------------------------------------------

--IF EXISTS (
--	SELECT * FROM sys.objects
--	WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderDetail]')
--	AND type in (N'U')
--	)
--	DROP TABLE [dbo].[demoSalesOrderDetail];

--GO
--SELECT * INTO dbo.demoSalesOrderDetail FROM Sales.SalesOrderDetail;

---------------------------------------------------------------------
-- DELETING
---------------------------------------------------------------------

/*
Running a SELECT statement before deleting data is a
good idea and enables you to test your WHERE clause. 
Make sure you know which rows will be deleted before 
you delete them.
*/

--GO
----1
--SELECT CustomerID
--FROM dbo.demoCustomer;

----2
--DELETE dbo.demoCustomer;

----3
--SELECT CustomerID
--FROM dbo.demoCustomer;

----4
--SELECT ProductID
--FROM dbo.demoProduct
--WHERE ProductID > 900;

----5
--DELETE dbo.demoProduct
--WHERE ProductID > 900;

----6
--SELECT ProductID
--FROM dbo.demoProduct
--WHERE ProductID > 900;

/*
Deleting from a Table Using a Join or a Subquery (p. 221)
*/