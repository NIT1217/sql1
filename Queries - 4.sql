-- Numeric functions ullows us to perform mathematical calculation on numeric data types
use empdb;
select * from employee;

-- Find the abolute difference between an employee's salary and average salary
select *, ABS(salary - (select avg(salary) from employee)) as salary_difference
from employee;

select avg(salary) from employee;

-- ABS converts to a positive no

-- CEIL >> ROUNDS UP TO THE NEXT WHOLE NO >> 7.4>> 8
-- FLOOR >> roeunds down to the previous whole no>> 7.4>>7

-- Round the employees salary to nearest thousand
select emp_id, employee_name, salary/917,
ceil(salary/917) as rounded_up_ceil,
floor(salary/917) as rounded_down_floor
from employee;

-- Round>> rounding upto nearest decimal place
select emp_id, employee_name, salary/917,
round(salary/917, 2) as rounded_salary
from employee;

-- MOD >> remainder calculation
-- check which employees have salary that are multiple of 5000
select emp_id, employee_name, salary,
mod(salary, 5000) as remainder
from employee
where mod(salary, 5000) = 0;

-- calculate tyhe square of each employee salary
SELECT emp_id, employee_name, salary,
       POWER(salary, 2) AS squared_salary
FROM employee;

-- calculate the square root of each employee salary
SELECT emp_id, employee_name, salary,
       SQRT(salary) AS salary_sqrt
FROM employee;

-- FIND THE NATURAL AND BASE-10 LOGRITHM OF SALARY
SELECT emp_id, employee_name, salary,
       LOG(salary) AS natural_log,
       LOG10(salary) AS base_10_log
FROM employee;

-- Check whether salaries are positive, negative, or zero (theoretically).
-- SIGN
SELECT emp_id, employee_name, salary,
       SIGN(salary) AS salary_sign
FROM employee;

-- Truncate >> to remove decimal places
SELECT emp_id, employee_name, salary/917,
       TRUNCATE(salary/917, 0) AS truncated_salary
FROM employee;

-- Generate random numbers
-- Generate a random bonuspercentage between 1% and 10% for each employee
-- Rand()
select emp_id, employee_name, salary, RAND(),
salary * (1+(RAND()*0.1)) AS random_bonus_salary
from employee;

-- window function

select *
from employee;

-- For each department what is average salary
select dept_name, avg(salary)
from employee
group by dept_name;

-- if you want employee_name in tyhe above result, it will throw error

select *,
AVG(salary) OVER()
FROM employee;

select *,
AVG(salary) OVER(partition by dept_name) -- partition by is sub group 
FROM employee;

-- over is used to define window specification

-- Rank, dense rank, row_number
-- find salary in descending order
select emp_id, employee_name, dept_name, salary
from employee
order by salary desc;

-- Rank employees based on salary
select emp_id, employee_name, dept_name, salary,
RANK() OVER(order by salary desc) as rank_position
from employee;
-- Assigns rank, skipping numbers if salaries are tied
-- dense rank
select emp_id, employee_name, dept_name, salary,
DENSE_RANK() OVER(order by salary desc) as dense_rank_position
from employee;
-- Unlike Rank(), does not skip ranks for duplicate enteries

-- row number
select emp_id, employee_name, dept_name, salary,
ROW_NUMBER() OVER(order by salary desc) as row_number_position
from employee;
-- Always unique no tie

SELECT emp_id, employee_name, dept_name, salary, 
       RANK() OVER (ORDER BY salary DESC) AS rank_position,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_position,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number_position
FROM employee;

-- Find top 3 highest paid employees in each department
select * from (select emp_id, employee_name, dept_name, salary,
RANK() OVER(PARTITION BY dept_name ORDER BY SALARY desc) as dept_rank
from employee) t
where t.dept_rank < 4;

-- Get the highest-paid employee per department
select emp_id, employee_name, dept_name, salary,
FIRST_VALUE(EMPLOYEE_NAME) OVER(PARTITION BY dept_name ORDER BY SALARY desc) as highest_salary
from employee;

-- Get the lowest paid employee per departement
SELECT emp_id, employee_name, dept_name, salary, 
       LAST_VALUE(employee_name) OVER (PARTITION BY dept_name ORDER BY salary DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_paid
FROM employee;

-- Get the third highest salary in each department
select emp_id, employee_name, dept_name, salary,
NTH_VALUE(EMPLOYEE_NAME, 3) OVER(PARTITION BY dept_name ORDER BY SALARY desc) as third_value
from employee;

-- LAG
-- compare each employees salary with previous employee in each department
select emp_id, employee_name, dept_name, salary,
LAG(salary) OVER (PARTITION BY dept_name ORDER BY salary DESC) as previous_salary
from employee;

-- LEAD
SELECT emp_id, employee_name, dept_name, salary, 
       LEAD(salary) OVER (PARTITION BY dept_name ORDER BY salary DESC) AS next_salary
FROM employee;

-- use case>> very important to compare any value with previous or next value
-- time series data

-- common table expression
-- Find top 3 highest paid employees in each department
select * from (select emp_id, employee_name, dept_name, salary,
RANK() OVER(PARTITION BY dept_name ORDER BY SALARY desc) as dept_rank
from employee) t
where t.dept_rank < 4;

with ranked as (select emp_id, employee_name, dept_name, salary,
RANK() OVER(PARTITION BY dept_name ORDER BY SALARY desc) as dept_rank
from employee)
select * from ranked where dept_rank < 4;

-- CTE Common table expression
-- A common table expression is a temprary result set that you can reference within a sql query
-- It improved the code readability and avoid subquery repetition

-- with cte_name as(
-- your query
-- )
-- select * from cte_name

-- To understand the difference
-- find employees with salary above average
select emp_id, employee_name, salary
from employee
where salary > (select avg(salary) from employee);

with avg_salary as (
select avg(salary) as avg_sal from employee)
select emp_id, employee_name, salary
from employee
where salary > (select avg_sal from avg_salary);




