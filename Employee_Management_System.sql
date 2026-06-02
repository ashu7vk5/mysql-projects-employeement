-- Project Goal
-- To design and implement a MySQL-based Employee Management System that centralizes employee,
-- department, and project information in a structured database. The system addresses the business challenge of managing employee records, 
-- department assignments, and project allocations efficiently, while reducing manual tracking and improving data accessibility for reporting 
-- and decision-making. The project also demonstrates practical SQL concepts such as database design, relationships, joins, aggregate functions, 
-- and business reporting queries.


-- ER DIAGRAM DETAILS
-- Relationship Summary
-- One Department → Many Employees (1:M)
-- One Employee → Many Project Assignments (1:M)
-- One Project → Many Employee Assignments (1:M)
-- Employee ↔ Project is a Many-to-Many (M:M) relationship resolved through the Employee_Projects table.

┌──────────────────┐
│   Departments    │
├──────────────────┤
│ department_id PK │
│ department_name  │
│ location         │
└─────────┬────────┘
          │ 1
          │
          │ M
┌─────────▼────────┐
│    Employees     │
├──────────────────┤
│ employee_id PK   │
│ first_name       │
│ last_name        │
│ salary           │
│ department_id FK │
└─────────┬────────┘
          │
          │ M
          │
┌─────────▼────────┐
│Employee_Projects │
├──────────────────┤
│ employee_id FK   │
│ project_id FK    │
│ role             │
└─────────┬────────┘
          │
          │ M
          │
┌─────────▼────────┐
│     Projects     │
├──────────────────┤
│ project_id PK    │
│ project_name     │
│ budget           │
└──────────────────┘


/*=========================================================
 PROJECT: EMPLOYEE MANAGEMENT SYSTEM
 DATABASE: employee_management
=========================================================*/

-- Create Database

CREATE DATABASE employee_management;
USE employee_management;

---------------------------------------------------------
-- TABLE 1: DEPARTMENTS
---------------------------------------------------------

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments VALUES
(101,'Human Resources','Mumbai'),
(102,'Information Technology','Pune'),
(103,'Finance','Mumbai'),
(104,'Sales','Delhi'),
(105,'Operations','Bangalore');

---------------------------------------------------------
-- TABLE 2: EMPLOYEES
---------------------------------------------------------

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    hire_date DATE,
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

INSERT INTO employees VALUES
(1001,'Rahul','Sharma','Male','2021-01-15',55000,102),
(1002,'Priya','Patel','Female','2020-03-20',60000,101),
(1003,'Amit','Verma','Male','2019-07-10',75000,103),
(1004,'Sneha','Kulkarni','Female','2022-05-12',50000,104),
(1005,'Karan','Singh','Male','2018-09-01',85000,102),
(1006,'Neha','Joshi','Female','2021-11-25',65000,105),
(1007,'Rohit','Mehta','Male','2023-02-15',45000,104),
(1008,'Anjali','Desai','Female','2020-08-05',70000,103);

---------------------------------------------------------
-- TABLE 3: PROJECTS
---------------------------------------------------------

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2)
);

INSERT INTO projects VALUES
(201,'ERP Implementation','2024-01-01','2024-12-31',500000),
(202,'Mobile App Development','2024-02-01','2024-10-31',350000),
(203,'Cloud Migration','2024-03-01','2025-03-01',700000),
(204,'Sales Analytics Dashboard','2024-04-01','2024-11-30',250000);

---------------------------------------------------------
-- TABLE 4: EMPLOYEE PROJECTS
---------------------------------------------------------

CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY(employee_id, project_id),
    FOREIGN KEY(employee_id)
    REFERENCES employees(employee_id),
    FOREIGN KEY(project_id)
    REFERENCES projects(project_id)
);

INSERT INTO employee_projects VALUES
(1001,201,'Developer'),
(1001,202,'Developer'),
(1005,203,'Team Lead'),
(1003,201,'Finance Analyst'),
(1004,204,'Sales Executive'),
(1007,204,'Sales Associate'),
(1006,203,'Operations Coordinator'),
(1008,201,'Budget Controller');



/*=========================================================
 PRACTICE QUERIES + SOLUTIONS
=========================================================*/

-- Q1 Display all employees

SELECT * FROM employees;

---------------------------------------------------------

-- Q2 Display employee names and salary

SELECT first_name,
       last_name,
       salary
FROM employees;

---------------------------------------------------------

-- Q3 Employees earning above 60000

SELECT *
FROM employees
WHERE salary > 60000;

---------------------------------------------------------

-- Q4 Employees in IT Department

SELECT *
FROM employees
WHERE department_id = 102;

---------------------------------------------------------

-- Q5 Sort employees by highest salary

SELECT *
FROM employees
ORDER BY salary DESC;

---------------------------------------------------------

-- Q6 Total employees

SELECT COUNT(*) AS total_employees
FROM employees;

---------------------------------------------------------

-- Q7 Average salary

SELECT AVG(salary) AS average_salary
FROM employees;

---------------------------------------------------------

-- Q8 Highest salary

SELECT MAX(salary) AS highest_salary
FROM employees;

---------------------------------------------------------

-- Q9 Lowest salary

SELECT MIN(salary) AS lowest_salary
FROM employees;

---------------------------------------------------------

-- Q10 Employee count by department

SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

---------------------------------------------------------

-- Q11 Average salary by department

SELECT department_id,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

---------------------------------------------------------

-- Q12 Employee with department name

SELECT
e.employee_id,
e.first_name,
e.last_name,
d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

---------------------------------------------------------

-- Q13 Employee Project Assignment Report

SELECT
e.first_name,
e.last_name,
p.project_name,
ep.role
FROM employees e
INNER JOIN employee_projects ep
ON e.employee_id = ep.employee_id
INNER JOIN projects p
ON ep.project_id = p.project_id;

---------------------------------------------------------

-- Q14 Department Salary Expense Report

SELECT
d.department_name,
SUM(e.salary) AS total_salary
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;

---------------------------------------------------------

-- Q15 Employees working on multiple projects

SELECT
employee_id,
COUNT(project_id) AS total_projects
FROM employee_projects
GROUP BY employee_id
HAVING COUNT(project_id) > 1;

---------------------------------------------------------

-- Q16 Employees earning above average salary

SELECT *
FROM employees
WHERE salary >
(
SELECT AVG(salary)
FROM employees
);

---------------------------------------------------------

-- Q17 Highest Paid Employee

SELECT *
FROM employees
WHERE salary =
(
SELECT MAX(salary)
FROM employees
);

---------------------------------------------------------

-- Q18 Total Project Budget

SELECT
SUM(budget) AS total_budget
FROM projects;

---------------------------------------------------------

-- Q19 Update Salary

UPDATE employees
SET salary = 60000
WHERE employee_id = 1001;

---------------------------------------------------------

-- Q20 Delete Project Assignment

DELETE FROM employee_projects
WHERE employee_id = 1007
AND project_id = 204;

/*================ END OF PROJECT =================*/