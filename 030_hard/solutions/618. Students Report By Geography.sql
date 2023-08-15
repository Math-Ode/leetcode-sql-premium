-- Table Structure:
drop table if exists student;
create table student (
	name varchar(20),
    continent varchar(20)
);

-- Insert Query:
insert into student values ('Jane', 'America');
insert into student values ('Pascal', 'Europe');
insert into student values ('Xi', 'Asia');
insert into student values ('Jack', 'America');

-- MySQL Solution:
with cte_students as (
	select
		*,
		row_number() over(partition by continent order by name) as rn
	from student
)

select
	max(case when continent='America' then name end) as America,
    max(case when continent='Asia' then name end) as Asia,
    max(case when continent='Europe' then name end) as Europe
from cte_students
group by rn;
