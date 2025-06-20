CREATE TABLE employees (
  EMPLOYEE_ID numeric(6) NOT NULL primary key,
  FIRST_NAME varchar(20) DEFAULT NULL,
  LAST_NAME varchar(25) NOT NULL,
  EMAIL varchar(25) NOT NULL,
  PHONE_NUMBER varchar(20) DEFAULT NULL,
  HIRE_DATE date NOT NULL,
  JOB_ID varchar(10) NOT NULL,
  SALARY decimal(8,2) DEFAULT NULL,
  COMMISSION_PCT decimal(2,2) DEFAULT NULL,
  MANAGER_ID numeric(6) DEFAULT NULL,
  DEPARTMENT_ID numeric(4) DEFAULT NULL
);


SELECT * FROM employees;

-- first_name and last_name of the employees who are working as 'ST_CLERK', 'SA_MAN' or 'IT_PROG' and drawing a salary more than 3000.
SELECT * FROM public.employees
WHERE job_id in ('ST_CLERK', 'SA_MAN', 'IT_PROG') AND salary > 3000
ORDER BY employee_id ASC 


-- first_name and last_name, job_id, department_id of the employees who are working in the department no 10 or 20 or 40 
-- or employees working as 'ST_CLERK', 'SA_MAN' or 'IT_PROG'.
SELECT last_name, job_id, department_id
FROM employees
WHERE department_id IN (10, 20, 40) OR job_id IN ('ST_CLERK', 'SA_MAN', 'IT_PROG')
ORDER BY employee_id;


-- get the first_name and last_name of the employees whose first_name are exactly five characters in length.
SELECT employee_id, first_name, last_name
FROM employees
-- WHERE first_name LIKE '_____'
WHERE length(first_name) = 5
ORDER BY employee_id;


--  first_name and last_name of the employees who are not working as 'AC_MGR'
SELECT employee_id, first_name, last_name
FROM employees
-- WHERE job_id <> 'AC_MGR'
WHERE job_id NOT IN ('AC_MGR')
ORDER BY employee_id;


-- first_name and last_name of the employees who are not working as 'ST_CLERK', 'SA_MAN' or 'IT_PROG'.
SELECT employee_id, first_name, last_name, job_id
FROM employees
WHERE job_id NOT IN ('ST_CLERK', 'SA_MAN', 'IT_PROG')
ORDER BY employee_id;

-- get the maximum salary being paid to 'ST_CLERK'.
SELECT employee_id, salary
FROM employees
WHERE job_id='ST_CLERK'
ORDER BY salary DESC
LIMIT 1;

-- OR
SELECT MAX(salary) AS max_salary
FROM employees
WHERE department_id=50;

-- get employee details with maximum salary being paid to 'ST_CLERK'.
-- Solve this question using JOIN functions. (IMP)



-- get the maximum salary being paid to department ID
SELECT department_id, MAX(salary) as max_salary
FROM employees
GROUP BY department_id;

-- Minimum salary being paid to SA_MAN
SELECT MIN(salary) as min_salary
FROM employees
WHERE job_id = 'SA_MAN'

-- Salary drawn by SA_MAN working in the department number 80
SELECT SUM(salary) as total_salary
FROM employees
WHERE department_id = 80;


-- Department number with more than 10 employees in each department
SELECT department_id, COUNT(employee_id) as emp
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) > 10;


-- jobs_id with total salary for those job-ids whose total salary is more than 50000.
/*
  	JOB_ID	Total Salary of Designation
	ST_CLERK	55700
	SA_MAN	61000
	SA_REP	250500
*/
SELECT job_id, SUM(salary) as total_salary
FROM employees
GROUP BY job_id
HAVING SUM(salary) > 50000;


-- query to get the designations (jobs) along with the total number of employees in each designation. The output should contain only those jobs with more than three employees.
SELECT job_id, COUNT(employee_id) as total_employees
FROM employees
GROUP BY job_id
HAVING COUNT(employee_id) > 3;

