set serveroutput on;
/*
1. Create a PL/SQL block that computes and prints the bonus amount for a given Employee based on the employee’s salary. Accept the employee number as user input with a SQL*Plus substitution Variable. 
a. If the employee’s salary is less than 1,000, set the bonus amount for the b. Employee to 10% of the salary. 
c. If the employee’s salary is between 1,000 and 1,500, set the bonus amount for the employee to 15% of the salary. 
d. If the employee’s salary exceeds 1,500, set the bonus amount for the employee to 20% of the salary. 
e. If the employee’s salary is NULL, set the bonus amount for the employee to 0. 2. 

*/
DECLARE 
    enum integer;
    esal integer;
BEGIN
    enum:=&enum;
    select salary into esal from employees where employee_id = enum;
    if(esal<1000) THEN
        esal := esal+(esal*0.1);
    ELSIF(esal>= 1000 and esal<=1500) THEN
        esal := esal+(esal*0.15);
    ELSIF(esal> 1500) THEN
        esal := esal+(esal*0.20);
    ELSE
        esal := 0;
    END IF;    
    dbms_output.put_line('Incremented salary is: '||esal);    
END;
/
/*
2. Write a pl/sql block in sql that ask a user for employee id than it checks its commission 
if commission is null than it updates salary of that employee by adding commission into salary. 
*/
DECLARE 
    enum integer;
    esal integer;
    ecom float;
BEGIN
    enum:=&enum;
    select salary into esal from employees where enum=employee_id;
    select commission_pct into ecom from employees where enum = employee_id;
    if (ecom is not null) THEN
        esal := esal+(esal*ecom);
        update employees set salary = esal where enum=employee_id;
    else
        dbms_output.put_line('Commission is 0 ');
    end if;
END;
/
/*
3. Write a PL/SQL block to obtain the department name of the employee who works for deptno 30 
*/
select * from DEPARTMENTS WHERE DEPARTMENT_ID = 30;
select D.department_name AS dep_name from EMPLOYEES E,DEPARTMENTS D
    where E.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = 30;
declare
    dep_name varchar2(30);
begin
    for v in (select D.department_name into dep_name from EMPLOYEES E,DEPARTMENTS D
    where E.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = 30)
    loop
    --select department_name into dep_name from HR.DEPARTMENTS where DEPARTMENT_ID = 30;
        DBMS_OUTPUT.PUT_LINE('NAME: ' || v.department_name);
    end loop;
end;
/


/*
4. Write a PL /SQL block to find the nature of job 
of the employee whose deptno is 20(to be passed as an argument) 
*/

create or replace procedure get_Job_Nature(dnum in INTEGER)
as 
    dep_num integer;
    job_nature varchar(30);
begin
    dep_num := dnum;
    for v in (select employee_id,job_id from HR.EMPLOYEES where department_id = dep_num)
    loop
        dbms_output.put_line('Employee ' || v.employee_id || ' Job id is: ' || v.job_id);
    end loop;
end;
/
exec get_Job_Nature(20);

-- 5. Write a PL /SQL block to find the salary of the employee who is working in the deptno 20(to be passed as an argument). 

select * from HR.EMPLOYEES where department_id = 20;
create or replace procedure get_salary(dnum in integer)
as
begin
    for v in (select employee_id,salary from HR.EMPLOYEES where department_id = dnum)
    loop
        dbms_output.put_line('Employee ' || v.employee_id || ' Salary : ' || v.salary);
    end loop;
end;
/
exec GET_SALARY(20);

/*
6. Write a PL/SQL block to update the salary of the employee with a 10% increase
whose empno is to be passed as an argument for the procedure 
*/
create or replace procedure updateSalary (empno in integer)
as
    
BEGIN
    update hr.employees set salary = salary+(salary*10) where employee_id=empno;
    dbms_output.put_line('Salary Updated!');  
END;
/
exec updateSalary(100);

/*
7. Write a procedure to add an amount of Rs.1000 for the employees
whose salaries is greater than 5000 and who belongs to the deptno passed as an argument.
*/
create or replace procedure Increase_Sal(dep_no in integer)
as
begin
    for v in (select salary from HR.EMPLOYEES where DEPARTMENT_ID = dep_no)
    loop
        if(v.salary > 5000) then
            update HR.employees set salary = v.salary+1000;
            DBMS_OUTPUT.PUT_LINE('Salary updated');
        end if;
    end loop;
end;
/
create or replace procedure getSalary (dnum in integer)
as 
BEGIN
    update hr.employees set salary = salary+1000 where salary>5000 and department_id=dnum;  
    DBMS_OUTPUT.PUT_LINE('Salary updated');
END;
/
exec getSalary(20);
exec Increase_Sal(20);

/*
 8. Create views for following purposes:- 
a. Display each designation and number of employees with that particular designation. 
b. The organization wants to display only the details like empno, empname , deptno , deptname of all the employee except king. 
c. The organization wants to display only the details empno, empname, deptno, deptname of the employees. 

*/

-- a. Display each designation and number of employees with that particular designation. 
create or replace view count_emp as
select job_id as designation, count(*) as emp_count from hr.employees group by job_id;
select * from count_emp;

