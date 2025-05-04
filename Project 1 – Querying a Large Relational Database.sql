Tasks To Be Performed:
1. Download the AdventureWorks database from the following location and
restore it in your server:
Location:
https://github.com/Microsoft/sql-server-samples/releases/tag/adventurewor
ks
File Name: AdventureWorks2012.bak
AdventureWorks is a sample database shipped with SQL Server and it can
be downloaded from the GitHub site. AdventureWorks has replaced
Northwind and Pubs sample databases that were available in SQL Server
in 2005. Microsoft keeps updating the sample database as it releases new
versions.
2. Restore Backup:
Follow the below steps to restore a backup of your database using SQL
Server Management Studio:
a. Open SQL Server Management Studio and connect to the target
SQL Server instance
b. Right-click on the Databases Node and select Restore Database
c. Select Device and click on the ellipsis (...)
d. In the dialog box, select Backup devices, click on Add, navigate to
the database backup in the file system of the server, select the
backup, and click on OK.
e. If needed, change the target location for the data and log files in the
Files pane
Note: It is a best practice to place the data and log files on different
drives.
f. Now, click on OK
This will initiate the database restore. After it completes, you will have the
AdventureWorks database installed on your SQL Server instance


--3. Perform the following with help of the above database:

--a. Get all the details from the person table including email ID, phone
--number and phone number type

select * from [person].[person]

select * from [Person].[PersonPhone]

select * from [Person].[PhoneNumberType]

select * from [Person].[EmailAddress]

select p.*,ph.PhoneNumber,pht.Name,pe.EmailAddress from [person].[person] as p
inner join
[Person].[PersonPhone] as ph
on p.BusinessEntityID=ph.BusinessEntityID
inner join
[Person].[PhoneNumberType] as pht
on ph.PhoneNumberTypeID=pht.PhoneNumberTypeID
inner join
[Person].[EmailAddress] as pe
on pe.BusinessEntityID=p.BusinessEntityID

--b. Get the details of the sales header order made in May 2011

select * from [Sales].[SalesOrderHeader]


select * from [Sales].[SalesOrderHeader] where year(orderdate) = 2011 and  month(orderdate) = 5


--c. Get the details of the sales details order made in the month of May
--2011

select * from [Sales].[SalesOrderDetail]
select * from [Sales].[SalesOrderHeader]


select * from [Sales].[SalesOrderDetail] AS SOD
INNER JOIN
[Sales].[SalesOrderHeader] AS SOH
ON SOD.SalesOrderID=SOH.SalesOrderID
WHERE MONTH(OrderDate)= 5 AND YEAR(ORDERDATE)=2011


--d. Get the total sales made in May 2011

select * from [Sales].[SalesOrderDetail]

SELECT SUM(LINETOTAL) FROM [Sales].[SalesOrderDetail]
WHERE SalesOrderID IN(SELECT SalesOrderID FROM [Sales].[SalesOrderHeader]
WHERE MONTH(OrderDate)= 5 AND YEAR(ORDERDATE)=2011)

--e. Get the total sales made in the year 2011 by month order by
--increasing sales


SELECT MONTH(ORDERDATE),SUM(TotalDue) AS SALES_VALUE FROM [Sales].[SalesOrderHeader]
WHERE YEAR(ORDERDATE)=2011
GROUP BY MONTH(ORDERDATE)
ORDER BY SALES_VALUE DESC


--f. Get the total sales made to the customer with FirstName='Gustavo'
--and LastName ='Achong'


select *  FROM Sales.Customer
select *  FROM Person.Person
select *  FROM Sales.SalesOrderDetail
select *  FROM Sales.SalesOrderHeader

SELECT
     p.Title, p.FirstName, p.MiddleName, p.LastName, tmp.TotalAmount
FROM Sales.Customer c
     INNER JOIN Person.Person AS p ON p.BusinessEntityID=c.PersonID
     LEFT JOIN
       (
         SELECT
                  soh.CustomerID, SUM(LineTotal) AS TotalAmount
         FROM     Sales.SalesOrderDetail            AS sod
                  INNER JOIN Sales.SalesOrderHeader AS soh ON soh.SalesOrderID=sod.SalesOrderID
         GROUP BY soh.CustomerID
       )   tmp ON tmp.CustomerID=c.CustomerID
	     WHERE FirstName='Gustavo' AND LastName ='Achong';