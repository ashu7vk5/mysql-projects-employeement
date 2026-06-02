-- IT Service Desk & Incident Management System
-- Project Goal

-- To design and implement a MySQL-based IT Service Desk & Incident Management System that centralizes support ticket tracking, technician assignments, incident resolution, and team performance reporting. 
-- The system addresses the business challenge of managing IT support requests efficiently, reducing manual tracking, improving response visibility, and enabling data-driven operational reporting through SQL.

-- ER DIAGRAM DETAILS

Relationship Summary
One Support Team → Many Technicians
One Technician → Many Tickets
One Employee → Many Tickets
One Ticket → One Resolution Record

┌──────────────────┐
│  Support Teams   │
├──────────────────┤
│ team_id PK       │
│ team_name        │
│ manager_name     │
└─────────┬────────┘
          │ 1
          │
          │ M
┌─────────▼────────┐
│   Technicians    │
├──────────────────┤
│ technician_id PK │
│ technician_name  │
│ team_id FK       │
└─────────┬────────┘
          │ 1
          │
          │ M
┌─────────▼────────┐
│     Tickets      │
├──────────────────┤
│ ticket_id PK     │
│ employee_id FK   │
│ technician_id FK │
│ issue_type       │
│ priority         │
│ status           │
└──────┬─────┬─────┘
       │     │
       │     │
       │     │
       │     ▼
       │  Employees
       │
       ▼
┌──────────────────┐
│ Ticket Resolution│
├──────────────────┤
│ resolution_id PK │
│ ticket_id FK     │
│ notes            │
└──────────────────┘


Employees
│ employee_id PK
│ employee_name
│ department
│ email


/*=========================================================
PROJECT : IT SERVICE DESK & INCIDENT MANAGEMENT SYSTEM
=========================================================*/

CREATE DATABASE it_service_desk;
USE it_service_desk;

---------------------------------------------------------
-- SUPPORT TEAMS
---------------------------------------------------------

CREATE TABLE support_teams(
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50),
    manager_name VARCHAR(50)
);

INSERT INTO support_teams VALUES
(1,'Network Team','Rajesh Kumar'),
(2,'Application Support','Priya Shah'),
(3,'Desktop Support','Anil Verma'),
(4,'Cyber Security','Neha Singh');

---------------------------------------------------------
-- EMPLOYEES
---------------------------------------------------------

