CREATE TABLE Person (
    personId INT PRIMARY KEY,
    lastName VARCHAR(255),
    firstName VARCHAR(255)
);

CREATE TABLE Address (
    addressId INT PRIMARY KEY,
    personId INT,
    city VARCHAR(255),
    state VARCHAR(255),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

INSERT INTO Person (personId, lastName, firstName)
VALUES
(1, 'Wang', 'Allen'),
(2, 'Alice', 'Bob'),
(3, 'Doe', 'John');  -- New person with personId 3

-- Insert data into Address table
INSERT INTO Address (addressId, personId, city, state)
VALUES
(1, 2, 'New York City', 'New York'),
(2, 3, 'Leetcode', 'California'); 




+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+


SELECT p.firstname, p.lastname, a.city, a.state
FROM person p
LEFT JOIN address a
ON p.personId = a.personId
ORDER BY p.firstname;



CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    managerId INT,
    FOREIGN KEY (managerId) REFERENCES Employee(id)
);
INSERT INTO Employee (id, name, salary, managerId)
VALUES
(1, 'Joe', 70000, 3),
(2, 'Henry', 80000, 4),
(3, 'Sam', 60000, NULL),
(4, 'Max', 90000, NULL);


-- Joe is the only employee who earns more than his manager.
SELECT e1.name AS EMP
FROM Employee e1
LEFT JOIN Employee e2
ON e1.managerId = e2.id
WHERE e1.id <> e2.id AND e1.salary > e2.salary;


CREATE TABLE duplicate_emails (
	id int,
	email varchar
);

INSERT INTO duplicate_emails (id, email)
VALUES
(1, 'a@b.com'),
(2, 'c@d.com'),
(3, 'a@b.com');

SELECT * FROM duplicate_emails;

SELECT email
FROM duplicate_emails
GROUP BY email
HAVING COUNT(email) > 1;



CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customerId INT,
    FOREIGN KEY (customerId) REFERENCES Customers(id)
);


INSERT INTO Customers (id, name)
VALUES
(1, 'Joe'),
(2, 'Henry'),
(3, 'Sam'),
(4, 'Max');

-- Insert data into Orders table
INSERT INTO Orders (id, customerId)
VALUES
(1, 3),
(2, 1);



+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+


SELECT c.name AS "Customers", o.customerId
FROM Customers c
LEFT JOIN Orders o
ON c.id = o.customerId
WHERE o.customerID IS NULL;


SELECT * FROM duplicate_emails;

SELECT DISTINCT email, id
FROM duplicate_emails;

CREATE TABLE Weather (
  id SERIAL PRIMARY KEY,
  recordDate DATE,
  temperature INT
);

INSERT INTO Weather (recordDate, temperature)
VALUES
  ('2015-01-01', 10),
  ('2015-01-02', 25),
  ('2015-01-03', 20),
  ('2015-01-04', 30);



SELECT w1.id as "id"
FROM weather w1
LEFT JOIN weather w2
ON w1.recordDate = w2.recordDate + INTERVAL '1 day'
WHERE w1.temperature > w2.temperature

-- INTERVAL FUNCTION is used to add specific interval in day/week/month/year ...



CREATE TABLE Activity (
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT
);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES
  (1, 2, '2016-03-01', 5),
  (1, 2, '2016-05-02', 6),
  (2, 3, '2017-06-25', 1),
  (3, 1, '2016-03-02', 0),
  (3, 4, '2018-07-03', 5);


+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+



SELECT player_id, STRING_AGG(event_date::VARCHAR, ' , ')
FROM Activity
GROUP BY player_id
ORDER BY player_id;

-- MIN will return first date of occurance
SELECT player_id, MIN(event_date)
FROM Activity
GROUP BY player_id;

-- MAX will return first date of occurance
SELECT player_id, MAX(event_date)
FROM Activity
GROUP BY player_id;

SELECT DISTINCT ON (player_id) player_id, event_date
FROM Activity;




CREATE TABLE Employee2 (
  empId INT PRIMARY KEY,
  name VARCHAR(50),
  supervisor INT,
  salary INT,
  FOREIGN KEY (supervisor) REFERENCES Employee2(empId) -- This is for self-referencing
);
CREATE TABLE Bonus (
  empId INT PRIMARY KEY,
  bonus INT,
  FOREIGN KEY (empId) REFERENCES Employee2(empId) -- Ensures bonus is linked to an employee
);
INSERT INTO Employee2 (empId, name, supervisor, salary)
VALUES
  (3, 'Brad', NULL, 4000),
  (1, 'John', 3, 1000),
  (2, 'Dan', 3, 2000),
  (4, 'Thomas', 3, 4000);
INSERT INTO Bonus (empId, bonus)
VALUES
  (2, 500),
  (4, 2000);


