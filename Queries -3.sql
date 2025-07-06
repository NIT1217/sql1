use learn2;

SELECT *
from titanic;

-- Built in functions
-- String functions
-- Extract the first letter of passenger names;
SELECT Name, LEFT(Name, 1) as first_letter
from titanic;

-- Convert the passenger name case
SELECT Name, upper(Name)
from titanic;

-- Convert the name to lower case
SELECT Name, lower(Name)
from titanic;

-- Replace Mr. with Sir
select name, replace(name, 'Mr.', 'Sir')
from titanic;
-- Extract the last name >> Braund
select name,
substring_index(name, ',', 1) as last_name
from titanic;
-- Extract the first name >> Mr.Own Harris
 select name,
substring_index(name, ',', -1) as first_name
from titanic;

-- Aggregate 
-- Count the total number of passengers
use learn2;
select count(*)
from titanic;

-- Find the average fare paid
select avg(fare)
from titanic;

-- Find the variance of fare
select VARIANCE(fare)
from titanic;

-- Find max
select max(fare)
from titanic;

-- Find min
select min(fare)
from titanic;

select *
from titanic;
-- Round the fare column
select fare, round(fare, 2)
from titanic;

-- Replace missing age value with average
-- in pandas -- df.age.fillna(df.age.mean())
SELECT NAME, coalesce(Age, (select avg(age) from titanic))
from titanic;
-- coalesce returns the first non-null values in a list of column or values

-- Find the length of passenger names
select name, length(name)
from titanic;
-- Find the square root of fare
select name, fare, sqrt(fare)
from titanic;
-- Round age to nearest integer
select name, age, round(age) 
from titanic;

-- categroize passenger on age
-- python, if age< 18 then 'daru nhi milega'
-- elif 18<age<60 print("pee le beta")
-- else "budhe ho gaye ho mar jaoge"

select name, age,
case
when age < 18 then 'daaru mat peeyo'
when age between 18 and 60 then 'pee le beta jawani h'
ELSE 'Budhau mat piyo'
end as age_group
from titanic; 


-- Classify passenger based on fare
-- if fare is less 10 then low, 10 and 50 medium else high
Select name, fare,
case
when Fare < 10 Then 'Low'
when fare between 10 and 50 then 'Medium'
else 'High'
end as fare_category
from titanic;

-- Groupby
-- split>>apply>>combine

-- How many passengers survived in each class
Select Pclass, Count(Pclass) 
from titanic
group by Pclass;

-- Find the total fare collected for each class
select Pclass, SUM(Fare) as total_fare
from titanic
group by Pclass
order by total_fare;


-- Find the survival rate for each gender
select sex, AVG(Survived) as survival_rate
from titanic
group by Sex;

-- find the avg age of survivors vs non survivors
select Survived, Avg(age)
from titanic group by Survived;


-- Find class with most survivoirs
SELECT Pclass, Count(*) as survivor_count
from titanic
where Survived = 1
Group by Pclass
order by survivor_count desc limit 1;

-- Find the gender class combination with highest survival rate
SELECT Sex, Pclass, AVG(Survived) AS survival_rate 
FROM titanic 
GROUP BY Sex, Pclass ORDER BY survival_rate DESC;

-- Find the average fare paid by each passenger class(pclass) and
-- embarkation point (embarked) but include only groups where:
-- The total no of passengers in that group is more than 20
-- consider only passenger who were adults(age>=18) and paid
-- more than 10
select 
Pclass,
Embarked,
Avg(Fare) as avg_fare,
COUNT(*) as passenger_count
from titanic
where age >= 18 and fare > 10
GROUP BY Pclass, Embarked
HAVING Count(*) > 20
ORDER BY avg_fare desc;
-- Normal select statement>> where
-- groupby filter >> having, having is where for groupby

use employeedb;
select *
from employees;

-- All the employees joined before 01-01-2022
select emp_name
from employees
where hire_date < '2022-01-01';

-- sql date time
SELECT CURDATE() as curr_date;

SELECT CURTIME() as curr_time;

-- current date and time
select now() as current_datetime;

-- Extract month, year, day fro date column
SELECT 
YEAR('2025-03-26') as year,
MONTH('2025-03-26') as month,
DAY('2025-03-26') as day;

SELECT 
dayname('2025-03-26');

SELECT DAYOFWEEK('2025-03-26');

-- GET THE FULL DATE IN HUMAN READABLE FORMAT
SELECT DATE_FORMAT('2025-03-22', '%W, %D %M %Y') AS formatted_date;

-- Find the date 7 days after and 7 days before '2024-10-15'
select date_add('2024-10-15', INTERVAL 7 DAY) as after_7_days,
date_sub('2024-10-15', INTERVAL 7 DAY) as before_7_days;

--  Calculate the number of days between '2024-10-15' and '2024-11-20'.
SELECT DATEDIFF('2024-11-20', '2024-10-15') AS days_difference;

-- Find last day of a given mont
SELECT LAST_DAY('2024-10-01') AS last_day_of_month;

--  Find the weekday for '2025-03-22'.
SELECT DAYNAME('2025-03-22') AS weekday_name;

-- String to date format
-- Convert '22-March-2025' to a proper MySQL DATE format.
SELECT STR_TO_DATE('22-March-2025', '%d-%M-%Y') AS formatted_date;

-- difference between two time stamps
--  Calculate the difference in hours, minutes, and seconds between '2025-03-22 10:00:00' and '2025-03-22 14:30:45'.
SELECT TIMEDIFF('2025-03-22 14:30:45', '2025-03-22 10:00:00') AS time_difference;

-- hour, mins, sec
SELECT 
    HOUR('2025-03-22 14:30:45') AS hour_part,
    MINUTE('2025-03-22 14:30:45') AS minute_part,
    SECOND('2025-03-22 14:30:45') AS second_part;
-- Find the quarter for '2025-03-22'.
SELECT QUARTER('2025-03-22') AS quarter_part;

-- Find the Next Monday After a Given Date
SELECT DATE_ADD('2025-03-22', INTERVAL (7 - WEEKDAY('2025-03-22')) DAY) AS next_monday;

-- Age from dob
SELECT TIMESTAMPDIFF(YEAR, '1995-06-15', CURDATE()) AS age;

SELECT DATE_FORMAT('2025-03-22', '%D %M, %Y') AS formatted_date;




