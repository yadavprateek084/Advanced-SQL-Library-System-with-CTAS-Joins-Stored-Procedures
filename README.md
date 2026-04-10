# 📚 Advanced SQL Library System with CTAS, Joins & Stored Procedures

## 🚀 Overview

This project is a **PostgreSQL-based Library Management System** designed to demonstrate advanced SQL concepts including **CTAS (Create Table As Select), complex joins, aggregations, and stored procedures**.

It simulates real-world library operations such as book issuing, returning, overdue tracking, and revenue analysis—making it a strong portfolio project for database and backend roles.

---

## 🎯 Key Features

* 📖 Book Management (Add, Update, Delete)
* 👤 Member Management
* 🔄 Book Issue & Return System
* ⏱️ Overdue Tracking with Fine Calculation
* 🏢 Branch-wise Performance Analytics
* 📊 Data Analysis using SQL Aggregations
* ⚙️ Stored Procedures for Automation
* 🧱 CTAS (Create Table As Select) for Reporting

---

## 🧠 Concepts Used

* SQL Joins (INNER JOIN, LEFT JOIN)
* GROUP BY & HAVING Clauses
* Aggregate Functions (SUM, COUNT)
* Subqueries & CTEs
* CTAS (Create Table As Select)
* Stored Procedures (PL/pgSQL)
* Foreign Key Constraints
* Date & Time Functions (CURRENT_DATE, INTERVAL)

---

## 🗂️ Database Schema

### Tables:

* `branch`
* `employees`
* `books`
* `members`
* `issued_status`
* `return_status`

### Relationships:

* Employees belong to branches
* Books are issued to members via employees
* Returns are tracked using issued records

---

## ⚙️ Setup Instructions

1. Install PostgreSQL
2. Open pgAdmin or psql
3. Run the SQL script to create tables:

   ```sql
   -- Run schema creation queries
   ```
4. Insert sample data (optional)
5. Execute queries and stored procedures

---

## 📌 Core SQL Tasks Implemented

### 🔹 CRUD Operations

* Insert new books
* Update member details
* Delete issued records
* Retrieve issued books by employee

---

### 🔹 Data Analysis Queries

* Books by category
* Rental income by category
* Recent member registrations
* Employees with highest activity

---

### 🔹 CTAS (Create Table As Select)

* `books_count` → Tracks number of times books are issued
* `expensive_books` → Filters books above price threshold
* `branch_reports` → Branch performance analytics
* `active_members` → Members active in recent period
* `fine_members` → Overdue members with calculated fines

---

### 🔹 Stored Procedures

#### 1. Issue Book

```sql
CALL new_issue_book('IS480','C104','978-0-141-44171-6','E106');
```

* Checks availability
* Issues book
* Updates status automatically

#### 2. Return Book

```sql
CALL new_return_records('RS140','IS123');
```

* Inserts return record
* Updates book availability
* Logs transaction details

---

## 📊 Advanced Feature: Fine Calculation

* Identifies overdue books (beyond 30 days)
* Calculates total overdue days
* Applies fine: **$0.50 per day**
* Stores results in `fine_members` table

---

## 🧪 Sample Query (Overdue Books)

```sql
SELECT 
    m.member_name,
    i.issued_book_name,
    i.issued_date,
    (CURRENT_DATE - i.issued_date) - 30 AS days_overdue
FROM issued_status i
LEFT JOIN return_status rs ON rs.issued_id = i.issued_id
LEFT JOIN members m ON m.member_id = i.issued_member_id
WHERE rs.return_id IS NULL;
```

---

## 💡 Use Cases

* Academic database project
* SQL practice for interviews
* Backend logic simulation
* Data analytics demonstration

---

## 🏆 Why This Project Stands Out

* Goes beyond basic CRUD operations
* Implements real-world business logic
* Uses advanced SQL features (CTE, CTAS, procedures)
* Demonstrates strong database design & querying skills

---

## 📎 Future Improvements

* Add frontend (React / Web UI)
* Integrate REST API (Node.js / Express)
* Add authentication system
* Dashboard for analytics visualization

---

## 👨‍💻 Author

**Prateek Yadav**
B.Tech CSE | Aspiring Software Engineer

---
