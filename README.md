# SQLminiProject1
A project encapsulating the second week's training content at Sparta Global.

## Introduction
The primary focus of this training is to demonstrate and put into practice what we have learned during SQL training. This project and its questions were based on the Northwind sample database and the majority of the tasks were cobnducted using the Microsoft Azure Data Studio database tool. 

The various topics learned span from basic to advanced comprehension. These topics include:
- Syntax
- Table & Column Aliasing
- DML Commands
- DDL Commands
- Aggregate Functions
- Joins 
- Subqueries
- String Manipulation
- Graphically presenting data using Excel

## Example Question
#### List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart.
``` sql
SELECT 
  s.CompanyName AS "Supplier", 
  ROUND(SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)), 2) AS "Total Sales, $" 
FROM [Order Details] od 
INNER JOIN Products p ON od.ProductID = p.ProductID 
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID 
GROUP BY s.CompanyName 
HAVING SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) > 10000 
ORDER BY SUM(od.Quantity*od.UnitPrice*(1 - od.Discount)) DESC ;
```

![image](https://user-images.githubusercontent.com/58784414/111958943-bee8be00-8ae5-11eb-96af-91f7bd410d39.png)
