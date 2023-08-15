-- Table Structure:
drop table if exists sales;
drop table if exists product;

create table product (
    product_id int primary key,
    product_name varchar(50)
);

create table sales (
    sale_id	int,
    product_id int,
    year int,
    quantity int,
    price int,
    primary key(sale_id, year),
    foreign key(product_id) references product(product_id)
);

-- Insert Query:
insert into product values (100, 'Nokia');
insert into product values (200, 'Apple');
insert into product values (300, 'Samsung');

insert into sales values (1, 100, 2008, 10, 5000);
insert into sales values (2, 100, 2009, 12, 5000);
insert into sales values (7, 200, 2011, 15, 9000);

-- MySQL Solution:
select
    product_id,
    sum(quantity) as total_quantity
from sales
group by product_id;
