-- Table Structure:
drop table if exists numbers;
create table numbers (
    num int primary key,
    freq int
);

-- Insert Query:
insert into numbers values (0, 7);
insert into numbers values (1, 3);
insert into numbers values (2, 2);
insert into numbers values (3, 2);

-- MySQL Solution 1: Using recursive cte and decompressing the table
with recursive cte_uncompress as (
    select num, freq, 1 as cnt from numbers
    union all
    select num, freq, cnt+1 from cte_uncompress
    where cnt < freq
),

cte as (
    select
        *,
        row_number() over(order by num, cnt) as rn_asc,
        row_number() over(order by num desc, cnt desc) as rn_desc
    from cte_uncompress
)

select
    avg(num) as median
from cte
where rn_asc in (rn_desc-1, rn_desc, rn_desc+1);

-- Solution 2: Using Windows function and range concept:
with cte_end_range as (
    select
        *,
        sum(freq) over(order by num) as end
    from numbers
),

cte_full_range as (
    select
        num,
        freq,
        lag(end, 1, 0) over(order by num) + 1 as start,
        end,
        sum(freq) over() as total_sum
    from cte_end_range
)

select
    avg(num) as median
from cte_full_range
where ceil(total_sum/2.0) between start and end
or ceil((total_sum+1)/2.0) between start and end;
