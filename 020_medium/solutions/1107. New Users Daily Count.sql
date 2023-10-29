-- Table Structure:
drop table if exists traffic;
create table traffic (
	user_id int,
    activity varchar(10),
    activity_date date
);

-- Insert Query:
insert into traffic values (1, 'login', '2019-05-01');
insert into traffic values (1, 'homepage', '2019-05-01');
insert into traffic values (1, 'logout', '2019-05-01');
insert into traffic values (2, 'login', '2019-06-21');
insert into traffic values (2, 'logout', '2019-06-21');
insert into traffic values (3, 'login', '2019-01-01');
insert into traffic values (3, 'jobs', '2019-01-01');
insert into traffic values (3, 'logout', '2019-01-01');
insert into traffic values (4, 'login', '2019-06-21');
insert into traffic values (4, 'groups', '2019-06-21');
insert into traffic values (4, 'logout', '2019-06-21');
insert into traffic values (5, 'login', '2019-03-01');
insert into traffic values (5, 'logout', '2019-03-01');
insert into traffic values (5, 'login', '2019-06-21');
insert into traffic values (5, 'logout', '2019-06-21');

-- MySQL Solution 1: Using Windows function
with cte_logins as (
    select
        *,
        row_number() over(partition by user_id order by activity_date) as rn
    from traffic
    where activity = 'login'
)

select
    activity_date as login_date,
    count(*) as user_count
from cte_logins
where activity_date >= date_add('2019-06-30', interval -90 day)
and rn = 1
group by activity_date
order by activity_date;

-- MySQL Solution 2: Without using Windows function
with cte_first_logins as (
    select
        user_id,
        min(activity_date) as first_login_date
    from traffic
    where activity = 'login'
    group by user_id
)

select
    first_login_date as login_date,
    count(*) as user_count
from cte_first_logins
where first_login_date >= date_add('2019-06-30', interval -90 day)
group by first_login_date
order by first_login_date;
