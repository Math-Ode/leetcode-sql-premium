-- Table Structure:
drop table if exists employee;
create table employee (
	id int,
  	month int,
  	salary int,
  	primary key(id, month)
);

-- Insert Query:
insert into employee values (1, 1, 20);
insert into employee values (2, 1, 20);
insert into employee values (1, 2, 30);
insert into employee values (2, 2, 30);
insert into employee values (3, 2, 40);
insert into employee values (1, 3, 40);
insert into employee values (3, 3, 60);
insert into employee values (1, 4, 60);
insert into employee values (3, 4, 70);
insert into employee values (1, 7, 90);
insert into employee values (1, 8, 90);

-- MySQL Solution 1: Self join 3 times, it works well for 3 months but if it is for 6 months then we have to do self join 5 times.
with cte_running_salary as (
	select
		e1.id,
        e1.month,
		e1.salary + coalesce(e2.salary, 0) + coalesce(e3.salary, 0) as 3month_salary
	from employee e1
	left join employee e2
	on e1.id = e2.id and e1.month = e2.month+1
	left join employee e3
	on e1.id = e3.id and e1.month = e3.month+2
)

select id, month, 3month_salary as salary from (
	select
		*,
		row_number() over(partition by id order by month desc) as rn
	from cte_running_salary
) as temp
where rn <> 1
order by id, month desc;

-- Solution 2: Best solution using self join only once
with cte_running_salary as (
	select
		e1.id,
        e1.month,
		sum(e2.salary) as 3month_salary
	from employee e1
	left join employee e2
	on e2.id = e1.id
    and e2.month between e1.month-2 and e1.month
	group by e1.id, e1.month
)

select id, month, 3month_salary as salary from (
	select
		*,
		row_number() over(partition by id order by month desc) as rn
	from cte_running_salary
) as temp
where rn <> 1
order by id, month desc;

-- Solution 3: Using subquery for the select column(other version of writing solution 2)
with cte_running_salary as (
	select
		*,
		(select sum(salary) from employee e2
		where e2.id = e1.id
		and e2.month between e1.month-2 and e1.month) as 3month_salary
	from employee e1
)

select id, month, 3month_salary as salary from (
	select
		*,
		row_number() over(partition by id order by month desc) as rn
	from cte_running_salary
) as temp
where rn <> 1
order by id, month desc;
