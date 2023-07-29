-- Table Structure:
drop table if exists salary;
drop table if exists employee;

create table employee (
	employee_id int primary key,
    department_id int
);

create table salary (
	id int primary key,
    employee_id int,
    amount int,
    pay_date date,
    foreign key(employee_id) references employee(employee_id)
);

-- Insert Query:
insert into employee values (1, 1);
insert into employee values (2, 2);
insert into employee values (3, 2);

insert into salary values (1, 1, 9000, '2017/03/31');
insert into salary values (2, 2, 6000, '2017/03/31');
insert into salary values (3, 3, 10000, '2017/03/31');
insert into salary values (4, 1, 7000, '2017/02/28');
insert into salary values (5, 2, 6000, '2017/02/28');
insert into salary values (6, 3, 8000, '2017/02/28');

-- MySQL Solution:
with cte_emp_details as(
	select
        sal.employee_id,
        emp.department_id,
        sal.amount,
        date_format(sal.pay_date, '%Y-%m') as month
    from salary as sal
    left join employee as emp
    on sal.employee_id = emp.employee_id
),

cte_avg_calc as (
	select
		*,
        avg(amount) over(partition by month) as cmpny_month_avg,
        avg(amount) over(partition by month, department_id) as dept_month_avg
	from cte_emp_details
)

select
	month,
    department_id,
    max(case
		when cmpny_month_avg = dept_month_avg then 'same'
		when cmpny_month_avg < dept_month_avg then 'higher'
		else 'lower'
    end) as comparison
from cte_avg_calc
group by month, department_id
order by department_id, month;