SELECT e.name, b.bonus
FROM Employee2 e
LEFT JOIN Bonus b
ON e.empId = b.empId
WHERE b.bonus IS NULL OR b.bonus < 1000;


CREATE TABLE Orders2 (
	order_number INT,
	customer_number INT
);

INSERT INTO Orders2
VALUES
(1,1),
(2,2),
(3,3),
(4,3)

SELECT * FROM orders2;

-- Write a solution to find the customer_number for the customer who has placed the largest number of orders.

SELECT customer_number
FROM Orders2
GROUP BY customer_number
ORDER BY COUNT(customer_number) DESC
LIMIT 1;


CREATE TABLE Courses (
  student VARCHAR(50),
  class VARCHAR(50)
);

INSERT INTO Courses (student, class)
VALUES
  ('A', 'Math'),
  ('B', 'English'),
  ('C', 'Math'),
  ('D', 'Biology'),
  ('E', 'Math'),
  ('F', 'Computer'),
  ('G', 'Math'),
  ('H', 'Math'),
  ('I', 'Math');


SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >=5;



CREATE TABLE SalesPerson (
  sales_id INT PRIMARY KEY,
  name VARCHAR(50),
  salary INT,
  commission_rate INT,
  hire_date DATE
);

INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES
  (1, 'John', 100000, 6, '2006-04-01'),
  (2, 'Amy', 12000, 5, '2010-05-01'),
  (3, 'Mark', 65000, 12, '2008-12-25'),
  (4, 'Pam', 25000, 25, '2005-01-01'),
  (5, 'Alex', 5000, 10, '2007-02-03');


CREATE TABLE Company (
  com_id INT PRIMARY KEY,
  name VARCHAR(50),
  city VARCHAR(50)
);

INSERT INTO Company (com_id, name, city)
VALUES
  (1, 'RED', 'Boston'),
  (2, 'ORANGE', 'New York'),
  (3, 'YELLOW', 'Boston'),
  (4, 'GREEN', 'Austin');

CREATE TABLE Orders3 (
  order_id INT PRIMARY KEY,
  order_date DATE,
  com_id INT,
  sales_id INT,
  amount INT,
  FOREIGN KEY (com_id) REFERENCES Company(com_id),
  FOREIGN KEY (sales_id) REFERENCES SalesPerson(sales_id)
);
INSERT INTO Orders3 (order_id, order_date, com_id, sales_id, amount)
VALUES
  (1, '2014-01-01', 3, 4, 10000),
  (2, '2014-02-01', 4, 5, 5000),
  (3, '2014-03-01', 1, 1, 50000),
  (4, '2014-04-01', 1, 4, 25000);

/*
START

NOTE:- This question is not resolved using all JOIN query and currently, we solved using Sub-query.
*/
SELECT sp.name, o.com_id, o.sales_id
FROM SalesPerson sp
LEFT JOIN Orders3 o ON sp.sales_id = o.sales_id
LEFT JOIN Company c ON o.com_id = c.com_id
WHERE c.name <> 'RED' OR o.sales_id IS NULL;

SELECT sp.name
FROM SalesPerson sp
LEFT JOIN Orders3 o ON sp.sales_id = o.sales_id
LEFT JOIN Company c ON o.com_id = c.com_id AND c.name = 'RED'
WHERE c.name IS NULL;


SELECT s.name
FROM SalesPerson s
WHERE s.sales_id NOT IN (
    SELECT o.sales_id
    FROM Orders3 o
    JOIN Company c ON o.com_id = c.com_id
    WHERE c.name = 'RED'
);


/*
END
*/


CREATE TABLE num (
	num int
)

INSERT INTO  num
VALUES
(8),
(8),
(7),
(7),
(3),
(3),
(3)

SELECT * FROM num;

SELECT num
FROM num
GROUP BY num
HAVING COUNT(num) = 1
ORDER BY num DESC
LIMIT 1
OFFSET 0;

-- Below syntax will return NULL explicitly if no data matches the where condition. Because PSQL does not return explicitly null, we have to return it manually.
SELECT 
    (SELECT num
     FROM num
     GROUP BY num
     HAVING COUNT(num) = 1
     ORDER BY num DESC
     LIMIT 1) AS num;


CREATE TABLE Cinema (
    id SERIAL PRIMARY KEY,
    movie VARCHAR(255),
    description TEXT,
    rating DECIMAL(3, 1)
);
INSERT INTO Cinema (movie, description, rating)
VALUES
    ('War', 'great 3D', 8.9),
    ('Science', 'fiction', 8.5),
    ('irish', 'boring', 6.2),
    ('Ice song', 'Fantacy', 8.6),
    ('House card', 'Interesting', 9.1);



select
    id
    ,movie
    ,description
    ,rating
from Cinema
where id % 2 = 1
and description not like '%boring%'
order by rating desc;


