CREATE TABLE Employees2 (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Manager_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES Employees2(Emp_ID)
);


INSERT INTO Employees2 (Emp_ID, Emp_Name, Manager_ID) VALUES
(1, 'John', NULL),
(2, 'Sarah', 1),
(3, 'Mike', 1),
(4, 'Alice', 2),
(5, 'Bob', 2),
(6, 'Jane', 3);


SELECT * FROM employees2;

-- find the names of employees and the names of their managers.
SELECT e1.emp_name AS Emp, e2.emp_name AS Mng
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.manager_id = e2.emp_id;

-- find all pairs of employees who report to the same manager and list all.
SELECT manager_id, STRING_AGG(emp_name, ', ')
FROM employees2
GROUP BY manager_id;

-- find all pairs of employees who report to the same manager and list the pair only.
SELECT STRING_AGG(e1.emp_name, ' - ') as emp, e1.manager_id
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.manager_id = e2.manager_id
WHERE e1.emp_id != e2.emp_id
GROUP BY e1.manager_id
ORDER BY e1.manager_id;


--  Hierarchy of Employees: query to display the employees and their managers, including employees who do not have managers (i.e., Manager_ID is NULL).
SELECT e1.emp_name as EMP, e2.emp_name as MNG
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.manager_id = e2.emp_id 
WHERE e1.emp_id <> e2.emp_id;

-- find the employee who is the top manager (has no manager).
SELECT emp_name
FROM employees2
WHERE manager_id IS NULL;

-- query to find the number of employees under each manager (i.e., the number of employees who have a specific manager).
SELECT manager_id, COUNT(*) as emps
FROM employees2
GROUP BY manager_id
ORDER BY manager_id;

SELECT e1.emp_name AS manager, COUNT(e2.emp_name) AS employees
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.emp_id = e2.manager_id
GROUP BY e1.emp_name;


-- Find Employees Who Report to the Same Manager
SELECT manager_id, STRING_AGG(emp_name, ' - ')
FROM employees2
GROUP BY manager_id;

SELECT e1.emp_name AS emp1, e2.emp_name AS emp2, e1.manager_id
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.manager_id = e2.manager_id
WHERE e1.emp_id <> e2.emp_id;

-- Find the Chain of Command (Hierarchy)
-- Employee	Manager
-- Sarah	John
-- Mike	    John
-- Alice	Sarah
-- Bob	    Sarah
-- Jane	    Mike

SELECT e2.emp_name as EMP, e1.emp_name as MANAGER
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.emp_id = e2.manager_id
WHERE e1.emp_id <> e2.emp_id;

-- Find the Number of Direct Reports for Each Employee
-- Manager	Direct_Reports
-- John		2
-- Sarah	2
-- Mike		1
-- Alice	0
-- Bob		0
-- Jane		0

SELECT e1.emp_name AS Manager, COUNT(e2.emp_id) AS Direct_Reports
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.emp_id = e2.manager_id
GROUP BY e1.emp_name
ORDER BY COUNT(e2.emp_id) DESC, e1.emp_name ASC;



-- Find Employees Who Report to Managers with the Same Manager
-- Employee	Manager
-- Sarah	John
-- Mike		John
-- Alice	Sarah
-- Bob		Sarah
-- Jane		Mike
-- Carol	Mike

SELECT e1.emp_name AS Emp, e2.emp_name AS Mng
FROM employees2 e1
LEFT JOIN employees2 e2
ON e1.manager_id = e2.emp_id
WHERE e1.emp_name <> e2.emp_name;
