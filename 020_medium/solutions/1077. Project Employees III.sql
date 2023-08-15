-- Table Structure:
drop table if exists project;
drop table if exists employee;

create table employee (
    employee_id	int primary key,
    name varchar(50),
    experience_years int
);

create table project (
    project_id int,
    employee_id int,
    primary key(project_id, employee_id),
    foreign key(employee_id) references employee(employee_id)
);

-- Insert Query:
insert into employee values (1, 'Khaled', 3);
insert into employee values (2, 'Ali', 2);
insert into employee values (3, 'John', 3);
insert into employee values (4, 'Doe', 2);

insert into project values (1, 1);
insert into project values (1, 2);
insert into project values (1, 3);
insert into project values (2, 1);
insert into project values (2, 4);

-- MySQL Solution 1: Using Windows function
with project_details as (
	select
		proj.project_id,
		proj.employee_id,
        emp.name,
        emp.experience_years
	from project proj
    left join employee emp
    on emp.employee_id = proj.employee_id
)

select project_id, employee_id from ( 
	select
		*,
		rank() over(partition by project_id order by experience_years desc) as rn
	from project_details
) temp
where rn = 1;

-- Solution 2: Without using Windows function
with project_details as (
	select
		proj.project_id,
		proj.employee_id,
        emp.name,
        emp.experience_years
	from project proj
    left join employee emp
    on emp.employee_id = proj.employee_id
),

max_exp_in_project as (
    select
        project_id,
        max(experience_years) as max_experience
    from project_details
    group by project_id
)

select
    prd.project_id,
    prd.employee_id
from project_details prd
inner join max_exp_in_project exp
on exp.project_id = prd.project_id
and exp.max_experience = prd.experience_years
order by prd.project_id;
