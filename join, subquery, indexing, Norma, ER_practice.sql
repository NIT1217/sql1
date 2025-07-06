
create database learn;
use learn;

-- Drop tables if they already exist
DROP TABLE IF EXISTS employees, departments;

-- Create Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    manager_id INT
);

-- Insert Departments Data
INSERT INTO departments (dept_id, dept_name, manager_id) VALUES
(1, 'Technology', 201),
(2, 'Human Resources', 202),
(3, 'Marketing', 203),
(4, 'Finance', 204);

-- Create Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Insert Employees Data
INSERT INTO employees (emp_id, name, dept_id, salary) VALUES
(101, 'Amit Sharma', 1, 80000),
(102, 'Priya Singh', 2, 60000),
(103, 'Raj Patel', 1, 75000),
(104, 'Sneha Verma', NULL, 50000),
(105, 'Kunal Joshi', 3, 70000),
(106, 'Ritika Iyer', 4, 65000),
(107, 'Aditya Mehra', NULL, 45000);

select * from employees;
select * from departments;

-- Retrieve employee names along with their department names
-- In the above question by default it means you are not interested in the rows with dept_id null
-- common dept_id infromation has to be retrieved from both the table as not specifically told

-- inner
select *
from employees
inner join departments on employees.dept_id = departments.dept_id;

select *
from employees
join departments on employees.dept_id = departments.dept_id;
-- by default inner join gets executed


select employees.emp_id, employees.name, employees.dept_id, employees.salary, departments.dept_name
from employees
join departments on employees.dept_id = departments.dept_id;

select e.emp_id, e.name, e.dept_id, e.salary, d.dept_name
from employees e
join departments d on e.dept_id = d.dept_id;

select e.*, d.dept_name
from employees e
join departments d on e.dept_id = d.dept_id;

-- left
-- Get all employees, including those without departments
SELECT e.name AS employee_name,e.salary, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- right
-- Show all departements even if no employee is assigned to them
select e.name, d.dept_name
from employees e
right join departments d on e.dept_id = d.dept_id;

-- Get all the employees and departments even if no match exists
-- full outer join

-- My sql doesnt support full outer join

SELECT e.name AS employee_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id

UNION ALL

SELECT e.name AS employee_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Add manager_id column
ALTER TABLE employees ADD manager_id INT;

-- Update data with manager IDs (some dummy mappings)
UPDATE employees SET manager_id = 101 WHERE emp_id IN (102, 103);
UPDATE employees SET manager_id = 105 WHERE emp_id IN (104, 106);

select * from employees;

-- Get employee names and their manager names
select e.name as employee_name, m.name as manager_name
from employees e
left join employees m on e.manager_id = m.emp_id;

-- In problemn statement where hierarcy has to be captured use self join

-- show names of employees who work in the Technology department
select e.name as employee_name
from employees e
join departments d on e.dept_id = d.dept_id
where d.dept_name = 'Technology';

-- find the total salary expense per department
select d.dept_name, sum(e.salary) as total_salary
from employees e
join departments d on e.dept_id = d.dept_id
group by d.dept_name;


-- Drop if exists
DROP TABLE IF EXISTS enrollments, students, courses;

-- Create Students Table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO students (student_id, student_name, city) VALUES
(1, 'Rahul Khanna', 'Mumbai'),
(2, 'Sneha Rao', 'Bangalore'),
(3, 'Arjun Mehta', 'Delhi'),
(4, 'Pooja Desai', 'Ahmedabad'),
(5, 'Karan Malhotra', 'Pune');

-- Create Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    instructor VARCHAR(50)
);

INSERT INTO courses (course_id, course_name, instructor) VALUES
(101, 'Data Science', 'Dr. Raghav'),
(102, 'Web Development', 'Ms. Asha'),
(103, 'Machine Learning', 'Dr. Nikhil'),
(104, 'Cybersecurity', 'Mr. Prakash');

-- Create Enrollments Table (Many-to-Many relationship)
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    score INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO enrollments (student_id, course_id, score) VALUES
(1, 101, 85),
(1, 102, 78),
(2, 101, 88),
(3, 103, 90),
(4, 102, 76),
(5, 104, 92),
(2, 104, NULL); -- Sneha hasn't been graded yet


