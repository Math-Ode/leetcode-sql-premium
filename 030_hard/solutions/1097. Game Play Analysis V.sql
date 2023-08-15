-- Table Structure:
drop table if exists activity;

create table activity (
	player_id int,
    device_id int,
    event_date date,
    games_played int,
    primary key(player_id, event_date)
);

-- Insert Query:
insert into activity values (1, 2, '2016-03-01', 5);
insert into activity values (1, 2, '2016-03-02', 6);
insert into activity values (2, 3, '2017-06-25', 1);
insert into activity values (3, 1, '2016-03-01', 0);
insert into activity values (3, 4, '2016-07-03', 5);

-- MySQL Solution:
with activities as (
    select
        *,
        row_number() over (partition by player_id order by event_date) as rn
    from activity
),

install_details as (
    select
        act1.player_id,
        act1.event_date,
        case
            when act2.player_id is not null then 1 else 0
        end as is_retained
    from activities as act1
    left join activities as act2
    on act1.player_id = act2.player_id
    and act1.event_date = date_add(act2.event_date, interval - 1 day)
    where act1.rn = 1
)

select
    event_date,
    count(*) as installs,
    round(
        count(case when is_retained = 1 then 1 end) * 1.0 / count(*), 2
    ) as day1_retention
from install_details
group by event_date
order by event_date;
