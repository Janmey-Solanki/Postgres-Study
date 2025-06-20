SELECT name , supplier, price
FROM product LEFT JOIN item
ON product.id = item.product_id
ORDER BY name;


-- In cross join, we don't need ON condition.
SELECT sales_order_id, quantity, product_id
FROM item CROSS JOIN sales_item
ORDER BY sales_order_id;



-- Union are another way to join tables. Union combine result of 2 or more select statements. 
-- NOTE:- Each result must contains same number of columns and same data types.
SELECT first_name, last_name, street, city, zip, birth_date
FROM customer WHERE EXTRACT(MONTH FROM birth_date) = 12
UNION
SELECT first_name, last_name, street, city, zip, birth_date
FROM sales_person WHERE EXTRACT(MONTH FROM birth_date) = 12
ORDER BY birth_date;


-- IS NOT expression
SELECT product_id, price
FROM item
WHERE price IS NOT NULL;


-- Below example search for first_name starts with 'M'
SELECT first_name, last_name
FROM customer
WHERE first_name SIMILAR TO 'M%';

-- This check starts with 'A' and 5 characters after it.
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'A_____';


-- Firstname begins with 'D' OR lastname ends with an 'n'
SELECT first_name, last_name
FROM customer
WHERE first_name SIMILAR TO 'D%' OR last_name SIMILAR TO '%n';

-- Firstname starts with MA
-- '~' is used for comparision operator
-- '^' is used to check the Beginning of the string.
SELECT first_name, last_name
FROM customer
WHERE first_name ~ '^Ma';

-- Lastname starts with 'ez'
-- $ is used to check the end of the string
SELECT first_name, last_name
FROM customer
WHERE last_name ~ 'ez$';

-- Last name that ends with 'ez' or 'son'
SELECT first_name, last_name
FROM customer
WHERE last_name ~ 'ez|son';

-- Last name that contains wxyz
SELECT first_name, last_name
FROM customer
WHERE last_name ~ '[w-z]';



/*
GROUP BY STARTS
*/

-- How many total customer have their birthdate in that month.
-- FOR COUNT, GROUP BY is necessary.
SELECT EXTRACT(MONTH FROM birth_date) AS MONTH, COUNT(*) AS AMOUNT
FROM customer
GROUP BY MONTH
ORDER BY MONTH;

-- HAVING, months if more than 1 person has birthday in that month.
-- HAVING is used to check condition in count clause.
SELECT EXTRACT(MONTH FROM birth_date) AS MONTH, COUNT(*) AS AMOUNT
FROM customer
GROUP BY MONTH
HAVING COUNT(*) > 1
ORDER BY MONTH;

/*
GROUP BY ENDS
*/

/*
	AGGREGATE functions starts
*/

SELECT SUM(price)
from item;


SELECT COUNT(*) as ITEMS, SUM(price) AS VALUE, ROUND(AVG(price), 3) as AVERAGE, MIN(price) AS MINIMUM, MAX(price) as MAXIMUM
FROM item;


/*
	AGGREGATE functions ends
*/



/*
	VIEWS starts
*/
-- View are select statements and their results are stored in db.
-- Whenever, the data is updated, it also updates in view except for TOTAL and concat
-- Best practice to not use aggregate funcations, group by,CONCAT, distinct, etc... in creating views
CREATE VIEW purchase_order_overview AS
SELECT sales_order.purchase_order_number, customer.company, sales_item.quantity, product.supplier, product.name, item.price,
(sales_item.quantity * item.price) AS TOTAL,
CONCAT(sales_person.first_name, ' ', sales_person.last_name) AS Salesperson
FROM sales_order
JOIN sales_item
ON sales_item.sales_order_id = sales_order.id
JOIN item
ON item.id = sales_item.item_id
JOIN customer
ON sales_order.cust_id = customer.id
JOIN product
ON product.id = item.product_id
JOIN sales_person
ON sales_person.id= sales_order.sales_person_id
ORDER BY purchase_order_number;

CREATE VIEW purchase_order_overview_2 AS
SELECT sales_order.purchase_order_number, customer.company, sales_item.quantity, product.supplier, product.name, item.price,
CONCAT(sales_person.first_name, ' ', sales_person.last_name) AS Salesperson
FROM sales_order
JOIN sales_item
ON sales_item.sales_order_id = sales_order.id
JOIN item
ON item.id = sales_item.item_id
JOIN customer
ON sales_order.cust_id = customer.id
JOIN product
ON product.id = item.product_id
JOIN sales_person
ON sales_person.id= sales_order.sales_person_id
ORDER BY purchase_order_number;

SELECT * FROM purchase_order_overview;
SELECT *, (quantity * price) AS Total from purchase_order_overview_2;

DROP VIEW purchase_order_overview_2;

/*
	VIEWS ends
*/


