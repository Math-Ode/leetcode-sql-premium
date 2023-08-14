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
insert into employee values (3, 'John', 1);
insert into employee values (4, 'Doe', 2);

insert into project values (1, 1);
insert into project values (1, 2);
insert into project values (1, 3);
insert into project values (2, 1);
insert into project values (2, 4);

-- MySQL Solution:
with project_details as (
	select
		project_id,
        count(employee_id) as total_emp
	from project
    group by project_id
)

select 
	project_id
from project_details
where total_emp = (
    select max(total_emp) from project_details
);
