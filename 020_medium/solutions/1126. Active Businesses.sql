-- Table Structure:
drop table if exists events;
create table events (
	business_id int,
    event_type varchar(15),
    occurences int,
    primary key(business_id, event_type)
);

-- Insert Query:
insert into events values (1, 'reviews', 7);
insert into events values (3, 'reviews', 3);
insert into events values (1, 'ads', 11);
insert into events values (2, 'ads', 7);
insert into events values (3, 'ads', 6);
insert into events values (1, 'page views', 3);
insert into events values (2, 'page views', 12);

select * from events;

-- MySQL Solution:
with cte_events_average_occurence as (
    select
        event_type,
        avg(occurences) as avg_occurence
    from events
    group by event_type
)

select
    events.business_id
from events
left join cte_events_average_occurence cte
    on events.event_type = cte.event_type
where events.occurences > cte.avg_occurence
group by events.business_id
having count(events.event_type) > 1;