/*
	Create SQL functions starts
*/
CREATE OR REPLACE FUNCTION funcation_name() RETRUNS void as
'
-- SQL commands
'
LANGUAGE SQL

-- WE create a funcation which receive 2 values and add them

-- You can use "'" or "$$" or "$body$"
CREATE OR REPLACE FUNCTION fn_add_ints(int, int) 
RETURNS int as
$body$
SELECT $1 + $2
$body$
LANGUAGE SQL


DROP FUNCTION fn_add_ints(int, int)
SELECT fn_add_ints(4,5)


CREATE OR REPLACE FUNCTION fn_updt_emp_state()
RETURNS void as 
$body$
	UPDATE sales_person
	SET state = 'PA'
	WHERE state IS NULL;
$body$
LANGUAGE SQL

SELECT fn_updt_emp_state()

CREATE OR REPLACE FUNCTION fn_max_product_price()
RETURNS numeric as 
$body$
	SELECT MAX(price)
	FROM item
$body$
LANGUAGE SQL


DROP FUNCTION fn_max_product_price()
SELECT fn_max_product_price()


CREATE OR REPLACE FUNCTION fn_get_value_inventory()
RETURNS numeric AS
$body$
	SELECT SUM(price)
	FROM item
$body$
LANGUAGE SQL

SELECT fn_get_value_inventory()

CREATE OR REPLACE FUNCTION fn_total_customer()
RETURNS numeric AS
$body$
	SELECT COUNT(*)
	FROM customer
$body$
LANGUAGE SQL

SELECT fn_total_customer()

CREATE OR REPLACE FUNCTION fn_get_customer_num_from_state(state_name char(2))
RETURNS numeric AS
$body$
	SELECT COUNT(*)
	FROM customer
	WHERE state = state_name;
$body$
LANGUAGE SQL

SELECT fn_get_customer_num_from_state('TX');


-- Here, we have used NATURAL JOIN
SELECT COUNT(*)
FROM sales_order
NATURAL JOIN customer
WHERE customer.first_name = 'Christopher' and customer.last_name = 'Jones';






CREATE OR REPLACE FUNCTION fn_get_number_orders_from_customer(fname varchar, lname varchar)
RETURNS numeric AS
$body$
	SELECT COUNT(*)
	FROM sales_order
	NATURAL JOIN customer
	WHERE customer.first_name = fname and customer.last_name = lname;
	-- WHERE customer.first_name = $1 and customer.last_name = $2;
$body$
LANGUAGE SQL

SELECT fn_get_number_orders_from_customer('Christopher', 'Jones');

-- To return single row
CREATE OR REPLACE FUNCTION fn_get_last_order()
RETURNS sales_order as
$body$
	SELECT *
	FROM sales_order
	ORDER BY time_order_taken DESC
	LIMIT 1
$body$
LANGUAGE SQL

-- This syntax will give details in nice table format
SELECT (fn_get_last_order()).*;
SELECT (fn_get_last_order()).time_order_taken;


-- To return multiple rows
CREATE OR REPLACE FUNCTION fn_emp_location(loc varchar)
RETURNS SETOF sales_person as 
$body$
	SELECT * from sales_person where state = loc;
$body$
LANGUAGE SQL;


DROP FUNCTION fn_emp_location();
SELECT (fn_emp_location('CA')).*;

-- To view specific rows
SELECT first_name, last_name from fn_emp_location('CA');


/*
	Create SQL functions ends
*/



/*
	Create PG-SQL functions start
*/

CREATE OR REPLACE FUNCATION fn()
RETURNS void AS
$body$
BEGIN
-- SQL queries or statements
END
$body$
LANGUAGE plpqsql


SELECT item.price
FROM item
NATURAL JOIN product
WHERE product.name = 'Grandview';

CREATE OR REPLACE FUNCTION fn_get_product_price(product_name VARCHAR)
RETURNS numeric AS
$body$
DECLARE
    product_price numeric;
BEGIN
    SELECT item.price INTO product_price
    FROM item
    NATURAL JOIN product
    WHERE product.name = product_name;

    RETURN product_price;
END;
$body$
LANGUAGE plpgsql;
	
SELECT fn_get_product_price('Grandview');




CREATE OR REPLACE FUNCTION fn_get_sum(v1 int, v2 int)
RETURNS int AS
$body$
DECLARE
	ans int;
BEGIN
	ans:= v1 + v2;
	RETURN ans;
END
$body$
LANGUAGE plpgsql

SELECT fn_get_sum(2, 5);

CREATE OR REPLACE FUNCTION fn_get_random(min_val int, max_val int)
RETURNS int AS
$body$
DECLARE
	rand int;
BEGIN
	SELECT random()*(max_val - min_val) + min_val INTO rand;
	RETURN rand;
END
$body$
LANGUAGE plpgsql;

SELECT fn_get_random(2,10)


/*
	Create PG-SQL functions end
*/
