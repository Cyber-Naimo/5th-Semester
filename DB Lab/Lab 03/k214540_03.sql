/*













*/


create table jobs
(
    job_id varchar(10),
    job_title varchar(15),
    min_salary number(6),
    max_salary number(8)
);
create table job_history
(
    employee_id  NUMBER(6),
    start_date VARCHAR(20),
    end_date VARCHAR(20),
    job_id VARCHAR(10),
    department_id number(6)
);


-- 2nd way of creating primary key;
alter table jobs modify job_id varchar(10) NOT NULL;
alter table jobs add CONSTRAINT pk1 UNIQUE(job_id);
-- another way by dropping unique constraint

alter table jobs drop CONSTRAINT pk1;
-- 3rd way and preferable
alter table jobs add constraint pk1 primary key(job_id);


--3. Change the data type of ‘job_ID’ from character to numeric in Jobs table.(Like IT_Prog->101).
alter table jobs modify job_id number(6);


/* 4. Write a SQL statement to add job_id column in job_history table as foreign key 
referencing to the primary key job_id of jobs table. */
-- first we need to modify data type of job_history's job_id to number
alter table job_history modify job_id number(6);
alter table job_history add CONSTRAINT sk1 foreign key(job_id) references jobs(job_id); 

/* 
5.Insert a new row in jobs table having all the attributes and the job_ID should update in
job_History table as well.
*/
insert into JOBS VALUES(101,'Teacher',5000,61000);

select * from job_history;
select * from jobs;

-- 6. Add Column Job_Nature in Jobs table.
alter table jobs add job_nature varchar(25);

--7 Create replica of employee table.
create table Employee
(
    employee_id  NUMBER(6) NOT NULL PRIMARY KEY,
    first_name varchar(25),
    last_name varchar(25),
    email varchar(25),
    phone_number varchar(15),
    hire_date varchar(20),
    job_id varchar(10),
    salary NUMBER(8),
    commission_pct DECIMAL(4,2),
    manager_id number(5),
    department_id number(5)
);


/*
Write a SQL statement to add employee_id column in job_history table as foreign key
referencing to the primary key employee_id of employees table.
*/
alter table job_history add constraint fk2 FOREIGN key(employee_id) references employee(employee_id);


 -- 9. Drop column Job_Nature.
alter table jobs drop COLUMN job_nature;


/*
10. ALTER table EMPLOYEE created in question 5 and apply the constraint CHECK on
First_Name attribute such that ENAME should always be inserted in capital letters.
*/
alter table employee add CONSTRAINT ck2 CHECK(first_name = UPPER(first_name));
-- Now if I insert the first name like Naimat so gives error 
--insert into EMPLOYEE values(101,'NAIMAT','Khan','email',1233234,'25 Feb, 2023','IK1',3222,null,333,222);



/*
11. ALTER table EMPLOYEE created in question 5 and apply the constraint on SALary
attribute such that no two salaries of the employees should be similar.(Hint Unique)
*/
alter table employee add constraint ck1 unique(salary);



/*
12. ALTER table Employee created in question 5 and apply constraint on Phone_No such
that Phone_No should not be entered empty (Hint modify).
*/
alter table employee modify phone_number varchar(15) not null;

/*
13. Write a SQL statement to insert one row into the table employees.
*/

insert into EMPLOYEE values(101,'NAIMAT','Khan','email','123.32.34','25 Feb, 2023','IK1',3222,null,333,222);

/*
14. Write a SQL statement to change the salary of employee to 8000 who’s ID is 105, if the
existing salary is less than 1+000.
*/

update HR.EMPLOYEES set salary = 8000 where EMPLOYEE_ID = 105 and salary < 10000;

/*
15. Write a SQL statement to add a primary key for a combination of columns employee_id
and job_id in employees table, give the reason why this command is showing error.
*/
/* Primary key is combination of NOT NULL and Unique so every table has only one
   unique or primary key.
   -- query= alter table employee add CONSTRAINT ck5 PRIMARY key(employee_id,job_id);
*/


/*
16. Write a SQL statement to add an index named indx_job_id on job_id column in the
table job_history.
*/
create unique index indx_job_id on job_history(job_id); 

-- 17. Write a SQL statement to remove employees table
drop table employee;



