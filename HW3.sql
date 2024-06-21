USE Northwind
GO
-- 1. List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IN (SELECT City FROM Customers)
ORDER BY e.City
-- 2. List all cities that have Customers but no Employee. a. Use sub-query. b. Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (SELECT City FROM Employees)
ORDER BY c.City
-- 3. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantities
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY p.ProductName
-- 4.  List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS TotalProductsOrdered
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City
ORDER BY c.City
-- 5. List all Customer Cities that have at least two customers. 
-- a. Use union
SELECT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2
UNION
SELECT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2
-- b. Use sub-query and no union
SELECT City
FROM Customers
WHERE City in (
    SELECT City
    FROM Customers
    GROUP BY City
    HAVING COUNT(CustomerID) >= 2
)
ORDER BY City
-- 6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2
ORDER BY c.City
-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.CompanyName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City <> o.ShipCity
-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select * FROM Customers
select * from Orders
select * from [Order Details]
-- 9. List all cities that have never ordered something but we have employees there. 
-- a. Use sub-query

-- b. Do not use sub-query

-- 10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

-- 11. How do you remove the duplicates record of a table?