-- b. The organization wants to display only the details like empno, empname , deptno , deptname of all the employee except king. 
create or replace view org as
select e.employee_id as empno, e.First_name||' '||e.last_name as empname, e.department_id as deptno, d.department_name as deptname 
from EMPLOYEES e join DEPARTMENTS d on e.DEPARTMENT_ID=d.DEPARTMENT_ID where e.LAST_NAME not like 'king';
select * from org;

-- c. The organization wants to display only the details empno, empname, deptno, deptname of the employees. 
create or replace view org1 as
select e.employee_id as empno, e.First_name||' '||e.last_name as empname, e.department_id as deptno, d.department_name as deptname 
from EMPLOYEES e join DEPARTMENTS d on e.DEPARTMENT_ID=d.DEPARTMENT_ID;
select * from org1;

/*
9. Write a PL/SQL code that takes two inputs from user, add them and store the sum in new
variable and show the output.
*/
create or replace function Sum_of_two(n1 in number,n2 in number)
return number
is
temp number;
begin
    temp := n1+n2;
    return (temp);
end;
/
select sum_of_two(3,5) from dual;

/*
10. Write a PL/SQL code that takes two inputs, lower boundary and upper boundary, then
print the sum of all the numbers between the boundaries INCLUSIVE.
*/
create or replace function Boundry_sum(n1 in number,n2 in number)
return number
is
temp number := 0;
begin
    FOR v IN n1..n2 LOOP
        temp := temp+v;
    END LOOP;
    
    dbms_output.put_line('Sum = ' || temp);
    return (temp);
end;
/

select Boundry_sum(1,100) from dual;

/*
11. Write a PL/SQL code to retrieve the employee name, hiredate, and the department name in which he works,
whose number is input by the user.
*/
select * from EMPLOYEES;
declare 
    emp_name varchar(30);
    hiredate date;
    dep_name varchar(30);
    emp_no number;
begin
    emp_no := &emp_no;
    select e.first_name,e.hire_date,d.department_name into emp_name,hiredate,dep_name
    from EMPLOYEES e,DEPARTMENTS d 
    WHERE e.EMPLOYEE_ID = d.DEPARTMENT_ID and e.EMPLOYEE_ID = emp_no;
    
    DBMS_OUTPUT.PUT_LINE('FIRST NAME : ' || emp_name); 
end;
/

CREATE OR REPLACE FUNCTION Reverse_num(num IN NUMBER)
RETURN NUMBER
IS
    original_num NUMBER := num;
    reverse_no NUMBER := 0;
    reminder NUMBER;
BEGIN
    WHILE (original_num > 0)
    LOOP
        reminder := MOD(original_num, 10);
        reverse_no := (reverse_no * 10) + reminder;
        original_num := TRUNC(original_num / 10);
    END LOOP;

    RETURN reverse_no;
END;
/

DECLARE
    num NUMBER;
    temp NUMBER;
BEGIN
    num := &num;
    temp := Reverse_num(num);
    DBMS_OUTPUT.PUT_LINE('Revrse: ' || temp);
    IF (temp = num) THEN
        DBMS_OUTPUT.PUT_LINE('Palindrome');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NOT Palindrome');
    END IF;
END;
/

/*
13.
Write a PL/SQL code that takes all the required inputs from the user for the Employee
table and then insert it into the Employee and Department table in the database.
*/

select* from DEPARTMENTS;
declare
    dep_id departments.department_id%type;
    dep_name departments.department_name%type;
    man_id departments.manager_id%type;
    loc_id departments.location_id%type;
begin
    dep_id := &dep_id;
    dep_name := '&dep_name';
    man_id := &man_id;
    loc_id := &loc_id;
    
    insert into Departments values (dep_id,dep_name,man_id,loc_id);
    dbms_output.put_line('Record Inserted');
end;
/
/*
14. Write a PL/SQL code to find the first employee who has a salary over $2500 and is higher in
the chain of command than employee 7499. Note: For chain, use of LOOP is necessary.
*/
select * from EMPLOYEES;
DECLARE
    v_employee_id  employees.employee_id%TYPE;
    v_employee_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_manager_id employees.manager_id%TYPE;
BEGIN
    -- Start with the employee with ID 7499
    v_employee_id := 200;
    
    LOOP
        -- Get the details of the current employee
        SELECT employee_id, last_name, salary, manager_id
        INTO v_employee_id, v_employee_name, v_salary, v_manager_id
        FROM employees
        WHERE employee_id = v_employee_id;

        -- Check if the salary is over $2500
        IF v_salary > 2500 THEN
            -- Output the details of the first employee meeting the criteria
            DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id);
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);
            DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
            DBMS_OUTPUT.PUT_LINE('Manager ID: ' || v_manager_id);
            EXIT; -- Exit the loop once a matching employee is found
        END IF;

        -- Move up the chain of command to the manager
        v_employee_id := v_manager_id;

        -- Exit the loop if the manager ID is NULL, indicating no more managers
        IF v_manager_id IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('No matching employee found.');
            EXIT;
        END IF;
    END LOOP;
END;
/

-- Write a PL/SQL code to print the sum of first 100 numbers.
select Boundry_sum(1,100) from dual;









