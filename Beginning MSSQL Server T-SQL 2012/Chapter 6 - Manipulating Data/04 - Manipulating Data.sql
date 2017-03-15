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
--);

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