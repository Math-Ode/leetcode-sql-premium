-- Table Structure:
drop table if exists student;
drop table if exists department;

create table department (
	dept_id int primary key,
  	dept_name varchar(50)
);

create table student (
	student_id int primary key,
  	student_name varchar(20),
  	gender varchar(10),
  	dept_id int,
  	foreign key(dept_id) references department(dept_id)
);

-- Insert Query:
insert into department values (1, 'Engineering');
insert into department values (2, 'Science');
insert into department values (3, 'Law');

insert into student values (1, 'Jack', 'M', 1);
insert into student values (2, 'Jane', 'F', 1);
insert into student values (3, 'Mark', 'M', 2);

-- MySQL Solution:
with cte_student as (
    select
        dept_id,
        count(*) as student_number
    from student
    group by dept_id
)

select
	dept_name,
    coalesce(student_number, 0) as student_number
from department dept
left join cte_student std
on std.dept_id = dept.dept_id
order by student_number desc, dept_name;
