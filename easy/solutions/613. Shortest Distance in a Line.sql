-- Table Structure:
drop table if exists point;
create table point (
	x int
);

-- Insert Query:
insert into point values (-1);
insert into point values (0);
insert into point values (2);

-- MySQL Solution: Complexity of O(nlogn)
with cte_points as (
	select
		*,
        row_number() over(order by x) as rn
	from point
)
select
	min(abs(p1.x - p2.x)) as shortest
from cte_points p1
join cte_points p2
on p1.rn = p2.rn+1;
