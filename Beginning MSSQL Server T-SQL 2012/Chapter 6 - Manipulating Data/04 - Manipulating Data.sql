/*
Manipulating Data
*/

USE AdventureWorks2012;

/*
Inserting New Rows

Run the following code to create a table that you will populate with data in this section:
*/

--GO
--IF OBJECT_ID('demoCustomer') IS NOT NULL 
--BEGIN
--	DROP TABLE demoCustomer;
--END;

--CREATE TABLE demoCustomer(
--	 CustomerID INT NOT NULL PRIMARY KEY
--	,FirstName NVARCHAR(50) NOT NULL
--	,MiddleName NVARCHAR(50) NULL
--	,LastName NVARCHAR(50) NOT NULL
-- );

/*
Adding One Row with Literal Values

To insert new rows, you will use the INSERT statement. The syntax of the INSERT statement,
which has two variations, is simple.
INSERT [INTO] <table1> [(<col1>,<col2>)] SELECT <value1>,<value2>;
INSERT [INTO] <table1> [(<col1>,<col2>)] VALUES (<value1>,<value2>);

The INTO keyword is optional
*/

--Adding One Row at a Time with Literal Values:

----1
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--VALUES 
--	(1,'Orlando','N.','Gee');
----parentheses surround the literal values in the statement

----2
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--SELECT 
--	3, 'Donna','F.','Cameras';

----3
/*
Although not specifying the column names will work some of the time, 
the best practice is to specify the columns. Not only does this help clarify the
code, it often, but not always, keeps the code from breaking if new nonrequired 
columns are added to the table later.
*/
--INSERT INTO 
--	dbo.demoCustomer
--VALUES 
--	(4,'Janet','M.','Gates');

----4
--INSERT INTO 
--	dbo.demoCustomer
--SELECT 
--	6,'Rosmarie','J.','Carroll';

----5
---- inserts NULL into the MiddleName column
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--VALUES 
--	(2,'Keith',NULL,'Harris');

----6
---- leaves MiddleName out of the statement(MiddleName column is optional.)
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, LastName)
--VALUES 
--	(5,'Lucy','Harrington');

----7 see the result
--SELECT 
--	CustomerID, FirstName, MiddleName, LastName
--FROM 
--	dbo.demoCustomer;

/*
Avoiding Common Insert Errors
*/

/*
some of the things that can go wrong when inserting data into tables.

To show all the
error messages for the listing, the word GO separates statements 3 and 4 into their own batches. In fact,
even the PRINT statement will not run if it is contained in the same batch as these statements.
*/
--GO
--PRINT '1';
--1
/*
a row with CustomerID 1 already exists in the table,
the INSERT statement violates the primary key constraint
*/
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--VALUES 
--	(1, 'Dominic','P.','Gash');

--PRINT '2';
--2
/*
violates the NOT NULL constraint on the FirstName column
*/
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, MiddleName, LastName)
--VALUES 
--	(10,'M.','Garza');

--GO
--PRINT '3';

--3
/*
Because we do not doesn’t specify the
column names, the database engine expects a value for each of the four columns in the table definition.
Since the statement supplies only three values, the statement fails.
*/
--GO
--INSERT INTO 
--	dbo.demoCustomer
--VALUES 
--	(11,'Katherine','Harding');

--GO
--PRINT '4';

--4
--GO
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, LastName)
--VALUES 
--	(11, 'Katherine', NULL,'Harding');

/*
The database engine doesn’t discover problems with statements 1 and 2 until the code runs. The
problems with statements 3 and 4 are compile errors that cause the entire batch to fail.
*/

--GO
--PRINT '5';

----5
--GO
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, LastName)
--VALUES 
--	('A','Katherine','Harding');

/*
Inserting Multiple Rows with One Statement
*/

----1 - the UNION query technique
--GO
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--SELECT 
--	7,'Dominic','P.','Gash'
--UNION
--SELECT 
--	10,'Kathleen','M.','Garza'
--UNION
--SELECT 
--	11, 'Katherine', NULL,' Harding';

--2 - demonstrates how to use the row constructor technique
/*
By using row constructors, you can specify multiple lists of values, separated by commas, in one VALUES clause.
*/
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--VALUES 
--	(12,'Johnny','A.','Capino'),
--	(16,'Christopher','R.','Beck'),
--	(18,'David','J.','Liu');

----3 see the result
--SELECT 
--	CustomerID, FirstName, MiddleName, LastName
--FROM 
--	dbo.demoCustomer
--WHERE 
--	CustomerID >= 7;

