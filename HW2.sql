USE AdventureWorks2019
GO
-- 1.   How many products can you find in the Production.Product table?
SELECT COUNT(Name) AS [Number of Products]
FROM Production.Product
-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductSubcategoryID)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
-- 3.  How many Products reside in each SubCategory? Write a query to display the results with the following titles. ProductSubcategoryID CountedProducts
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
-- 4. How many products that do not have a product subcategory.
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity)
FROM Production.ProductInventory
GROUP BY ProductID
ORDER BY ProductID
-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum 
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100
-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum 
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100
--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS [Average Quantity] 
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID
-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf IS NOT NULL
GROUP BY ProductID, Shelf;
-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;
-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, p.Name Province
FROM Person.StateProvince p JOIN Person.CountryRegion c
ON p.CountryRegionCode = c.CountryRegionCode
ORDER BY c.Name
-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, p.Name Province
FROM Person.StateProvince p JOIN Person.CountryRegion c
ON p.CountryRegionCode = c.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')
ORDER BY c.Name


USE Northwind
GO
-- 14. List all Products that has been sold at least once in last 27 years.
SELECT DISTINCT p.ProductID, p.ProductName
FROM [Order Details] od LEFT JOIN Orders o ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >=DATEADD(YEAR, -27, GETDATE())
ORDER BY p.ProductID;
-- 15. List top 5 locations (Zip Code) where the products sold most.
SELECT dt.ProductID, dt.ProductName, dt.ShipPostalCode
FROM(
SELECT  p.ProductID, p.ProductName, o.ShipPostalCode, COUNT(o.OrderID) AS TotalSales, ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY COUNT(o.OrderID)) AS RowNum
FROM [Order Details] od LEFT JOIN Orders o ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, o.ShipPostalCode
) dt
WHERE dt.RowNum <= 5
ORDER BY dt.ProductID, dt.RowNum
-- 16. List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT dt.ProductID, dt.ProductName, dt.ShipPostalCode
FROM(
SELECT  p.ProductID, p.ProductName, o.ShipPostalCode, COUNT(o.OrderID) AS TotalSales, ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY COUNT(o.OrderID)) AS RowNum
FROM [Order Details] od LEFT JOIN Orders o ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >=DATEADD(YEAR, -27, GETDATE())
GROUP BY p.ProductID, p.ProductName, o.ShipPostalCode
) dt
WHERE dt.RowNum <= 5
ORDER BY dt.ProductID, dt.RowNum
-- 17. List all city names and number of customers in that city.
SELECT City, COUNT(CustomerID) AS [Number of Customers]
FROM Customers
GROUP BY City
ORDER BY CITY
-- 18. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) AS [Number of Customers]
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2
ORDER BY CITY
-- 19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.CustomerID, c.CompanyName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'
ORDER BY c.CustomerID
-- 20. List the names of all customers with most recent order dates
SELECT c.CompanyName, o.MostRecentOrder
FROM Customers c JOIN (
    SELECT CustomerID, MAX(OrderDate) AS MostRecentOrder
    FROM Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID
ORDER BY c.CompanyName
-- 21. Display the names of all customers  along with the  count of products they bought
SELECT c.CompanyName, COUNT(od.Quantity) AS [Products Brought]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
ORDER BY c.CompanyName
-- 22. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.Quantity) AS [Products Brought]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.Quantity) > 100
ORDER BY c.CustomerID
-- 23. List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT s.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Suppliers s CROSS JOIN Shippers sh
ORDER BY s.CompanyName, sh.CompanyName
-- 24. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate, p.ProductName
-- 25. Displays pairs of employees who have the same job title.
SELECT e1.EmployeeID AS EmployeeID1, e1.FirstName + ' ' + e1.LastName AS EmployeeName1, e2.EmployeeID AS EmployeeID2, e2.FirstName + ' ' + e2.LastName AS EmployeeName2, e1.Title AS JobTitle
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID < e2.EmployeeID
ORDER BY e1.Title, e1.EmployeeID, e2.EmployeeID;
-- 26. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.EmployeeID AS ManagerID, m.FirstName + ' ' + m.LastName AS ManagerName, COUNT(e.EmployeeID) AS NumberOfEmployees
FROM Employees m JOIN Employees e ON m.EmployeeID = e.ReportsTo
GROUP BY m.EmployeeID, m.FirstName, m.LastName
HAVING COUNT(e.EmployeeID) > 2;
-- 27. Display the customers and suppliers by city. The results should have the following columns: City, Name, Contact Name, Type (Customer or Supplier)
SELECT c.City, c.CompanyName AS Name, c.ContactName, 'Customer' AS Type
FROM Customers c
UNION ALL
SELECT s.City, s.CompanyName AS Name, s.ContactName, 'Supplier' AS Type
FROM Suppliers s
ORDER BY City, Name