select * from students;
select * from courses;
select * from enrollments;

-- Get students with the courses they are enolled in and their scores
select s.student_name, c.course_name, e.score
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id;

-- list students who are not enrolled in the course
SELECT s.student_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.course_id IS NULL;

-- List courses that have no enrolled students
SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;

-- For each course, show the total no of enrolled students and their average score
SELECT c.course_name, COUNT(e.student_id) AS total_students,
       ROUND(AVG(e.score), 2) AS avg_score
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Show student names and the number of courses they are enrolled in.
SELECT s.student_name, COUNT(e.course_id) AS num_courses
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_name;

--  For each instructor, list the number of students they are teaching.
SELECT c.instructor, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.instructor;

-- Find students who are enrolled in both "Data Science" and "Web Development".
SELECT s.student_name
FROM students s
JOIN enrollments e1 ON s.student_id = e1.student_id
JOIN courses c1 ON e1.course_id = c1.course_id AND c1.course_name = 'Data Science'
JOIN enrollments e2 ON s.student_id = e2.student_id
JOIN courses c2 ON e2.course_id = c2.course_id AND c2.course_name = 'Web Development';

-- List all student-course pairs where the student's score is above the course average.
SELECT s.student_name, c.course_name, e.score
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE e.score > (
    SELECT AVG(e2.score)
    FROM enrollments e2
    WHERE e2.course_id = e.course_id
);

-- List the top scorer in each course.
SELECT c.course_name, s.student_name, e.score
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE (e.course_id, e.score) IN (
    SELECT course_id, MAX(score)
    FROM enrollments
    GROUP BY course_id
);

--  Get list of students and courses they are not enrolled in (Cross Join + Anti Join)

SELECT s.student_name, c.course_name
FROM students s
CROSS JOIN courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.student_id = s.student_id AND e.course_id = c.course_id
);

-- Sub query
-- find the names of students who scored more than average score in any course
select student_name
from students
where student_id in (
select student_id
from enrollments
where score > (select avg(score) from enrollments));

-- list students who are not enrolled in any course
select student_name
from students
where student_id not in(select student_id from enrollments);

-- Get course names where no student has been enrolled
select course_name
from courses
where course_id not in (
select distinct course_id from enrollments);

-- show student who are enrolled in atleast one course taught by 'Dr Raghav'
select distinct s.student_name
from students s
where exists( -- exists check if atleast one row specifies the condition in subquery
select * -- select 1 or select null will not increase memory
from enrollments e
join courses c on e.course_id = c.course_id
where e.student_id = s.student_id and c.instructor = 'Dr. Raghav');

-- indexing, normalisation and ER
-- idexing improves look up speed for frequent where, join, order by, group by
-- Insert and update will be slow

EXPLAIN select * from enrollments
where student_id = 1;


create index idx_student_id on enrollments(student_id);
CREATE INDEX idx_course_id ON enrollments(course_id);


EXPLAIN select * from enrollments
where student_id = 1;

-- Normalisation >> effecient way of making a table/schema


-- Unnormalized table
CREATE TABLE student_course_flat (
    student_id INT,
    student_name VARCHAR(50),
    city VARCHAR(50),
    course_id INT,
    course_name VARCHAR(50),
    instructor VARCHAR(50),
    score INT
);
select * from student_course_flat;

-- Problem with above table
-- No primary key, data is repeated

-- solution>> Normalisation

-- 1NF >> ensure unique keys and atomic values
-- 2NF >> Partial dependency
-- 3NF >> Transitive dependency

-- separate student table
CREATE TABLE students_nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    city VARCHAR(50)
);
select * from students_nf;

-- separate course
CREATE TABLE courses_nf (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    instructor VARCHAR(50)
);
select * from courses_nf;

-- Enrollment as Bridge Table
CREATE TABLE enrollments_nf (
    student_id INT,
    course_id INT,
    score INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
select * from enrollments_nf;


-- ER >> entity relationship diagram
/*
[Students] ---< [Enrollments] >--- [Courses]
   PK: student_id                    PK: course_id
   
   */


