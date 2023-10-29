-- Table Structure:
drop table if exists actions;
create table actions (
	user_id int,
    post_id int,
    action_date date,
    action varchar(15),
    extra varchar(15)
);

-- Insert Query:
insert into actions values (1, 1, '2019-07-01', 'view', null);
insert into actions values (1, 1, '2019-07-01', 'like', null);
insert into actions values (1, 1, '2019-07-01', 'share', null);
insert into actions values (2, 4, '2019-07-04', 'view', null);
insert into actions values (2, 4, '2019-07-04', 'report', 'spam');
insert into actions values (3, 4, '2019-07-04', 'view', null);
insert into actions values (3, 4, '2019-07-04', 'report', 'spam');
insert into actions values (4, 3, '2019-07-02', 'view', null);
insert into actions values (4, 3, '2019-07-02', 'report', 'spam');
insert into actions values (5, 2, '2019-07-04', 'view', null);
insert into actions values (5, 2, '2019-07-04', 'report', 'racism');
insert into actions values (5, 5, '2019-07-04', 'view', null);
insert into actions values (5, 5, '2019-07-04', 'report', 'racism');

select * from actions;

-- MySQL Solution:
select
	extra as report_reason,
    count(distinct post_id) as report_count
from actions
where
    action_date = date_add('2019-07-05', interval -1 day)
	and action = 'report'
group by extra;
