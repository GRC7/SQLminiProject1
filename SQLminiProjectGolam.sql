USE Northwind;


SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Suppliers;
SELECT * FROM Categories;
SELECT * FROM Employees;

-- Exercise 1.1
/* First selecting the relevant information within the SELECT statement.
Filtering which cities the information is related to using a WHERE statement */
SELECT 
    c.CustomerID, 
    c.CompanyName, 
    c.ContactName, 
    c.Address, 
    c.City, 
    c.Region,
    c.PostalCode, 
    c.Country
FROM Customers c
WHERE c.City IN ('London','Paris')
;

-- Exercise 1.2
/* To find which products are contained in bottles, filter the Quantity per Unit
column to contain 'bottle' */
SELECT p.ProductName
FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottle%'
;

-- Exercise 1.3
/* Company Name and Country are from the Suppliers table, therefore we must
attatch these results using a join */
SELECT 
    p.ProductID, 
    s.CompanyName, 
    s.Country
FROM Products p 
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
;

-- Exercise 1.4 (Incomplete)
/* We ned to know how many products are in each category, therefore we select 
to view the Category Name and the Count of the total rows, The GROUP BY statement
ensures that the counts are split into various categories */
SELECT 
    c.CategoryName, 
    COUNT(*) AS "Number of Products"
FROM Products p 
/* Again since we're querying data from two different tables within the DB, we 
need to join the Products and Categories tables */
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY "Number of Products" DESC
;

-- Exercise 1.5
/* Here the concatenation function CONCAT is utilised in order to present the 
Employee name as one column, aliased as "Name". */
SELECT CONCAT(e.TitleofCourtesy,e.FirstName,' ',e.LastName) AS "Employee Name", 
    e.City AS "City of resisdence"
FROM Employees e
WHERE e.Country = 'UK'
;

-- Exercise 1.6

SELECT 
    -- The total price considers the discount
    ROUND(SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)), 2) AS "Total", 
    t.RegionID
/* Using the ERD diagram, I mapped out the path of traversal using 5 Join statements
in order to group total order values by the regions */
FROM Products p    
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
INNER JOIN Territories t ON et.TerritoryID = t.TerritoryID
GROUP BY t.RegionID
/* This HAVING statement ensures only regions which have a total order value of 
£1000000+ are considered*/
HAVING SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) >= 1000000
ORDER BY SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) DESC
;

SELECT 
    ROUND(SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)), 2) AS "Total", 
    t.RegionID
FROM Products p    
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
INNER JOIN Territories t ON et.TerritoryID = t.TerritoryID
GROUP BY t.RegionID
HAVING SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) >= 1000000
ORDER BY SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) DESC
;

-- Exercise 1.7
SELECT 
    o.ShipCountry, 
    -- Count alised to give the returned data context
    COUNT(*) AS "Freight amounts greater than 100"
FROM Orders o
-- Filter results to only include UK or USA
WHERE o.ShipCountry IN ('UK', 'USA') 
    AND o.Freight > 100
GROUP BY o.ShipCountry
;

-- Exercise 1.8
/* We only need the top result, so we use TOP 1*/
SELECT TOP 1 
    od.OrderID,
    -- Caclculating the discount & column aliasing  
    SUM(od.Discount*od.UnitPrice*od.Quantity) AS "Total Discount"
FROM [Order Details] od
GROUP BY od.orderID
-- Making sure the first result holds the highest value
ORDER BY "Total Discount" DESC
;
----------------------------------------------------------------------------------------------------------------------------------

-- Exercise 2.1
-- Creating a new database
CREATE DATABASE golam_db;

-- Switiching the desired database
USE golam_db;

-- Creating an empty table named 'spartan_table'
CREATE TABLE spartan_table (
    -- defining the spartan ID as a primary key
    /* IDENTITY(1,1) means that the values start at one and
     auto-increments by 1 with each new entry */
    spartan_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(5),
    first_name VARCHAR(10),
    last_name VARCHAR(15),
    university_attended VARCHAR(50),
    course_taken VARCHAR(50),
    mark_achieved CHAR(3),
);

-- Exercise 2.2
-- Example of adding an entry into the table
/* All column names declared with the exception of the Spartan ID
since this is a primary key which auto-increments, therefore it is not required to
define when adding new rows*/
INSERT INTO spartan_table (
    title,
    first_name,
    last_name,
    university_attended,
    course_taken,
    mark_achieved
) VALUES (
    'Mr.',
    'Golam',
    'Choudhury',
    'City University of London',
    'BEng Aeronautical Engineering',
    '2:1'
);

