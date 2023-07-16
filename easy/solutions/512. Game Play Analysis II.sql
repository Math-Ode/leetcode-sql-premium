-- Table Structure:
drop table if exists Activity;
create table Activity (
	player_id int,
	device_id int,
	event_date date,
	games_played int,
	primary key (player_id, event_date)
);

-- Insert Query:
insert into Activity values (1, 2, '2016-03-01', 5);
insert into Activity values (1, 2, '2016-05-02', 6);
insert into Activity values (2, 3, '2017-06-25', 1);
insert into Activity values (3, 1, '2016-03-02', 0);
insert into Activity values (3, 4, '2018-07-03', 5);

-- MySQL Solution:
with
cte_player_first_login as (
    select
	player_id,
	min(event_date) as first_login_date
    from Activity
    group by player_id
)

select
    first.player_id,
    activity.device_id
from Activity activity
join cte_player_first_login first
on first.player_id = activity.player_id
and first.first_login_date = activity.event_date