-- Write your PostgreSQL query statement below
UPDATE Salary
SET sex = CASE
    WHEN sex = 'f' THEN 'm'
    WHEN sex = 'm' THEN 'f'
END;



CREATE TABLE ActorDirector (
    actor_id INT,
    director_id INT,
    timestamp INT
);
INSERT INTO ActorDirector (actor_id, director_id, timestamp) 
VALUES
(1, 1, 0),
(1, 1, 1),
(1, 1, 2),
(1, 2, 3),
(1, 2, 4),
(2, 1, 5),
(2, 1, 6);


SELECT * FROM ActorDirector;

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;


CREATE TABLE Project (
    project_id INT,
    employee_id INT
);
INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);
CREATE TABLE Employee3 (
    employee_id INT,
    name VARCHAR(100),
    experience_years INT
);
INSERT INTO Employee3 (employee_id, name, experience_years) VALUES
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 1),
(4, 'Doe', 2);

SELECT p.project_id, AVG(e.experience_years)::NUMERIC(10, 2) AS "average_years"
FROM PROJECT p
JOIN Employee3 e
ON p.employee_id = e.employee_id
GROUP BY p.project_id
ORDER BY project_id;
11:42
Janmey Solanki


CREATE TABLE Product (
    product_id INT,
    product_name VARCHAR(100),
    unit_price DECIMAL(10, 2)
);
INSERT INTO Product (product_id, product_name, unit_price) VALUES
(1, 'S8', 1000),
(2, 'G4', 800),
(3, 'iPhone', 1400);
CREATE TABLE Sales (
    seller_id INT,
    product_id INT,
    buyer_id INT,
    sale_date DATE,
    quantity INT,
    price DECIMAL(10, 2)
);
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) VALUES
(1, 1, 1, '2019-01-21', 2, 2000),
(1, 2, 2, '2019-02-17', 1, 800),
(2, 2, 3, '2019-06-02', 1, 800),
(3, 3, 4, '2019-05-13', 2, 2800);


SELECT s.product_id, p.product_name
FROM product p
JOIN sales s
USING(product_id)
-- ON p.product_id = s.product_id
GROUP BY s.product_id, p.product_name
HAVING MIN(EXTRACT(MONTH FROM s.sale_date)) >= 1 AND MAX(EXTRACT(MONTH FROM s.sale_date)) <= 3;



CREATE TABLE Rides (
    id INT,
    user_id INT,
    distance INT
);
CREATE TABLE Users (
    id INT,
    name VARCHAR(100)
);

INSERT INTO Rides (id, user_id, distance) VALUES
(1, 1, 120),
(2, 2, 317),
(3, 3, 222),
(4, 7, 100),
(5, 13, 312),
(6, 19, 50),
(7, 7, 120),
(8, 19, 400),
(9, 7, 230);
INSERT INTO Users (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Alex'),
(4, 'Donald'),
(7, 'Lee'),
(13, 'Jonathan'),
(19, 'Elvis');



+----------+--------------------+
| name     | travelled_distance |
+----------+--------------------+
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |


-- COALESCE is used to explicitly return values as in psql, it gives null if no result found.
SELECT u.name, SUM(COALESCE(r.distance, 0)) AS "travelled_distance"
FROM users u
LEFT JOIN rides r
ON u.id = r.user_id
GROUP BY u.name
ORDER BY travelled_distance DESC, u.name ASC;



CREATE TABLE Products (
    product_id INT,
    product_name VARCHAR(100),
    product_category VARCHAR(50)
);
INSERT INTO Products (product_id, product_name, product_category) VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'),
(4, 'Lenovo', 'Laptop'),
(5, 'Leetcode Kit', 'T-shirt');
CREATE TABLE Orders4 (
    product_id INT,
    order_date DATE,
    unit INT
);
INSERT INTO Orders4 (product_id, order_date, unit) VALUES
(1, '2020-02-05', 60),
(1, '2020-02-10', 70),
(2, '2020-01-18', 30),
(2, '2020-02-11', 80),
(3, '2020-02-17', 2),
(3, '2020-02-24', 3),
(4, '2020-03-01', 20),
(4, '2020-03-04', 30),
(4, '2020-03-04', 60),
(5, '2020-02-25', 50),
(5, '2020-02-27', 50),
(5, '2020-03-01', 50);




SELECT p.product_name, SUM(o.unit) unit
FROM Products p
LEFT JOIN Orders4 o
USING(product_id)
GROUP BY p.product_name, EXTRACT(MONTH FROM o.order_date)
HAVING (EXTRACT(MONTH FROM MIN(o.order_date)) = 2 or EXTRACT(MONTH FROM MAX(o.order_date)) = 2) AND SUM(unit) >= 100

-- Above function will work if we need to check month only but in below, we check both month and year.

SELECT p.product_name, SUM(o.unit)
FROM Products p
INNER JOIN Orders4 o
USING(product_id)
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100

