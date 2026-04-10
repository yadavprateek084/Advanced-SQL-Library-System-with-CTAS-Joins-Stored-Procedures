--library management system

drop table if exists branch;
create table branch (
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(100),
	contact_no varchar(10)
);

drop table if exists employees;
create table employees (
emp_id varchar(10) primary key,
emp_name varchar(30),
position varchar(20),
salary int,
branch_id varchar(10)
);

drop table if exists books;
create table books (
isbn varchar(30) primary key,
book_title varchar(100),
category varchar(20),
rental_price float,
status varchar(10),
author varchar(30),
publisher varchar(50)
);

drop table if exists issued_status;
create table issued_status (
issued_id varchar(10) primary key,
issued_member_id varchar(10),
issued_book_name varchar(100),
issued_date	date,
issued_book_isbn varchar(100),
issued_emp_id varchar(10)
);

drop table if exists members;
create table members (
member_id varchar(10) primary key,
member_name	varchar(30),
member_address varchar(100),
reg_date date
);

drop table if exists return_status;
create table return_status(
return_id varchar(10) primary key,
issued_id varchar(10),
return_book_name varchar(100),
return_date date,
return_book_isbn varchar(30)
);

--foreign key

alter table issued_status
add constraint fk_issued_member_id
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_issued_book_isbn
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_issued_emp_id
foreign key (issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch_id
foreign key (branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_id
foreign key (issued_id)
references issued_status(issued_id);

alter table return_status
add constraint fk_return_book_isbn
foreign key (return_book_isbn)
references books(isbn);



select * from books
select * from books_count
select * from members
select * from issued_status
select * from branch
select * from employees


-- Project TASK


-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

	insert into books(isbn	,book_title,	category,	rental_price,	status	,author,	publisher)
	values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co');

-- Task 2: Update an Existing Member's Address

	update members
	set member_address = 'jaunpur'
	where member_id='C106'

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

	delete from issued_status
	where issued_id='IS105'

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E104'.

	select
		issued_emp_id,
		issued_book_name
	from issued_status
	where issued_emp_id = 'E104'

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

	select 
		issued_emp_id,
		count(issued_book_name) as Issued_More_Than_One_Book
	from issued_status
	group by 1
	having count(issued_book_name)>1
	order by 1

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
create table books_count as
	select book_title,count(issued_id)
	from books b
	join issued_status s on b.isbn = s.issued_book_isbn
	group by book_title
	

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
	
	select *
	from books
	where Category='Classic'
	
-- Task 8: Find Total Rental Income by Category:

	select 
		b.category,
		count(s.issued_id) as times_issued,
		sum(b.rental_price) as total_rent
	from books b
	join issued_status s on b.isbn = s.issued_book_isbn
	group by 1

-- Task 9. **List Members Who Registered in the Last 4 years**:

	select reg_date
	from members
	where reg_date > CURRENT_DATE  - interval '4 years'
	order by 1

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

	create table manager_name as 
	select b.manager_id,e.emp_name as manager_name
	from employees e
	join branch b on e.branch_id = b.branch_id
	where b.manager_id=e.emp_id
	
	select 
		e.emp_id,
		e.emp_name,
		m.manager_name,
		b.branch_address,
		b.contact_no,position,salary
	from employees e
	right join branch b on e.branch_id = b.branch_id
	right join manager_name m on m.manager_id=b.manager_id
	order by emp_id
	
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold

	create table expensive_books as
	select *
	from books
	where rental_price > 7

-- Task 12: Retrieve the List of Books Not Yet Returned

	select 
		isu.*
	from issued_status isu
	left join return_status rs on isu.issued_id = rs.issued_id
	where rs.return_id is null
		

-- ### Advanced SQL Operations

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.
	
	select 
		m.member_name,
		i.issued_book_name,
		i.issued_date,
	    (CURRENT_DATE - i.issued_date)-30 AS days_overdue
	from issued_status i
	left join return_status rs on rs.issued_id=i.issued_id
	left join members m on m.member_id=i.issued_member_id
	where return_date is null 
	order by 1

-- Task 14: Update Book Status on Return
-- This query updates the status of books in the books table to "available" when the corresponding book has been returned and the return entry exists in the return_status table.

--testing

	select * from books
	where isbn = '978-0-307-58837-1'

	select * from issued_status
	where issued_book_isbn = '978-0-307-58837-1'
	
	select * from return_status
	where return_book_isbn = '978-0-307-58837-1'

--store procedures

create or replace procedure new_return_records(p_return_id varchar(10),p_issued_id varchar(10))
language plpgsql

as $$

declare
	v_issued_date date;
	v_isbn varchar(100);
	v_book_name varchar(100);
begin

	select
		issued_book_isbn,
		issued_book_name
		into v_isbn,v_book_name
	from issued_status
	where issued_id=p_issued_id;
	
	select
		issued_date
		into v_issued_date
	from issued_status
	where issued_id=p_issued_id;

	insert into return_status(return_id,issued_id,return_date)
	values(p_return_id,p_issued_id,current_date);

	update books
	set status = 'yes'
	where isbn=v_isbn;

	raise notice 'return book record and book status is successfully updated book name :%' ,v_book_name;
	raise notice 'book isbn =% ', v_isbn;
	raise notice 'Was Issued on =% ', v_issued_date;

end;
$$

--calling the procedure 

call new_return_records('RS140','IS123')

	
-- Task 15: Branch Performance Report
-- This query generates a branch performance report showing the total number of books issued, the total number of books returned, and the total revenue generated from book rentals for each branch.

create table branch_reports as 

with details_joins as 
	(
	select b.branch_id,          
        isu.issued_id,
        r.return_id,
		books.rental_price
	from issued_status isu
	join employees e on e.emp_id=isu.issued_emp_id
	join branch b on b.branch_id=e.branch_id
	left join return_status r on r.issued_id=isu.issued_id
	join books on books.isbn = isu.issued_book_isbn
	 )
	 
select 
	branch_id,
	count(issued_id) as book_issued,
	count(return_id) as book_return,
	sum(rental_price) as net_book_rent
from details_joins dj
group by 1
order by 1

-- Task 16: CTAS: Create a Table of Active Members
-- This query uses the CREATE TABLE AS SELECT (CTAS) statement to create a new table named active_members, which stores the details of members who have issued at least one book in the last 6 months.

create table active_members as
	select distinct member_name 
	from issued_status isu
	left join members m on m.member_id = isu.issued_member_id
	where issued_date > current_date - interval '24.5 months'

-- Task 17: Find Employees with the Most Book Issues Processed
-- This query identifies the top 3 employees who have processed the highest number of book issue transactions. It displays the employee name, the total number of books processed, and the branch they belong to.

	select
		issued_emp_id,
		emp_name,
		b.branch_id,
		count(issued_id) as total_order_processed
	from issued_status isu
	left join employees e on e.emp_id=isu.issued_emp_id
	left join branch b on b.branch_id=e.branch_id
	group by 1,2,3
	order by count(issued_id) desc
	limit 3

-- Task 18: Stored Procedure
-- This stored procedure is created to manage the status of books in the library system.

-- When a book is issued, its status is updated to no.
-- When a book is returned, its status is updated to yes'.

-- This helps in automatically maintaining book availability in the database.

	select * from books
	select * from members
	select * from public.employees
	
	select * from issued_status

create or replace procedure new_issue_book(p_issued_id varchar(10),p_issued_member_id varchar(10),p_issued_book_isbn varchar(100),p_issued_emp_id varchar(100))
	
language plpgsql
	
as $$
	
declare
	v_status varchar(10);
	v_title varchar(100);
begin

	select 
		status,book_title
		into
		v_status,v_title
	from books
	where isbn=p_issued_book_isbn;

   if v_status = 'yes' then
	    insert into issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
		values (p_issued_id,p_issued_member_id,v_title,current_date,p_issued_book_isbn,p_issued_emp_id);

		update books
		 set status = 'no'
		where isbn = p_issued_book_isbn;
	
	else
	raise notice 'book is not available';
	end if;
	
end;
$$

call new_issue_book('IS480','C104','978-0-141-44171-6','E106')


-- Task 19: Create Table As Select (CTAS)
-- This CTAS query creates a new table that identifies overdue books and calculates fines for each member. 
--It includes members who have issued books but have not returned them within 30 days. The table stores:
-- Member ID
-- Number of overdue books
-- Total fines
-- The fine is calculated at the rate of $0.50 per day for each overdue book.

CREATE TABLE fine_members AS
WITH book_overdue_ct AS (
    SELECT 
        m.member_id,
        COUNT(isu.issued_id) AS overdue_books,
        SUM(
            (CURRENT_DATE - isu.issued_date) - 30
        ) AS total_overdue_days
    FROM issued_status isu
    LEFT JOIN return_status rs 
        ON rs.issued_id = isu.issued_id
    LEFT JOIN members m 
        ON m.member_id = isu.issued_member_id
    WHERE rs.return_id IS NULL 
      AND isu.issued_date < CURRENT_DATE - INTERVAL '30 days'
    GROUP BY m.member_id
)

SELECT 
    member_id,
    overdue_books,
    total_overdue_days,
    total_overdue_days * 0.50 AS total_fine_$
FROM book_overdue_ct;

select * from fine_members