-- Table Structure:
drop table if exists cinema;
create table cinema (
	seat_id int primary key auto_increment,
  	free bool
);

-- Insert Query:
insert into cinema values (1, 1);
insert into cinema values (2, 0);
insert into cinema values (3, 1);
insert into cinema values (4, 1);
insert into cinema values (5, 1);

-- MySQL Solution 1: Using abs() to join up and down at a time.
select distinct seat_id from (
	select
		c1.seat_id,
        c1.free as curr,
        c2.free as prev_or_next
	from cinema c1
	join cinema c2
    on abs(c1.seat_id - c2.seat_id) = 1
    where c1.free = 1 and c2.free = 1
) as temp
order by seat_id;

-- Solution 2:
select seat_id from (
	select
		c1.*,
		c2.free as prev,
		c3.free as next
	from cinema c1
	left join cinema c2
	on c1.seat_id = c2.seat_id+1
	left join cinema c3
	on c1.seat_id = c3.seat_id-1
) as temp
where free=1 and (prev=1 or next=1)
order by seat_id;
