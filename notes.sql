==OPERATORS STARTS==
EXTRACT(MONTH FROM birth_date)

Is NULL

first_name SIMILAR TO 'M%' -> search for first name starts with M

first_name LIKE 'A_____' -> check starts with 'A' and 5 characters after it.

first_name SIMILAR TO '%m' -> first_name ends with m

'~' operator is used for comparision

'^' operator is used for checking the beginning of the string

first_name ~ '^Ma' -> Firstname starts with MA

'$' operator is used to check the end of the string

last_name ~ 'ez$' -> Lastname starts with 'ez'

'|' operator is used to check "or" condition

last_name ~ 'ez|son' -> Last name that ends with 'ez' or 'son'

'[]' operator is used to check if value is in range

last_name ~ '[w-z]' -> Last name that contains wxyz

==OPERATORS ENDS==

==KEYWORDS STARTS==

- MIN, MAX, AVG

- SUM, COUNT

- DISTINCT -> This will give you unique values

- EXTRACT(MONTH FROM purchasedate) -> This will give you month

- EXTRACT(DOW FROM purchasedate) -> This will give you day number 0 - Sunday To 6 - Saturday

- NOW() - INTERVAL '3 day' -> This will remove 3 days from today which gives last 3 days.

- STRING_AGG(DISTINCT products, ' - ') -> This will work in groupby clause to concat grouped columns into 1 string using '-' separator.

==KEYWORDS ENDS==


==VIEWS STARTS==

CREATE VIEW view_name AS
SELECT column1, column2 FROM table_name

==VIEWS ENDS==

==FUNCTIONS STARTS==

CREATE OR REPLACE FUNCTION fn_name(arg1 arg_type, arg2 arg_type)
RETURNS return_type|void AS
$body$
SELECT column1, column2 FROM table_name WHERE a = arg1 AND b = arg2
$body$
LANGUAGE SQL

- If we need to return one row of records from specific table, return type would be table.

Example:-
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

- If we need to return multiple rows of records from specific table, return type would be SETOF table.

Example:-
-- To return multiple row
CREATE OR REPLACE FUNCTION fn_emp_location(loc varchar)
RETURNS SETOF sales_person as 
$body$
	SELECT * from sales_person where state = loc;
$body$
LANGUAGE SQL;


SELECT (fn_name()).*;
SELECT (fn_name()).column_name;


SELECT (fn_emp_location('CA')).*;
SELECT first_name, last_name from fn_emp_location('CA');

--  FUNCTION FOR PSQL
CREATE OR REPLACE FUNCTION fn_name(arg1 arg_type, arg2 arg_type)
RETURNS return_type|void AS
$body$
DECLARE
	variable_name data_type
BEGIN
	-- Function logic
	RETURN variable_name
END
$body$
LANGUAGE plpgsql;



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


==FUNCTIONS ENDS==

==WINDOW FUNCTION STARTS==

- RANK

- DENSE_RANK

- ROW_NUMBER

- LAG

- LEAD

- FIRST_VALUE

- LAST_VALUE -> *NOTE:- We cant use this func without frames

- NTH_VALUE

- NTILE

- CUME_DIST -> Current row/total rows

- PERCENT_RANK -> Current Row - 1 / Total rows - 1



=> Windows means creating subset of whole table based on different columns.

=> Frames means to create frames in specific window or partition.
	- DEFAULT FRAME CLAUSE (If we do not mention it, this one applies by 		default)
		-> RANGE between unbounded preceding and current row

		-> RANGE between unbounded preceding and unbounded following

		-> RANGE between 2 preceding and 2 following

		-> ROWS between unbounded preceding and unbounded following




-- Fetch top 2 employees with highest salary from each department. (If 2 employess have same salary, show both of them)
SELECT emp_id, dept_name, emp_name, salary
FROM (
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) as rnk
	FROM employee5
) x WHERE x.rnk < 3;


-- NOTE: In lag and lead, we need to provide the argument! 2nd and 3rd arguments are options, 2 is for how many values we need to skip, 3 is for default value if null is found
SELECT *,
LAG(salary, 1, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) as lag
FROM employee5;

SELECT *,
LEAD(salary, 2, 0) OVER(PARTITION BY dept_name ORDER BY emp_id)
FROM employee5;


-- Fetch to display if current employees salary is higher, lower or equal to previous employee.
SELECT *,
CASE 
	 WHEN LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) IS NULL THEN 'No previous employee found!!'
	 WHEN e.salary > LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Higher than previos employee'
	 WHEN e.salary < LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Lower than previos employee'
	 WHEN e.salary = LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Same as previos employee'
END sal_range
FROM employee5 e;



-- FIRST_VALUE window function. -> It takes one argument to display which product is most expensive in category.
SELECT *,
FIRST_VALUE(product_name) OVER(PARTITION BY product_category ORDER BY price DESC) as most_exp_product
FROM product1;


-- In RANGE CALUSE, it mainly shows main difference in duplicate values. Range will consider all duplicate data till last row.
SELECT *,
LAST_VALUE(product_name) 
	OVER(
		PARTITION BY product_category ORDER BY price DESC
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as least_exp_product
FROM product1
WHERE product_category = 'Phone';

-- In ROWS CALUSE, it mainly shows main deifference in duplicate values. ROWS will only stick to it's current row.
SELECT *,
LAST_VALUE(product_name) 
	OVER(
		PARTITION BY product_category ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as least_exp_product
FROM product1
WHERE product_category = 'Phone';



SELECT *,
FIRST_VALUE(product_name) OVER w as most_exp_product,
LAST_VALUE(product_name) OVER w as least_exp_product,
NTH_VALUE(product_name, 2) OVER w as second_most_expensive_product
FROM product1
WINDOW w as (
	PARTITION BY product_category ORDER BY price DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);




/*
-- CUME_DIST -> Cumulative distribution
- Write a query to fetch all products which constitus 30% of whole data
FOR REFERENCE -> https://youtu.be/zAmJPdZu8Rg?t=2282&si=84Qw9URnpZZd809t

Formula to calculate CUME_DIST -> Current row/total rows
*/

SELECT product_name, x.cume_dist_per||'%'
FROM (
	SELECT *,
	ROUND(CUME_DIST() OVER(ORDER BY price DESC)::NUMERIC * 100, 2) AS cume_dist_per
	FROM product1) AS x
WHERE x.cume_dist_per <= 30



/*
-- PERCENT_RANK.
To identify how much 'Galaxy Z Fold 3' is expensive when compared to all products.
Fomula -> Current Row - 1 / Total rows - 1


From below query, it means 'Galaxy Z Fold 3' is 80.77% expensive than other products
*/


SELECT product_name, x.percent_per_rank
FROM (
	SELECT *,
	ROUND(PERCENT_RANK() OVER(ORDER BY price)::NUMERIC * 100, 2) AS percent_per_rank
	FROM product1) as x
WHERE x.product_name = 'Galaxy Z Fold 3';



==WINDOW FUNCTION ENDS==