CREATE TABLE employees(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO employees VALUES
(101,'Rahul Sharma','Finance','rahul@company.com'),
(102,'Sneha Patil','HR','sneha@company.com'),
(103,'Amit Gupta','Sales','amit@company.com'),
(104,'Karan Mehta','Operations','karan@company.com'),
(105,'Pooja Jain','Marketing','pooja@company.com');

---------------------------------------------------------
-- TECHNICIANS
---------------------------------------------------------

CREATE TABLE technicians(
    technician_id INT PRIMARY KEY,
    technician_name VARCHAR(100),
    team_id INT,
    FOREIGN KEY(team_id)
    REFERENCES support_teams(team_id)
);

INSERT INTO technicians VALUES
(201,'Vikas Patil',1),
(202,'Anjali Deshmukh',2),
(203,'Rohan Singh',3),
(204,'Deepak Nair',4);

---------------------------------------------------------
-- TICKETS
---------------------------------------------------------

CREATE TABLE tickets(
    ticket_id INT PRIMARY KEY,
    employee_id INT,
    technician_id INT,
    issue_type VARCHAR(100),
    priority VARCHAR(20),
    status VARCHAR(20),
    created_date DATE,
    FOREIGN KEY(employee_id)
    REFERENCES employees(employee_id),
    FOREIGN KEY(technician_id)
    REFERENCES technicians(technician_id)
);

INSERT INTO tickets VALUES
(1001,101,202,'ERP Login Failure','High','Open','2025-01-10'),
(1002,102,203,'Laptop Not Starting','Medium','Closed','2025-01-12'),
(1003,103,201,'Internet Connectivity','High','In Progress','2025-01-15'),
(1004,104,204,'Suspicious Email','Critical','Closed','2025-01-18'),
(1005,105,202,'CRM Application Error','Low','Open','2025-01-20');

---------------------------------------------------------
-- TICKET RESOLUTION
---------------------------------------------------------

CREATE TABLE ticket_resolution(
    resolution_id INT PRIMARY KEY,
    ticket_id INT,
    resolution_notes VARCHAR(255),
    resolution_date DATE,
    FOREIGN KEY(ticket_id)
    REFERENCES tickets(ticket_id)
);

INSERT INTO ticket_resolution VALUES
(1,1002,'Replaced faulty battery','2025-01-13'),
(2,1004,'Blocked phishing sender','2025-01-19');


/*=========================================================
PRACTICE QUERIES
=========================================================*/

-- Q1 View all tickets

SELECT * FROM tickets;

---------------------------------------------------------

-- Q2 Open Tickets

SELECT *
FROM tickets
WHERE status='Open';

---------------------------------------------------------

-- Q3 Critical Incidents

SELECT *
FROM tickets
WHERE priority='Critical';

---------------------------------------------------------

-- Q4 Closed Tickets

SELECT *
FROM tickets
WHERE status='Closed';

---------------------------------------------------------

-- Q5 Tickets assigned to Technician 202

SELECT *
FROM tickets
WHERE technician_id=202;

---------------------------------------------------------

-- Q6 Total Tickets

SELECT COUNT(*) AS total_tickets
FROM tickets;

---------------------------------------------------------

-- Q7 Open Ticket Count

SELECT COUNT(*) AS open_tickets
FROM tickets
WHERE status='Open';

---------------------------------------------------------

-- Q8 Tickets by Status

SELECT status,
       COUNT(*) AS total
FROM tickets
GROUP BY status;

---------------------------------------------------------

-- Q9 Tickets by Priority

SELECT priority,
       COUNT(*) AS total
FROM tickets
GROUP BY priority;

---------------------------------------------------------

-- Q10 Employee Ticket Details

SELECT
e.employee_name,
t.ticket_id,
t.issue_type,
t.status
FROM employees e
JOIN tickets t
ON e.employee_id=t.employee_id;

---------------------------------------------------------

-- Q11 Technician Workload

SELECT
tech.technician_name,
COUNT(t.ticket_id) AS assigned_tickets
FROM technicians tech
LEFT JOIN tickets t
ON tech.technician_id=t.technician_id
GROUP BY tech.technician_name;

---------------------------------------------------------

-- Q12 Team Performance Report

SELECT
st.team_name,
COUNT(t.ticket_id) AS total_tickets
FROM support_teams st
JOIN technicians tech
ON st.team_id=tech.team_id
JOIN tickets t
ON tech.technician_id=t.technician_id
GROUP BY st.team_name;

---------------------------------------------------------

-- Q13 Ticket Resolution Report

SELECT
t.ticket_id,
t.issue_type,
tr.resolution_notes
FROM tickets t
JOIN ticket_resolution tr
ON t.ticket_id=tr.ticket_id;

---------------------------------------------------------

-- Q14 Employees with Unresolved Tickets

SELECT employee_name
FROM employees
WHERE employee_id IN
(
SELECT employee_id
FROM tickets
WHERE status <> 'Closed'
);

---------------------------------------------------------

-- Q15 Technician with Highest Tickets

SELECT technician_id,
COUNT(*) AS total_tickets
FROM tickets
GROUP BY technician_id
ORDER BY total_tickets DESC
LIMIT 1;

---------------------------------------------------------

-- Q16 Average Tickets per Technician

SELECT AVG(ticket_count) AS avg_tickets
FROM
(
SELECT COUNT(*) AS ticket_count
FROM tickets
GROUP BY technician_id
) x;

---------------------------------------------------------

-- Q17 Update Ticket Status

UPDATE tickets
SET status='Closed'
WHERE ticket_id=1001;

---------------------------------------------------------

-- Q18 Delete Resolution Record

DELETE FROM ticket_resolution
WHERE resolution_id=2;

---------------------------------------------------------

-- Q19 High Priority Open Tickets

SELECT *
FROM tickets
WHERE priority='High'
AND status='Open';

---------------------------------------------------------

-- Q20 Support Team Ticket Summary

SELECT
st.team_name,
COUNT(t.ticket_id) AS total_tickets
FROM support_teams st
LEFT JOIN technicians tech
ON st.team_id=tech.team_id
LEFT JOIN tickets t
ON tech.technician_id=t.technician_id
GROUP BY st.team_name;

/*=============== END OF PROJECT ===============*/