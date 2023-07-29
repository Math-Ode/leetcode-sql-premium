-- Table Structure:
drop table if exists follow;
create table follow (
	followee varchar(20),
	follower varchar(20),
    primary key (follower, followee)
);

-- Insert Query:
insert into follow values ('Alice', 'Bob');
insert into follow values ('Bob', 'Cena');
insert into follow values ('Bob', 'Donald');
insert into follow values ('Donald', 'Edward');

-- MySQL Solution:
with cte_followed_by as (
	select
		followee,
        count(*) as num_of_followers
	from follow
    group by followee
),

cte_followers as (
	select distinct
		follower
	from follow
)

select
	followed.followee,
    num_of_followers
from cte_followed_by followed
join cte_followers followers
on followed.followee = followers.follower
order by followed.followee;
