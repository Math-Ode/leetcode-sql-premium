-- Table Structure:
drop table if exists friendrequest;
drop table if exists requestaccepted;

create table friendrequest (
	sender_id int,
  	send_to_id int,
  	request_date date
);

create table requestaccepted (
    requester_id int,
    accepter_id int,
    accept_date date
);

-- Insert Query:
insert into friendrequest values (1, 2, '2016/06/01');
insert into friendrequest values (1, 3, '2016/06/01');
insert into friendrequest values (1, 4, '2016/06/01');
insert into friendrequest values (2, 3, '2016/06/02');
insert into friendrequest values (3, 4, '2016/06/09');

insert into requestaccepted values (1, 2, '2016/06/03');
insert into requestaccepted values (1, 3, '2016/06/08');
insert into requestaccepted values (2, 3, '2016/06/08');
insert into requestaccepted values (3, 4, '2016/06/09');
insert into requestaccepted values (3, 4, '2016/06/10');

-- MySQL Solution:
select
    round(
        coalesce(
            (select count(*)*1.0 from (
                select distinct requester_id, accepter_id from requestaccepted) as temp1
            )
            /
            (select count(*) from (
                select distinct sender_id, send_to_id from friendrequest) as temp2
            ), 0.0
        ), 2
    ) as accept_rate;

-- Follow Up 1 Solution:
with cte_sent as (
    select
        year(request_date) as year,
        month(request_date) as month,
        count(distinct sender_id, send_to_id) as request_sent
    from friendrequest
    group by year, month
),

cte_accept as (
    select
        year(accept_date) as year,
        month(accept_date) as month,
        count(distinct requester_id, accepter_id) as request_accept
    from requestaccepted
    group by year, month
)

-- Performing the full outer join as it keyword doesn't supports in MySQL.
select * from (
	select
		sent.year,
		sent.month,
		coalesce(accept.request_accept / sent.request_sent, 0) as accept_rate
	from cte_sent as sent
	left join cte_accept as accept
	on sent.year = accept.year and sent.month = accept.month

	union
	
    select
		accept.year,
		accept.month,
		accept.request_accept / coalesce(sent.request_sent, 1) as accept_rate
	from cte_sent as sent
	right join cte_accept as accept
	on sent.year = accept.year and sent.month = accept.month
) as temp
order by year, month;

-- Follow Up 2 Solution:
with cte_sent as (
    select
        year(request_date) as year,
        month(request_date) as month,
        day(request_date) as day,
        count(distinct sender_id, send_to_id) as request_sent
    from friendrequest
    group by year, month, day
),

cte_accept as (
    select
        year(accept_date) as year,
        month(accept_date) as month,
        day(accept_date) as day,
        count(distinct requester_id, accepter_id) as request_accept
    from requestaccepted
    group by year, month, day
),

cte_acceptance_rate as(
	select
		sent.year,
		sent.month,
        sent.day,
		coalesce(accept.request_accept / sent.request_sent, 0) as accept_rate
	from cte_sent as sent
	left join cte_accept as accept
	on sent.year = accept.year and sent.month = accept.month and sent.day = accept.day

	union

	select
		accept.year,
		accept.month,
        accept.day,
		accept.request_accept / coalesce(sent.request_sent, 1) as accept_rate
	from cte_sent as sent
	right join cte_accept as accept
    on sent.year = accept.year and sent.month = accept.month and sent.day = accept.day
)


select
	year,
    month,
    day,
    sum(accept_rate) over(order by year, month, day) as cumulative_accept_rate
from cte_acceptance_rate;
