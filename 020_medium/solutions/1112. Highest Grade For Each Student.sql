-- Table Structure:
drop table if exists enrollments;
create table enrollments (
	student_id int,
    course_id int,
    grade int,
    primary key(student_id, course_id)
);

-- Insert Query: 
insert into enrollments values (2, 2, 95);
insert into enrollments values (2, 3, 95);
insert into enrollments values (1, 1, 90);
insert into enrollments values (1, 2, 99);
insert into enrollments values (3, 1, 80);
insert into enrollments values (3, 2, 75);
insert into enrollments values (3, 3, 82);

select * from Enrollments;

-- MySQL Solution 1: Using Windows function
with cte_details as (
    select
        *,
        row_number() over(partition by student_id order by grade desc, course_id asc) as rn
    from enrollments
)

select
    student_id,
    course_id,
    grade
from cte_details
where rn = 1
order by student_id;

-- MySQL Solution 2: Without using Windows function
with cte_max_grades as (
    select
        student_id,
        max(grade) as max_grade
    from enrollments
    group by student_id
)

select 
	enroll.student_id,
    min(enroll.course_id) as course_id,
    enroll.grade
from enrollments enroll
join cte_max_grades
    on cte_max_grades.student_id = enroll.student_id
    and cte_max_grades.max_grade = enroll.grade
group by enroll.student_id, enroll.grade;
