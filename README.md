# 📚 Advanced SQL Library System with CTAS, Joins & Stored Procedures

## 📌 Project Summary

Designed and implemented a **relational database system in PostgreSQL** to manage end-to-end library operations.
This project demonstrates strong proficiency in **advanced SQL, database design, and backend logic implementation**, including real-world features like **transaction handling, overdue tracking, and revenue analytics**.

---

## 🚀 Key Highlights

* Built a **fully normalized relational database schema** with multiple interconnected tables
* Implemented **complex SQL queries using JOINs, CTEs, and aggregations**
* Designed **stored procedures (PL/pgSQL)** to automate issue/return workflows
* Developed **CTAS-based reporting systems** for analytics and insights
* Engineered a **fine calculation system** based on overdue duration
* Created **branch-level performance reports** with revenue tracking

---

## 🧱 Tech Stack

* **Database:** PostgreSQL
* **Language:** SQL, PL/pgSQL
* **Concepts:** Relational Modeling, Data Integrity, Query Optimization

---

## 🗂️ Database Design

### Core Tables:

* `books` — stores book metadata and availability status
* `members` — maintains user registration details
* `employees` — handles staff and operations
* `branch` — branch-level management
* `issued_status` — tracks issued books
* `return_status` — records returned books

### Key Design Features:

* Enforced **referential integrity using foreign keys**
* Structured schema to support **multi-branch operations**
* Modeled **real-world transactional relationships**

---

## ⚙️ Functional Modules

### 🔹 1. Book Issue System

* Validates book availability before issuing
* Updates book status dynamically
* Logs transaction with issue date

### 🔹 2. Book Return System

* Records return transactions
* Automatically updates availability
* Maintains audit trail via stored procedures

### 🔹 3. Overdue & Fine Engine

* Identifies books not returned within 30 days
* Calculates **total overdue days**
* Applies fine: **$0.50 per day per book**
* Stores results in a dedicated analytics table

---

## 📊 Advanced SQL Implementations

### 🔹 Complex Joins

* Multi-table joins across **books, members, employees, and branches**
* Used LEFT JOIN for **missing return detection**

### 🔹 Aggregations & Analytics

* Revenue calculation using `SUM()`
* Usage tracking via `COUNT()`
* Performance ranking of employees and branches

### 🔹 CTAS (Create Table As Select)

Used to generate analytical datasets:

* `books_count` → Book popularity tracking
* `branch_reports` → Branch-level performance metrics
* `active_members` → Recently active users
* `fine_members` → Overdue users with calculated fines

---

## ⚡ Stored Procedures (PL/pgSQL)

### ✅ Issue Book Procedure

* Checks availability before issuing
* Inserts transaction record
* Updates book status automatically

### ✅ Return Book Procedure

* Inserts return record
* Updates availability status
* Logs transaction details using notices

---

## 🧪 Sample Analytical Query

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

## 📈 Business Insights Generated

* Identified **high-demand books** using issue frequency
* Measured **branch performance** via revenue and transactions
* Detected **inactive vs active members**
* Generated **fine reports for overdue users**

---

## 🏆 Impact & Learning Outcomes

* Strengthened understanding of **advanced SQL querying and optimization**
* Gained hands-on experience with **real-world database workflows**
* Learned to design systems with **data consistency and scalability in mind**
* Applied **analytical thinking to derive insights from structured data**

---

## 🔮 Future Enhancements

* Build REST API using **Node.js + Express**
* Develop frontend dashboard using **React**
* Add authentication & role-based access control
* Integrate visualization tools for reporting

---

## 👨‍💻 Author

**Prateek Yadav**
B.Tech CSE | Aspiring Software Engineer

---

## ⭐ Project Value

This project showcases:

* Strong **SQL & database fundamentals**
* Ability to implement **real-world backend logic**
* Experience with **data analysis and reporting systems**

👉 Ideal for roles in **Backend Development, Data Analysis, and Database Engineering**
