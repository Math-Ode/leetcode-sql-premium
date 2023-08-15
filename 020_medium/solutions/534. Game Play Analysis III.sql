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
insert into Activity values (1, 3, '2017-06-25', 1);
insert into Activity values (3, 1, '2016-03-02', 0);
insert into Activity values (3, 4, '2018-07-03', 5);

-- MySQL Solution 1(with windows function):
select
    player_id,
    event_date,
    sum(games_played) over(partition by player_id order by event_date) as games_played
from
    Activity;

-- Solution 2(without windows function):
select
    activity1.player_id,
    activity1.event_date,
    sum(activity2.games_played) as games_played
from
    Activity activity1
join 
    Activity activity2
    on activity1.player_id = activity2.player_id
    and activity1.event_date >= activity2.event_date
group by
    activity1.player_id, activity1.event_date;
