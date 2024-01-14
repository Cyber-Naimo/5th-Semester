/*
1. Write a query to list the name, job name, department name, salary of the employees
according to the department in ascending order.
*/
SELECT E.first_name||' '||E.last_name AS FULLNAME,J.JOB_TITLE,D.DEPARTMENT_NAME,E.SALARY
FROM EMPLOYEES E,JOBS J,DEPARTMENTS D
WHERE E.JOB_ID = J.JOB_ID AND E.DEPARTMENT_ID = D.DEPARTMENT_ID ORDER BY D.DEPARTMENT_NAME;

-- 2. Write a query to list the department where at least two employees are working.

select d.department_name,d.DEPARTMENT_ID from EMPLOYEES e,DEPARTMENTS d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID
group by d.DEPARTMENT_NAME,d.DEPARTMENT_ID having count(*)>1;

-- 3.  Fetch all the records where salary of employee is less than the lower salary.

-- If you are considering lower salary as min(salary)
select e.first_name||' '||e.last_name as Name,e.employee_id,e.salary
from EMPLOYEES e where e.salary < (select min(salary) from EMPLOYEES);
-- Recommended one
select e.first_name||' '||e.last_name as Name,e.employee_id,e.salary
from EMPLOYEES e,JOBS j where e.job_ID = j.job_id and e.salary < j.MIN_SALARY;

/*
Write a query to list the name, job name, annual salary, department id, department name and city
who earn 60000 in a year or not working as an ANALYST.
*/
select e.first_name||' '||e.last_name as Name,j.job_title,e.salary *12 as Annual_Salary,d.department_id,
d.department_name,l.city
from EMPLOYEES e,DEPARTMENTS d,JOBS j,LOCATIONS l
where e.department_id = d.DEPARTMENT_ID and e.job_id = j.job_id and d.LOCATION_ID = l.LOCATION_ID
and (e.salary*12 > 60000) or j.JOB_TITLE not like 'ANALYST';


-- 5. Write a query to print details of the employees who are also Managers.
select e.first_name||' '||e.last_name as Name,e.job_id,e.salary
from EMPLOYEES e where e.EMPLOYEE_ID in (select MANAGER_ID from EMPLOYEES); 

-- from below method its giving wrong ans because it can easily achieve without joins just check empl_id in mana_id
select e.first_name||' '||e.last_name as Name,e.job_id,e.salary from EMPLOYEES e,EMPLOYEES m
where e.EMPLOYEE_ID = m.MANAGER_ID; 

/*
6. List department number, Department name for all the departments 
in which there are no employees in the department.
*/
select d.department_name,d.department_id from 
DEPARTMENTS d left join EMPLOYEES e on d.DEPARTMENT_ID = e.DEPARTMENT_ID
where e.DEPARTMENT_ID is null;

/*
7. Display employee name, salary, department name where all employees
has matching department as well as employee does not have any
departments.
*/

select e.first_name || ' ' || e.last_name as Name,e.salary,d.department_name
from EMPLOYEES e,DEPARTMENTS d
where e.department_id = d.DEPARTMENT_ID and e.department_id is null;

/*
8. Display name, job ID, department name, street address and city of the
employee in which there is no state province.
*/
select e.first_name || ' ' || e.last_name as Name,d.department_name,l.street_address,l.city
from EMPLOYEES e,DEPARTMENTS d,LOCATIONS l
where e.department_id = d.DEPARTMENT_ID and d.LOCATION_ID = l.LOCATION_ID and l.state_province is null;

/*
9. Write an SQL query to show records from one table that another table
does not have.
*/
select e.department_id from EMPLOYEES e where e.department_id not in (select d.department_id from DEPARTMENTS d);

/*
10. Display all employees who belong to country US but not belongs to
state province Washington.
*/

select * from EMPLOYEES e,COUNTRIES c,LOCATIONS l,DEPARTMENTS d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID and d.LOCATION_ID = l.LOCATION_ID and l.COUNTRY_ID = c.COUNTRY_ID and
c.country_name like 'US' and l.state_province not like 'Washington';
