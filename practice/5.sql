CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    customer_id INT
);

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    visit_id INT,
    amount INT,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

INSERT INTO Visits (visit_id, customer_id)
VALUES 
(1, 23),
(2, 9),
(4, 30),
(5, 54),
(6, 96),
(7, 54),
(8, 54);

-- Insert data into Transactions table
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES 
(2, 5, 310),
(3, 5, 300),
(9, 5, 200),
(12, 1, 910),
(13, 2, 970);


-- Customer Who Visited but Did Not Make Any Transactions
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
-- Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
-- Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
-- Customer with id = 30 visited the mall once and did not make any transactions.
-- Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
-- Customer with id = 96 visited the mall once and did not make any transactions.
-- As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.


SELECT v.customer_id, COUNT(DISTINCT v.visit_id) AS count_no_trans, ts.visit_id
FROM visits v
LEFT JOIN transactions ts
ON v.visit_id = ts.visit_id
WHERE ts.visit_id IS NULL
GROUP BY v.customer_id, ts.visit_id;