/*Inserting Rows from Another Table (p. 204)*/

-- using sql we can insert data from one table or query into another table

-- 1
-- inserts the rows from the Person.Person table where 
-- the BusinessEntityID is between 19 and 35.

--insert into 
--	dbo.demoCustomer (CustomerId, FirstName, MiddleName, LastName)
--Select
--	BusinessEntityId, FirstName, MiddleName, LastName
--From
--	Person.Person
--Where
--	BusinessEntityID Between 19 and 35;

---- 2
---- inserts the rows from a query that joins the Person.Person 
---- and Sales.SalesOrderHeader tables. 
--INSERT INTO 
--	dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
--SELECT DISTINCT 
--	c.BusinessEntityID, c.FirstName, c.MiddleName, c.LastName
--	FROM 
--		Person.Person AS c
--		INNER JOIN 
--		Sales.SalesOrderHeader AS s ON c.BusinessEntityID = s.SalesPersonID

---- 3
--SELECT CustomerID, FirstName, MiddleName, LastName
--FROM dbo.demoCustomer
--WHERE CustomerID > 18;

-- The SELECT parts of the statements are valid queries that can be run 
-- without the INSERT clauses.

/*Inserting Missing Rows (p. 206)*/

-- When inserting rows from one table to another we want to be sure
-- we dont break the promary key. In order to do this we can use 
-- OUTER JOIN, which enables us to find rows from source table that
-- do not exist in the target table.

-- 1
--INSERT INTO 
--	dbo.demoCustomer (CustomerId, FirstName, MiddleName, LastName)
--SELECT
--	c.BusinessEntityId, c.FirstName, c.MiddleName, c.LastName
--FROM
--	Person.Person AS c
--	LEFT OUTER JOIN dbo.demoCustomer AS targetTable ON c.BusinessEntityID = targetTable.CustomerId
--WHERE
--    -- check for NULL in the target table
--	targetTable.CustomerId IS NULL;

-- 2 
-- SELECT COUNT(CustomerId) AS CutomerCount FROM dbo.demoCustomer;


/* Creating and populating a table in one statement */

-- The SELECT INTO statement allows you to create a table and populate 
-- it with one statement. It can be used to create temporary tables, 
-- or work tables.

-- first check if the table already exist and drop it if it does
--IF EXISTS (
--	SELECT 
--		* 
--	FROM 
--		sys.objects
--	WHERE 
--		object_id = OBJECT_ID(N'[dbo].[demoCustomer]') 
--		AND type in (N'U'))
--DROP TABLE dbo.demoCustomer;

--1
-- lists the columns and an expression along with
-- the word INTO and the name of the table to create. 
-- The resulting table contains a column, FullName, that
-- the statement created with the expression. 

-- You can write a query that doesn't specify an
-- alias for the expression, but you must specify the alias 
-- for the expression when writing SELECT INTO
-- statements. 

-- The database engine uses the column and alias names when 
-- creating the new table.

-- The primary key from the source table will not be created
-- in the destinationa table

--SELECT 
--	BusinessEntityID, 
--	FirstName, 
--	MiddleName, 
--	LastName, 
--	FirstName + ISNULL(' ' + MiddleName,'') + ' ' + LastName AS FullName
--INTO 
--	-- name for the name table
--	dbo.demoCustomer
--FROM 
--	Person.Person;

--2
--SELECT 
--	BusinessEntityID, FirstName, MiddleName, LastName, FullName
--FROM 
--	dbo.demoCustomer;

-- Developers often use the SELECT INTO statement to create an empty 
-- table by adding 1=2 to the WHERE clause.

-- If you want to create and populate a work table, is often better to 
-- create the empty table first and then populating it with a regular 
-- INSERT statement when you are working with a large number of rows. 

-- SELECT INTO statement locks system tables that can cause problems 
-- for other connections. Using a CREATE TABLE first and then populating it 
-- locks the system tables only momentarily. 

-- Using the SELECT INTO syntax locks the tables until the 
-- entire statement completes.


/* Inserting Rows into Tables with Default Column Values (p.208) */

-- If the column definition specifies a default constraint, you can 
-- just leave that column out of the INSERT statement to automatically insert the default value

--IF EXISTS (
--	SELECT * 
--	FROM 
--		sys.objects 
--	WHERE 
--		object_id = OBJECT_ID(N'[dbo].[demoDefault]') 
--		AND type in (N'U')
--	)

