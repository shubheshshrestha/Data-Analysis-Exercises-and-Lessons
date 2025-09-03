Use parks_and_recreation;
select * from employee_demographics;

select first_name, last_name, birth_date,
age, (age + 10) * 10 + 10
from employee_demographics; 

select distinct gender
from employee_demographics;

select * 
from employee_salary 
where salary >= 50000;

select * 
from employee_demographics
-- where gender != 'female';
where birth_date > '1985-01-01';

select *
from employee_demographics
-- where birth_date > '1985-01-01' and gender = 'male';
-- where birth_date > '1985-01-01' or gender = 'male';
-- where birth_date > '1985-01-01' or not gender = 'male';
where (first_name = 'Leslie' and age = 44) or age > 55;

-- LIKE Statement
select * 
from employee_demographics
-- Where first_name like 'a___% ';
where birth_date like '1989%';

-- Group By
select *
from employee_demographics;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender;

-- select occupation, salary
-- from employee_salary
-- group by occupation, salary;

-- ORDER BY
select *
from employee_demographics
-- order by first_name DESC;
order by gender, age DESC; 

-- Having vs Where
select gender, avg(age)
from employee_demographics
group by gender
having avg(age) > 40;

select occupation, avg(salary)
from employee_salary
where occupation LIKE '%manager%'
group by occupation
having avg(salary) > 75000;

-- Limit & Aliasing
select *
from employee_demographics
order by age DESC
-- limit 3, 
limit 2, 1;

-- Aliasing
select gender, avg(age) as avg_age
from employee_demographics
group by gender
Having avg_age > 40;

-- Intermediate Lessons --

-- Joins
select *
from employee_demographics
inner join employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id;
    
select dem.employee_id, age, occupation
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
-- Outer Joins
select *
from employee_demographics as dem
left join employee_salary as sal
	on dem.employee_id = sal.employee_id; 
    
select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id; 

-- Self Join
select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_name,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary emp1
join employee_salary emp2
	on emp1.employee_id + 1 = emp2.employee_id;
    
-- Joining multiple tables together
select *
from parks_departments;

select *
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id
inner join parks_departments pd
	on sal.dept_id = pd.department_id;
    
-- Unions
select first_name, last_name
from employee_demographics
UNION ALL
select first_name, last_name
from employee_salary;
    
select first_name, last_name, 'Old Man' AS Label
from employee_demographics
where age > 40 and gender = 'Male'
Union
select first_name, last_name, 'Old Lady' AS Label
from employee_demographics
where age > 40 and gender = 'Female'
UNION
select first_name, last_name, 'Highly Paid Employee' AS Label
from employee_salary
where salary > 70000
Order by first_name, last_name;   

-- String Functions
select length('shubheshshrestha');

select first_name, length(first_name)
from employee_demographics
order by 2;

select upper('sky');
select lower('SKY');

select first_name, upper(first_name)
from employee_demographics;

select trim('   sky   ');
-- LTRIM & RTRIM

-- Substring
select first_name,
left(first_name, 4),
right(first_name, 4),
substring(first_name,3,2),
birth_date,
substring(birth_date,6,2) as birth_month
from employee_demographics;

-- Replace
select first_name, replace(first_name, 'a', 'z')
from employee_demographics; 

-- Locate
select first_name, locate('x', 'ALexander');

select first_name, locate('An', first_name)
from employee_demographics;

-- Concat
select first_name, last_name,
concat(first_name, ' ', last_name) as full_name
from employee_demographics;

-- CASE Statement
select first_name, last_name, age, 
CASE
	when age <= 30 Then 'Young'
    when age between 31 and 50 then 'Old'
    when age >= 50 then "On Death's Door"
end as age_bracket
from employee_demographics;

-- Pay Increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% Bonus

select first_name, last_name, salary,
CASE
	when salary < 50000 then salary + (salary * 0.05)
    when salary > 50000 then salary * 1.07
END as new_salary,
CASE
	when dept_id = 6 Then salary * .10
END as bonus
from employee_salary;

-- Subqueries
select *
from employee_demographics
where employee_id IN 
					(Select employee_id
                    from employee_salary
					where dept_id = 1)
; 

select first_name, salary,
(select avg(salary)
from employee_salary)
from employee_salary;

select gender, AVG(`max(age)`)
from
(select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender) as agg_table
group by gender
;

-- Window Functions

select dem.first_name, dem.last_name, gender, avg(salary) as avg_salary
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
group by dem.first_name, dem.last_name, gender
;

select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.employee_id, dem.first_name, dem.last_name, gender, salary, 
row_number() Over(partition by gender order by salary desc) as row_num,
rank() Over(partition by gender order by salary desc) as rank_num,
dense_rank() Over(partition by gender order by salary desc) as dense_rank_num
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;


-- Advanced Lessons

-- CTEs
WITH CTE_Example as 
(
select gender, avg(salary) avg_sal, max(salary) max_sal, min(salary) min_sal, count(salary) count_sal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from CTE_Example;

-- Same output but visually professional
-- select avg(avg_sal)
-- From (
-- select gender, avg(salary) avg_sal, max(salary) max_sal, min(salary) min_sal, count(salary) count_sal
-- from employee_demographics dem
-- join employee_salary sal
-- 	on dem.employee_id = sal.employee_id
-- group by gender
-- ) example_subquery;

WITH CTE_Example as 
(
select gender, employee_id, birth_date
from employee_demographics dem
where birth_date > '1985-01-01'
),
CTE_Example2 As
(
select employee_id, salary
from employee_salary
where salary > 50000
) 
select *
from CTE_Example
join CTE_Example2
	on CTE_Example.employee_id = CTE_Example2.employee_id ;

-- Temporary Tables
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

select *
from temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');

SELECT *
FROM temp_table;

select *
from employee_salary;

create temporary table salary_over_50k
select *
from employee_salary
where salary >= 50000;

select *
from salary_over_50k;

-- Stored Procedures
CREATE PROCEDURE large_salaries()
select *
from employee_salary
where salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	select *
	from employee_salary
	where salary >= 50000;
	select *
	from employee_salary
	where salary >= 10000;     
END $$
DELIMITER ;

CALL large_salaries2();

-- Parameters
DELIMITER $$
CREATE PROCEDURE large_salaries3(p_employee_id INT)
BEGIN
	SELECT salary
    FROM employee_salary
    WHERE employee_id = p_employee_id
    ;
END $$
DELIMITER ;

CALL large_salaries3(1);

-- Trigeers and Events
select *
from employee_demographics;
 
select *
from employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN 
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW. employee_id, NEW.first_name, NEW.last_name);
    END $$
DELIMITER ;   

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL); 

-- EVENTS 
select *
from employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees1
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';


