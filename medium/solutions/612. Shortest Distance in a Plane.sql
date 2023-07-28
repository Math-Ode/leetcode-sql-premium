-- Table Structure:
drop table if exists point2d;
create table point2d (
	x int,
	y int,
    primary key (x, y)
);

-- Insert Query:
insert into point2d values (-1, -1);
insert into point2d values (0, 0);
insert into point2d values (-1, -2);

-- MySQL Solution 1: Using Cross join
select
	round(sqrt(power(p2.x-p1.x, 2) + Power(p2.y-p1.y, 2)), 2) as shortest
from point2d p1
cross join point2d p2
where p1.x != p2.x or p1.y != p2.y
order by shortest
limit 1;

-- Solution 2: First marking each row and then joining by > sign to avoid (p1,p2)=>(p2,p1) joins.
with cte_points as (
	select
		*,
        row_number() over() as rn
	from point2d
)

select
	round(sqrt(power(p2.x-p1.x, 2) + Power(p2.y-p1.y, 2)), 2) as shortest
from cte_points p1
join cte_points p2
on p1.rn > p2.rn
order by shortest
limit 1;