INSERT INTO spartan_table (
    title,
    first_name,
    last_name,
    university_attended,
    course_taken,
    mark_achieved
) VALUES (
    'Mr.',
    'Jakub',
    'Matyjewicz',
    'Poznan University of Technology',
    'Technical Physics',
    NULL
);

INSERT INTO spartan_table (
    title,
    first_name,
    last_name,
    university_attended,
    course_taken,
    mark_achieved
) VALUES (
    'Mr.',
    'Alasdair',
    'Malcolm',
    'University of Exeter',
    'Electronic Engineering',
    '2:2'
);

INSERT INTO spartan_table (
    title,
    first_name,
    last_name,
    university_attended,
    course_taken,
    mark_achieved
) VALUES (
    'Mr.',
    'Matthew',
    'Holmes',
    'University of Bath',
    'Computer Science and Mathematics',
    '2:2'
);

SELECT * FROM spartan_table;

DROP TABLE spartan_table;

----------------------------------------------------------------------------------------------------------------------------------
-- Exercise 3.1
-- This requires a table to join itself
SELECT 
    -- Concatenation of the employee names
    CONCAT(e.FirstName,' ',e.LastName) AS "Employee Name",
    CONCAT(emp.FirstName,' ',emp.LastName) AS "Reports To"
FROM Employees e
/* Left join used to see all the employees and the employees they 
report to by matching the Report To number in the left table with 
the Employee ID in the right table*/
LEFT JOIN Employees emp ON e.ReportsTo = emp.EmployeeID
;

SELECT 
    -- Concatenation of the employee names
    CONCAT(e.FirstName,' ',e.LastName) AS "Employee Name",
    emp.FirstName+' '+emp.LastName AS "Reports To"
FROM Employees e
/* Left join used to see all the employees and the employees they 
report to by matching the Report To number in the left table with 
the Employee ID in the right table*/
LEFT JOIN Employees emp ON e.ReportsTo = emp.EmployeeID
;
-- Exercise 3.2
SELECT 
    -- Selecting supplier name
    s.CompanyName AS "Supplier",
    -- Selecting a rounded value of the TOTAL order value
    ROUND(SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)), 2) AS "Total Sales, $"
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
-- Categorising by each company/supplier
GROUP BY s.CompanyName
-- Filtering results to only consider values above 10000
HAVING SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) > 10000
-- Sorting from highest to lowest
ORDER BY SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) DESC
;

-- Ecercise 3.3
-- We only require the top ten results, hence, TOP 10
SELECT TOP 10 
    c.CompanyName, 
    -- I personally interpreted value as product/order worth without discount
    SUM(od.UnitPrice * od.Quantity) AS "Total value of orders"
FROM Orders o 
    -- Traversing from Orders to Customers table to obtain the Customer Name
    -- By matching the Order IDs from [Order Deatils] with Order IDs in Orders
    -- and matching the Customer IDs from Orders with Customer IDs in Customers
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    -- Using a subquery within a WHERE statement
    -- The WHERE ensures the year of the data matches that obtained from the subquery
    WHERE FORMAT(o.OrderDate, 'yyyy') LIKE (
        -- Obtains the latest year from the result set
        SELECT TOP 1 FORMAT(ord.OrderDate, 'yyyy') as "Years"
        FROM Orders ord
        -- This ORDER BY makes sure latest year is at the top
        ORDER BY "Years" DESC   
    )
    AND o.ShippedDate IS NOT NULL
GROUP BY c.CompanyName
-- This ORDER BY ensures the results go from highest to lowest value
ORDER BY "Total value of Orders" DESC
;


-- Exercise 3.4
SELECT 
    -- Selecting the average ship time
    -- Calculated as the difference in days between shipped date and order date
    AVG(DATEDIFF(d,o.OrderDate,o.ShippedDate)) AS "Average ship time",
    -- Selecting the order date in a custom format
    FORMAT(o.OrderDate, 'MMM-yy') AS "Month"
FROM Orders o 
-- GROUP BY o.OrderID
GROUP BY FORMAT(o.OrderDate, 'MMM-yy')
-- Ordering by the earliest to the latest date
ORDER BY MAX(FORMAT(o.OrderDate, 'yyyy-MM'))
;







