-- Display any two columns from employees table.
Select first_name,last_name from HR.EMPLOYEES;

-- Display Hire_date from employees table, name it as Joining Date.
SELECT HIRE_DATE as "Joining Date" From HR.EMPLOYEES;

-- Display the first_name, last_name of Employees together in one column named “FULL NAME”.
select first_name || last_name as "Full Name" from hr.employees;

-- Show unique departments of Employees Table.
SELECT DISTINCT department_id FROM hr.employees;

-- Show all salaries of Employees.
SELECT ALL(salary) from HR.EMPLOYEES;

-- List all Employees having annual salary greater 20, 000 and lesser than 30,000.
SELECT * FROM HR.EMPLOYEES WHERE SALARY*12 > 20000 AND SALARY*12 < 30000;

-- List employee_id and first_name of employees from department # 60 to department #100.
SELECT employee_id,FIRST_NAME FROM HR.EMPLOYEES WHERE DEPARTMENT_ID BETWEEN 60 AND 100;

-- List all the Employees belonging to cities like Toronto, Hiroshima and Sydney.
SELECT * FROM HR.EMPLOYEES,HR.LOCATIONS WHERE CITY IN ('Toronto','Hiroshima','Sydney');

-- List all the Employees having an ‘ll’ in their first_names.
select * from HR.EMPLOYEES where FIRST_NAME like '%ll%';

-- List all the employees with no commission.
select * from HR.EMPLOYEES where COMMISSION_PCT IS NULL;

-- List all employees in order of their decreasing salaries.
select * from HR.EMPLOYEES order by SALARY desc;

-- EXTRA 
SELECT GREATEST(4,8,3) FROM DUAL;
SELECT TRUNC(34.65,.25) FROM DUAL;
SELECT INITCAP('gOOD mORNING') FROM DUAL;

-- Print an employee name (first letter capital) and job title (lower Case)
SELECT INITCAP(first_name || ' ' || last_name) as "Employee Name"
,lower(job_title) as "Job Title"  from HR.EMPLOYEES,HR.JOBS;

/*
Display employee name and job title together, length of employee name and
the numeric position of letter A in employee name, for all employees who are in
sales. Hint: For finding position you need to use string function “instr()”, this function
worked as INSTR(string1, string2)(s1:sreaching string, s2:string/char you’re
searching for).
*/
select (first_name || ' ' || last_name || ' ' || job_title) as "Employee Name and Job Title",
LENGTH(first_name || last_name) as "Name Length",
INSTR(first_name || last_name,'a') as "Position of a"
from HR.EMPLOYEES,HR.JOBS where job_title like '%Sales%'; 

-- same method will be apply for 'A'


/*
Comparing the hire dates for all employees who started in 2003, display the
employee number, hire date, and month started using the conversion and date
functions.
*/

select employee_id AS "Employee No",hire_date,to_char(HIRE_DATE,'MONTH') as "Started Month" from HR.EMPLOYEES
where EXTRACT(YEAR FROM HIRE_DATE) = '2003';


-- To display the employee number, the month number and year of hiring.
SELECT employee_id AS "Employee No",EXTRACT(month from hire_date) as "Month No",
EXTRACT(year from hire_date) as "Hiring Year" from HR.EMPLOYEES;


/*
To display the employee’s name and hire date for all employees. The hire date
appears as 16 September, 2021.
*/
select first_name||' '||last_name as "Employee Name",TO_CHAR(hire_date,'DD MONTH, YYYY') as "Hire Date"
from HR.EMPLOYEES;


--Display the salary of employee Neena with $ sign preceded.
select LPAD(salary,6,'$') from HR.EMPLOYEES where FIRST_NAME like 'Neena';

-- Find the next ‘Monday’ considering today’s date as date.
SELECT NEXT_DAY(SYSDATE, 'MONDAY') AS "NEXT MONDAY"  FROM DUAL;

-- List all Employees who have an ‘A’ in their last names.
SELECT * FROM HR.EMPLOYEES WHERE LAST_NAME LIKE '%A%';

-- Show all employees’ last three letters of first name.
select SUBSTR(FIRST_NAME,-3) as "Last three letters" from HR.EMPLOYEES;

/*
For all employees employed for more than 100 months, display the
employee number, hire date, number of months employed, first Friday after hire
date andlast day of the month hired.
*/
select employee_id,hire_date,
ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE),2) AS "MONTHS EMPLOYEED",
NEXT_DAY(HIRE_DATE,'Friday') AS "NEXT FRIDAY",
LAST_DAY(HIRE_DATE) AS "LAST DAY"
FROM HR.EMPLOYEES WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE) > 100;

/*
To display the employee number, name, salary of employee before and after
15% increment in the yearly salary. Name the calculated new salary as
“Incremented Salary”. Do calculate the difference between before and after
salaries & name this amount as “Incremented Amount”.
*/
SELECT employee_id,(FIRST_NAME || LAST_NAME) AS "EMPLOYEE NAME",
SALARY*12 AS "YEARLY SALARY BEFORE 15% INCR",
(SALARY*12)+(0.15*SALARY*12) AS "Increamented Salary",
((SALARY*12)+(0.15*SALARY*12) - (salary*12)) as "Increamented Amount"
from HR.EMPLOYEES;


/*
List the name, hire date, and day of the week (labeled DAY) on which job
was started. Order the result by day of week starting with Monday.
*/
SELECT (first_name || last_name) as "Employee Name",hire_date,
to_char(hire_date,'DAY') AS "DAY"
from HR.EMPLOYEES ORDER BY to_char(HIRE_DATE,'D') asc;


/*
Display the department and manager id for all employees and round the
commission up to 1 decimal.
*/
select department_id, manager_id,ROUND(COMMISSION_PCT,1) from HR.EMPLOYEES;

/* 
Write a query to find the list of employees whose COMMISSION_PCT>0 and they do
not belong to DEPARTMENT_ID 90 or 100 from Employees table
*/
select * from HR.EMPLOYEES where COMMISSION_PCT > 0 and DEPARTMENT_ID !=90 or DEPARTMENT_ID!=100;


-- Write a query to find the employees who are hired in year 2010 from Employees table.
select * from HR.EMPLOYEES where EXTRACT(year from hire_date) like '2010';


/*
Write a query to find the list of jobs whose min salary is greater than 8000
and less than 15,000 and commission = 0 from job table.
*/
select * from HR.JOBS,HR.EMPLOYEES where MIN_SALARY BETWEEN 8000 and 15000 and commission_pct is NULL;


/*
Write a query to find employee whose ID are greater than 100 and less than 150
and their department_id is greater than 90 and less than 100 along with their
first_name, Last_name & Job ID.
*/
select FIRST_NAME,LAST_NAME,JOB_ID from HR.EMPLOYEES where EMPLOYEE_ID BETWEEN 100 and 150 and DEPARTMENT_ID BETWEEN 90 and 100;

/*
Write a query to find total salary (Total salary formula = salary + (commission_pct*
salary)) as “Total Salary”, commission_pct where commission_pct is not equal to
null.
*/
select (salary + (COMMISSION_PCT*salary)) as "TOTAL SALARY",COMMISSION_PCT from HR.EMPLOYEES where COMMISSION_PCT IS NOT NULL;
