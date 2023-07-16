-- Table Structure:
drop table if exists Employee;
create table Employee (
	id int primary key,
	company varchar(50),
	salary int
);

-- Insert Query:
insert into Employee values (1, 'A', 2341);
insert into Employee values (2, 'A', 341);
insert into Employee values (3, 'A', 15);
insert into Employee values (4, 'A', 15314);
insert into Employee values (5, 'A', 451);
insert into Employee values (6, 'A', 513);
insert into Employee values (7, 'B', 15);
insert into Employee values (8, 'B', 13);
insert into Employee values (9, 'B', 1154);
insert into Employee values (10, 'B', 1345);
insert into Employee values (11, 'B', 1221);
insert into Employee values (12, 'B', 234);
insert into Employee values (13, 'C', 2345);
insert into Employee values (14, 'C', 2645);
insert into Employee values (15, 'C', 2645);
insert into Employee values (16, 'C', 2652);
insert into Employee values (17, 'C', 65);

-- MySQL Solution:
with
cte_company_emp_count as (
    select
        company,
        count(id) as emp_count
    from Employee emp
    group by company
),

cte_company_emp_rank as (
    select
        *,
        row_number() over(partition by company order by salary, id) as rn
    from Employee
)

select * from (
    select
        emp_rank.id,
        emp_cnt.company,
        emp_rank.salary
    from cte_company_emp_rank as emp_rank
    join cte_company_emp_count as emp_cnt
    on emp_cnt.company = emp_rank.company
    and (emp_count/2 = rn or (emp_count+2)/2 = rn)
    where emp_count%2=0

    union all

    select
        emp_rank.id,
        emp_cnt.company,
        emp_rank.salary
    from cte_company_emp_rank as emp_rank
    join cte_company_emp_count as emp_cnt
    on emp_cnt.company = emp_rank.company
    and (emp_count+1)/2 = rn
    where emp_count%2=1
)
order by company, salary