--	DROP TABLE 
--		[dbo].[demoDefault]
--GO

--CREATE TABLE 
--	[dbo].[demoDefault](
--		[KeyColumn] [int] NOT NULL PRIMARY KEY,
--		[HasADefault1] [DATETIME2](1) NOT NULL,
--		[HasADefault2] [NVARCHAR](50) NULL,
--	)
--GO

--ALTER TABLE 
--	[dbo].[demoDefault] 
--ADD CONSTRAINT 
--	[DF_demoDefault_HasADefault]
--DEFAULT 
--	(GETDATE()) 
--FOR 
--	[HasADefault1]
--GO

--ALTER TABLE 
--	[dbo].[demoDefault] 
--ADD CONSTRAINT 
--	[DF_demoDefault_HasADefault2]
--DEFAULT 
--	('the default')
--FOR 
--	[HasADefault2]
--GO

----1 
---- This shows that even though the two columns have 
---- default constraints, you can still override
---- them and insert your own values 
--INSERT INTO 
--	dbo.demoDefault(
--		HasADefault1,HasADefault2,KeyColumn
--	)
--VALUES 
--	('2009-04-24','Test 1',1),
--	-- The statement specifies and inserts NULL, not the default value:
--	('2009-10-1',NULL,2);

----2
---- leaves the dafault values by explicitly specifing the keyword
---- DEFAULT.
--INSERT INTO 
--	dbo.demoDefault (HasADefault1,HasADefault2,KeyColumn)
--VALUES 
--	(DEFAULT,DEFAULT,3),
--	(DEFAULT,DEFAULT,4);

----3
---- We can simply omit columns which have default values specified
--INSERT INTO dbo.demoDefault (KeyColumn)
--VALUES 
--	(5),
--	(6);

----4
--SELECT 
--	HasADefault1,HasADefault2,KeyColumn
--FROM 
--	dbo.demoDefault;


/* Inserting Rows into Tables with Automatically Populating Columns */

-- In addition to DEFAULT constraints, there exist four types of columns that 
-- can be autopopulated:
--		rowversion - formerely TIMESTAMP - contains a binary number unique within a db
--		identity - autoincrementing numeric value
--		computed columns - usually based on values in other columns in the same row
--						   Value in this column can be stored in the db when we specify 
--						   keyword PERSISTED, or computed each time the row is accessed
--		sequences - user defined objects that act like identity columns but are not 
--                  restricted to a specific table. Sequences can be reused and created 
--                  across multiple tables  and rows and you need to reference the 
--                  sequence object in the insert statement

-- Be sure to always specify the column names, avoiding the automatically populated 
-- columns when you write an INSERT statement to avoid causing an error.


--There is an exception to the rule about inserting data into IDENTITY columns. 
--You can change a sessionspecific setting called IDENTITY_INSERT that will allow 
--you to insert a value into an IDENTITY column. 

--Developers and database administrators often do this when loading data and 
--the IDENTITY values must be preserved. After loading the data, the IDENTITY 
--column will work as before after you turn off IDENTITY_INSERT in that session 
--or insert into the table from a different session.


IF EXISTS (
  SELECT 
    * 
  FROM 
    sys.objects
  WHERE 
    object_id = OBJECT_ID(N'[dbo].[demoAutoPopulate]')
    AND type in (N'U')
  )  
  DROP TABLE [dbo].[demoAutoPopulate];


IF EXISTS (
  SELECT 
    * 
  FROM 
    sys.objects
  WHERE 
    object_id = OBJECT_ID(N'[dbo].[demoSequence]')
  )
  DROP SEQUENCE [dbo].[demoSequence];


CREATE 
  SEQUENCE dbo.demoSequence
AS INT
START WITH 
  1
INCREMENT BY 
  1;


CREATE TABLE 
  [dbo].[demoAutoPopulate](
    [RegularColumn] [NVARCHAR](50) NOT NULL PRIMARY KEY,
    -- autoincremented and populated:
    [IdentityColumn] [INT] IDENTITY(1,1) NOT NULL,
    -- autopopulated with a db-unique number:
    [RowversionColumn] [ROWVERSION] NOT NULL,
    [SequenceColumn] [INT] NOT NULL,
    -- populated with a computed and persisted value:
    [ComputedColumn] AS (
      [RegularColumn] + CONVERT([NVARCHAR], [IdentityColumn],(0))) PERSISTED
    )
GO

