-- Table Structure:
drop table if exists sales;
drop table if exists product;

create table product (
	product_id int primary key,
    product_name varchar(50),
    unit_price int
);

create table sales (
	seller_id int,
    product_id int,
    buyer_id int,
    sale_date date,
    quantity int,
    price int,
    foreign key(product_id) references product(product_id)
);

-- Insert Query:
insert into product values (1, 'S8', 1000);
insert into product values (2, 'G4',  800);
insert into product values (3, 'iPhone', 1400);

insert into sales values (1, 1, 1, '2019-01-21', 2, 2000);
insert into sales values (1, 2, 2, '2019-02-17', 1, 800); 
insert into sales values (2, 2, 3, '2019-06-02', 1, 800); 
insert into sales values (3, 3, 4, '2019-05-13', 2, 2800);

-- MySQL Solution:
with sale_details as (
	select
		seller_id,
        sales.product_id,
        buyer_id,
        prd.product_name
	from sales
    left join product as prd
    on prd.product_id = sales.product_id
)

select
    distinct buyer_id
from sale_details
where product_name = 'S8'
and buyer_id not in (select buyer_id from sale_details where product_name='iPhone');
