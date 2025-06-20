CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    PurchaseDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    ReturnDate DATE
);




SELECT * FROM orders;


-- Find all customers who made purchases greater than the average purchase amount of all customers.


SELECT AVG(unitprice * quantity) as avgprice from orders;




SELECT customername, SUM(unitprice * quantity) AS totalspent
FROM orders;
GROUP BY customername
HAVING SUM(unitprice * quantity) > (
	SELECT AVG(unitprice * quantity) FROM orders
);


-- Retrieve names of customers who purchased both 'Laptop' and 'Smartphone' in the same month.
SELECT customername, productname, purchasedate FROM orders;


SELECT EXTRACT(MONTH FROM purchasedate) AS purchasemonth, customername
FROM orders 
WHERE productname IN ('Laptop', 'Smartphone')
GROUP BY customername, EXTRACT(MONTH FROM purchasedate)
HAVING COUNT(DISTINCT productname) > 2;




-- List all products that were purchased more than twice but never returned.
SELECT productname, quantity
FROM orders
WHERE quantity >= 2 AND returndate IS NULL;






SELECT *
FROM Orders
WHERE PurchaseDate >= NOW() - INTERVAL '6'
  AND CustomerName NOT IN (
      SELECT CustomerName
      FROM Orders
      WHERE City = 'New York'
  );




-- Get customers whose purchased on weekends.


SELECT CustomerName, (UnitPrice * Quantity) AS TotalSpending, EXTRACT(DOW FROM purchasedate) as DOW, purchasedate
FROM Orders
WHERE EXTRACT(DOW FROM PurchaseDate) IN (0, 6); -- 0 = Sunday, 1 = Monday, 2 = Tuesday, ... 6 = Saturday in PostgreSQL




SELECT COUNT(DISTINCT(city)) from orders;


-- -+
-- | sell_date  | num_sold | products                     |
-- +------------+----------+------------------------------+
-- | 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
-- | 2020-06-01 | 2        | Bible,Pencil                 |
-- | 2020-06-02 | 1        | Mask                         |


-- STRING_AGG function is used to combine all strings to 1.
SELECT sell_date, COUNT(DISTINCT product) as num_sold, STRING_AGG(DISTINCT product, ',') AS products
FROM activities
GROUP BY sell_date;
