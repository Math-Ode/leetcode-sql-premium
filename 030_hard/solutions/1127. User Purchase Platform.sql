-- Table Structure:
drop table if exists spendings;
create table spendings (
	user_id int,
    spend_date date,
    platform varchar(15),
    amount int,
    primary key(user_id, spend_date, platform)
);

-- Insert Query:
insert into spendings values (1, '2019-07-01', 'mobile', 100);
insert into spendings values (1, '2019-07-01', 'desktop', 100);
insert into spendings values (2, '2019-07-01', 'mobile', 100);
insert into spendings values (2, '2019-07-02', 'mobile', 100);
insert into spendings values (3, '2019-07-01', 'desktop', 100);
insert into spendings values (3, '2019-07-02', 'desktop', 100);

select * from spendings;

-- MySQL Solution 1: Forming details of users used both platform
with cte_dates_platform as (
	select  distinct spend_date, 'desktop' as  platform from spendings 
	union all
	select distinct spend_date, 'mobile' as platform from spendings
	union all
	select distinct spend_date, 'both' as platform from spendings
),

cte_spends_both as (
	select
		spend_date,
		user_id,
        'both' as platform
	from spendings
	group by spend_date, user_id
	having count(platform) = 2
),

cte_spends as (
	select
		spendings.user_id,
		spendings.spend_date,
		coalesce(cte.platform, spendings.platform) as platform,
		spendings.amount
	from spendings
	left join cte_spend_both as cte
        on cte.user_id = spendings.user_id
        and cte.spend_date = spendings.spend_date
)

select
	cte1.spend_date,
    cte1.platform,
    sum(coalesce(amount, 0)) as total_amount,
    count(distinct user_id) as total_users
from cte_dates_platform as cte1
left join cte_spends cte2
    on cte1.spend_date = cte2.spend_date
    and cte1.platform = cte2.platform
group by cte1.spend_date, cte1.platform
order by cte1.spend_date;

-- MySQL Solution 2:
with cte_dates_platform as (
	select distinct spend_date, 'desktop' as  platform from spendings 
	union all
	select distinct spend_date, 'mobile' as platform from spendings
	union all
	select distinct spend_date, 'both' as platform from spendings
),

cte_spends as (
	select
		user_id,
		spend_date,
        case
			when count(*) = 1 then max(platform)
			else 'both'
        end as platform,
        sum(amount) as amount
	from spendings
	group by user_id, spend_date
)

select
	cte1.spend_date,
	cte1.platform,
	sum(coalesce(cte2.amount, 0)) as total_amount,
    count(distinct user_id) as total_users
from cte_dates_platform as cte1
left join cte_spends as cte2
	on cte1.spend_date = cte2.spend_date
	and cte1.platform = cte2.platform
group by cte1.spend_date, cte1.platform
order by cte1.spend_date;
