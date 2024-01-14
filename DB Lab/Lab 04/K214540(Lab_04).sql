-- Practice
select trunc(AVG(salary),3) as "Average Salary",DEPARTMENT_ID from HR.EMPLOYEES
group by DEPARTMENT_ID having avg(SALARY) <= 10000;

SELECT
employee_id, first_name, last_name, salary
FROM
hr.employees
WHERE
salary = (SELECT
MAX(salary)
FROM
hr.employees);


SELECT employee_ID, First_Name, job_ID,SALARY FROM HR.EMPLOYEES
WHERE SALARY > ALL
( SELECT salary FROM HR.EMPLOYEES WHERE JOB_ID = 'PU_CLERK' );

SELECT salary FROM HR.EMPLOYEES WHERE JOB_ID = 'PU_CLERK';


/*
1. For each department, retrieve the department no, the number of employees in
the department and their average salary.
*/

select department_id, count(department_id) as No_of_employees,
TRUNC(avg(salary),3) as Average_Salary 
from HR.EMPLOYEES group by DEPARTMENT_ID;


-- 2. Write a Query to display the number of employees with the same job.
select job_id,COUNT(*) as No_of_Employees from HR.EMPLOYEES  group by JOB_ID;

/*
3. Write a Query to select Firstname and Hiredate of Employees Hired right
after the joining of employee_ID no 110.
*/

select first_name,hire_date from HR.EMPLOYEES where hire_date IN 
(select hire_date from HR.EMPLOYEES where EMPLOYEE_ID > 110);


/*
4. Write a SQL query to select those departments where maximum salary is at
least 15000.
*/
select department_id from HR.EMPLOYEES GROUP BY DEPARTMENT_ID
HAVING MAX(salary)>=15000;


/*
5. Write a query to display the employee number, name (first name and last
name) and job title for all employees whose salary is smaller than any salary
of those employees whose job id is IT_PROG.
*/

SELECT employee_id,first_name||' ' || last_name as Name,
job_title from HR.EMPLOYEES,HR.JOBS where salary < ANY 
(SELECT SALARY FROM HR.EMPLOYEES WHERE JOB_ID LIKE 'IT_PROG');


/*
6. Write a query in SQL to display all the information of those employees who
did not have any job in the past.

*/

SELECT * FROM HR.EMPLOYEES WHERE EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM HR.JOB_HISTORY);


/*
7. Display the manager number and the salary of the lowest paid employee of
that manager. Exclude anyone whose manager is not known. Exclude any
groups where the minimum salary is 2000. Sort the output in descending
order of the salary.
*/


select MANAGER_ID, MIN(SALARY) AS lowest_paid_emp FROM HR.EMPLOYEES
WHERE MANAGER_ID IS NOT NULL GROUP BY MANAGER_ID
HAVING MIN(SALARY) <= 2000 ORDER BY LOWEST_SALARY DESC;


/*
8. Insert into employees_BKP as it should copy the record of the employee
whose start date is ’13-JAN-01’ from job_History table.
*/
create table Employee_BKP as (select * from HR.EMPLOYEES where 1=2); 

insert into EMPLOYEE_BKP
select * from HR.EMPLOYEES where HR.EMPLOYEES.HIRE_DATE like
(select START_DATE from HR.JOB_HISTORY where START_DATE like '13-JAN-01');



/*
9. Update salary of employees by 20% increment having minimum salary of
6000 from jobs table.
*/
UPDATE HR.EMPLOYEES SET SALARY = SALARY + (SALARY*0.2) WHERE 
JOB_ID IN (SELECT JOB_ID FROM HR.JOBS WHERE MIN_SALARY = 6000);


/*
10. Delete the record of employees from employees_BKP who are manager and
belongs to the department ‘Finance’.
*/

DELETE FROM EMPLOYEE_BKP WHERE EMPLOYEE_ID IN 
(SELECT department_id FROM HR.DEPARTMENTS 
WHERE job_id like 'Manager' and DEPARTMENT_NAME = 'Finance'); 

/*
11.For each department that has more than five employees, retrieve the
department number and the number of its employees who are making more
than $20,000 annually.
*/

select department_id, count(DEPARTMENT_ID) as No_of_Employees 
from HR.EMPLOYEES where salary*12 < 20000 
group by DEPARTMENT_ID having COUNT(DEPARTMENT_ID) > 5; 
