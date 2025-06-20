SELECT * FROM duplicate_emails;


TRUNCATE TABLE duplicate_emails;


INSERT INTO duplicate_emails (id, email)
VALUES 
(1, 'john@example.com'),
(2, 'bob@example.com'),
(3, 'john@example.com')




SELECT DISTINCT email
FROM duplicate_emails;


SELECT MIN(id) id
FROM duplicate_emails
GROUP BY email
ORDER BY id;


DELETE FROM Person WHERE id NOT IN (SELECT MIN(id) id
FROM Person
GROUP BY email
ORDER BY id
)




CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT
);


CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT
);
-- Insert data into Prices table
INSERT INTO Prices (product_id, start_date, end_date, price) VALUES
(1, '2019-02-17', '2019-02-28', 5),
(1, '2019-03-01', '2019-03-22', 20),
(2, '2019-02-01', '2019-02-20', 15),
(2, '2019-02-21', '2019-03-31', 30);


-- Insert data into UnitsSold table
INSERT INTO UnitsSold (product_id, purchase_date, units) VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);


TRUNCATE TABLE prices, unitssold;
INSERT INTO Prices (product_id, start_date, end_date, price) VALUES
(1, '2019-02-17', '2019-02-28', 10),
(2, '2019-03-01', '2019-03-22', 20);






-- To return values into decimal, we have used round function.


/*


Version 1: Using USING(product_id) and WHERE clause
sql
Copy
Edit
FROM prices
LEFT JOIN unitssold
USING(product_id)
WHERE purchase_date BETWEEN start_date AND end_date
What it does:
This first joins the tables using only product_id.


Then, after the join, it filters the result using the condition purchase_date BETWEEN start_date AND end_date.


⚠️ Important:
This effectively turns your LEFT JOIN into an INNER JOIN for rows where the purchase_date doesn't fall between start_date and end_date, because those rows are filtered out in the WHERE clause.


Any NULL from the right side (unitssold) is eliminated.


🔹 Version 2: Using ON clause for both product_id and date range
sql
Copy
Edit
FROM prices p
LEFT JOIN unitssold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
What it does:
Joins on both product_id and purchase_date BETWEEN start_date AND end_date as part of the join condition.


This keeps all records from the prices table and joins only matching records from unitssold based on both conditions.


✅ Preserves LEFT JOIN
If there's no match on purchase_date, the result from unitssold will be NULL, but the row from prices will still appear.*/
SELECT p.product_id, COALESCE(ROUND(SUM(units * price) /SUM(units)::numeric, 2), 0) average_price
FROM prices p
LEFT JOIN unitssold u
USING(product_id)
WHERE purchase_date BETWEEN start_date AND end_date
GROUP BY p.product_id;




SELECT p.product_id, COALESCE(ROUND(SUM(price*units) / sum(units)::numeric,2),0) AS average_price
FROM prices p
LEFT JOIN unitssold u 
ON p.product_id = u.product_id AND purchase_date BETWEEN start_date AND end_date
GROUP BY p.product_id


-- NOTE FOR ABOVE QUESTION!
-- If we need to apply multiple conditions while joining table don't use "using" function.








CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);


CREATE TABLE Subjects (
    subject_name VARCHAR(100) PRIMARY KEY
);


CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_name) REFERENCES Subjects(subject_name)
);
-- Insert data into Students table
INSERT INTO Students (student_id, student_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(13, 'John'),
(6, 'Alex');


-- Insert data into Subjects table
INSERT INTO Subjects (subject_name) VALUES
('Math'),
('Physics'),
('Programming');


-- Insert data into Examinations table
INSERT INTO Examinations (student_id, subject_name) VALUES
(1, 'Math'),
(1, 'Physics'),
(1, 'Programming'),
(2, 'Programming'),
(1, 'Physics'),
(1, 'Math'),
(13, 'Math'),
(13, 'Programming'),
(13, 'Physics'),
(2, 'Math'),
(1, 'Math');


-- This is example of cross and left join
SELECT st.student_id, st.student_name, sb.subject_name, COUNT(ex.subject_name) AS abc
FROM students st
CROSS JOIN subjects sb
LEFT JOIN examinations ex
ON st.student_id = ex.student_id AND sb.subject_name = ex.subject_name
GROUP BY st.student_id, st.student_name, sb.subject_name;




CREATE TABLE Tweets (
    tweet_id INT PRIMARY KEY,
    content VARCHAR(280)
);
INSERT INTO Tweets (tweet_id, content) VALUES
(1, 'Let us Code'),
(2, 'More than fifteen chars are here!');


SELECT tweet_id
FROM tweets
WHERE length(content) > 15;

