-- Table Structure:
drop table if exists orders;
drop table if exists books;

create table books (
	book_id int primary key,
    name varchar(50),
    available_from date
);

create table orders (
	order_id int primary key,
    book_id int,
    quantity int,
    dispatch_date date,
    foreign key(book_id) references books(book_id)
);

-- Insert Query:
insert into books values (1, 'Kalila And Demna', '2010-01-01');
insert into books values (2, '28 Letters', '2012-05-12');
insert into books values (3, 'The Hobbit', '2019-06-10');
insert into books values (4, '13 Reasons Why', '2019-06-01');
insert into books values (5, 'The Hunger Games', '2008-09-21');

insert into orders values (1, 1, 2, '2018-07-26');
insert into orders values (2, 1, 1, '2018-11-05');
insert into orders values (3, 3, 8, '2019-06-11');
insert into orders values (4, 4, 6, '2019-06-05');
insert into orders values (5, 4, 5, '2019-06-20');
insert into orders values (6, 5, 9, '2009-02-02');
insert into orders values (7, 5, 8, '2010-04-13');

-- MySQL Solution:
select
	*
from books
where available_from < date_add('2019-06-23', interval -1 month)
and book_id not in (
	select
		book_id
	from orders
	where dispatch_date > date_add('2019-06-23', interval -1 year)
	group by book_id
	having sum(quantity) >= 10
);