--1
-- We specify values for RegularColumn only. The database
-- engine automatically determined the values for the other columns
INSERT INTO dbo.demoAutoPopulate 
  (RegularColumn, SequenceColumn)
VALUES 
-- Here we use the sequence to populate the second column values
  ('a', NEXT VALUE FOR dbo.demoSequence),
  ('b', NEXT VALUE FOR dbo.demoSequence),
  ('c', NEXT VALUE FOR dbo.demoSequence);

--2
SELECT 
  RegularColumn, 
  IdentityColumn, 
  RowversionColumn, 
  SequenceColumn, 
  ComputedColumn
FROM 
  demoAutoPopulate;

/*
SequenceColumn, like the IdentityColumn, starts with one and increments 
by one. A difference between the two is you have the ability to reference 
the same demoSequence object when inserting values into another table. 

You can also set the command referencing the sequence object as a column 
default and this would allow the column to autopopulate. 

Another benefit to sequence numbers over identity values is you can determine 
the next number prior to inserting the value. 

SQL Server generates an identity number when a value is inserted 
but determines sequence numbers only when an application executes 
the NEXT VALUE FOR statement.
*/

/* EXERCISE 6-1 */

/*
Use the AdventureWorks2012 database to complete this exercise.
Run the following code to create required tables.

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoProduct]')
AND type in (N'U'))
DROP TABLE [dbo].[demoProduct]
GO

CREATE TABLE [dbo].[demoProduct](
[ProductID] [INT] NOT NULL PRIMARY KEY,
[Name] [dbo].[Name] NOT NULL,
[Color] [NVARCHAR](15) NULL,
[StandardCost] [MONEY] NOT NULL,
[ListPrice] [MONEY] NOT NULL,
[Size] [NVARCHAR](5) NULL,
[Weight] [DECIMAL](8, 2) NULL,
);

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderHeader]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderHeader]
GO

CREATE TABLE [dbo].[demoSalesOrderHeader](
[SalesOrderID] [INT] NOT NULL PRIMARY KEY,
[SalesID] [INT] NOT NULL IDENTITY,
[OrderDate] [DATETIME] NOT NULL,
[CustomerID] [INT] NOT NULL,
[SubTotal] [MONEY] NOT NULL,
[TaxAmt] [MONEY] NOT NULL,
[Freight] [MONEY] NOT NULL,
[DateEntered] [DATETIME],
[SalesNumber] [INT] NOT NULL,
[TotalDue] AS (ISNULL(([SubTotal]+[TaxAmt])+[Freight],(0))),
[RV] ROWVERSION NOT NULL);
GO

ALTER TABLE [dbo].[demoSalesOrderHeader] ADD CONSTRAINT
[DF_demoSalesOrderHeader_DateEntered]
DEFAULT (getdate()) FOR [DateEntered];
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesSequence]'))
DROP SEQUENCE [dbo].[demoSalesSequence]
GO

CREATE SEQUENCE demoSalesSequence
AS INT
START WITH 1
INCREMENT BY 1;
GO

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAddress]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAddress]
GO

CREATE TABLE [dbo].[demoAddress](
[AddressID] [INT] NOT NULL IDENTITY PRIMARY KEY,
[AddressLine1] [NVARCHAR](60) NOT NULL,
[AddressLine2] [NVARCHAR](60) NULL,
[City] [NVARCHAR](30) NOT NULL,
[PostalCode] [NVARCHAR](15) NOT NULL
);



1. Write a SELECT statement to retrieve data from the Sales.Product table. Use these
values to insert five rows into the dbo.demoProduct table using literal values. Write
five individual INSERT statements.

2. Insert five more rows into the dbo.demoProduct table. This time write one INSERT
statement.

3. Write an INSERT statement that inserts all the rows into the
dbo.demoSalesOrderHeader table from the Sales.SalesOrderHeader table. Hint:
Pay close attention to the properties of the columns in the
dbo.demoSalesOrderHeader table.

4. Write a SELECT INTO statement that creates a table, dbo.tempCustomerSales,
showing every CustomerID from the Sales.Customer along with a count of the
orders placed and the total amount due for each customer.

5. Write an INSERT statement that inserts all the products into the dbo.demoProduct
table from the Production.Product table that have not already been inserted. Don’t
specify literal ProductID values in the statement.

6. Write an INSERT statement that inserts all the addresses into the
dbo.demoAddress table from the Sales.Address table. Before running the INSERT
statement, type in and run the following command so that you can insert values
into the AddressID column:
SET IDENTITY_INSERT dbo.demoAddress ON;
*/