create table category
(
    id            int generated always as identity unique,
    category_name VARCHAR(50) not null,
    primary key (id)
);



create table product
(
    id           int generated always as identity unique,
    category_id  int,
    product_name VARCHAR(50) not null,
    price        int         not null,
    description  text,
    primary key (id),
    foreign key (category_id) references category (id)
);



create table order_item
(
    id         int generated always as identity unique,
    product_id int,
    amount     int,
    primary key (id),
    foreign key (product_id) references product (id)
);



create table customer
(
    id            int generated always as identity unique,
    first_name    varchar(30),
    last_name     varchar(30),
    date_of_birth date,

    primary key (id)
);
alter table customer
    add phone text;

delete
from customer
where first_name is null;



create table Orders
(
    id           int generated always as identity unique,
    customer_id  int,
    datetime     date,
    promise_date date,
    primary key (id),
    foreign key (customer_id) references customer (id)
);



create table order_product
(

    id            int generated always as identity unique,
    order_id      int,
    order_item_id int,
    primary key (id),
    foreign key (order_id) references Orders (id),
    foreign key (order_item_id) references order_item (id)

);


--Find the customer who has bought the most (by price) in the past year
select customer_id, first_name, sum(amount * price) as total
from order_product

         inner join order_item oi on oi.id = order_product.order_item_id
         inner join product p on oi.product_id = p.id
         inner join orders o on order_product.order_id = o.id
         inner join customer c on c.id = o.customer_id
where datetime > '02-12-2020'
group by customer_id, first_name
order by total desc
limit 1;

-- Find the top 2 products by dollar-amount sold in the past year.
select product_id, product_name, sum(price * amount) as total
from order_product

         inner join order_item oi on oi.id = order_product.order_item_id
         inner join product p on oi.product_id = p.id
         inner join orders o on order_product.order_id = o.id
         inner join customer c on c.id = o.customer_id
group by product_id, product_name
order by total desc
limit 2;
-- Find the top 2 products by unit sales in the past year
select product_id, product_name, sum(amount) as total
from order_product

         inner join order_item oi on oi.id = order_product.order_item_id
         inner join product p on oi.product_id = p.id
         inner join orders o on order_product.order_id = o.id
         inner join customer c on c.id = o.customer_id
group by product_id, product_name
order by total desc
limit 2;

--Generate the bill for each customer for the past month
select customer_id, first_name, sum(price * amount) as bill
from order_product

         inner join order_item oi on oi.id = order_product.order_item_id
         inner join product p on oi.product_id = p.id
         inner join orders o on order_product.order_id = o.id
         inner join customer c on c.id = o.customer_id
where datetime > '02-11-2021'
group by customer_id, first_name;



create table store_in_purchases
(
    id       int generated always as identity unique,
    order_id int,
    store_id int,
    primary key (id),
    foreign key (order_id) references Orders (id),
    foreign key (store_id) references stores (id)
);



create table track_num
(
    id                 int generated always as identity unique,
    track_num          int,
    order_id           int  not null,
    address_to_deliver text not null,
    primary key (id),
    foreign key (order_id) references Orders (id)
);
insert into track_num (track_num, order_id, address_to_deliver)
values (123456, 23, 'Lotheville');



create table shipper
(
    id   int generated always as identity unique,
    name varchar(30),
    primary key (id)
);



insert into shipper(name)
values ('USPS');



create table warehouse
(
    id   int generated always as identity unique,
    name varchar(30),
    primary key (id)
);


create table online_packages
(
    id         int generated always as identity unique,
    delivered  date,
    track_num  int,
    warehouse  int,
    shipper_id int,
    primary key (id),
    foreign key (track_num) references track_num (id),
    foreign key (warehouse) references warehouse (id),
    foreign key (shipper_id) references shipper (id)

);

--contents of that shipment
select product_id, product_name, amount, order_item_id, tn.order_id
from order_product
         inner join track_num tn on order_product.order_id = tn.order_id
         inner join order_item oi on order_product.order_item_id = oi.id
         inner join product p on oi.product_id = p.id
         inner join online_packages op on tn.id = op.track_num
         inner join shipper s on op.shipper_id = s.id
    and tn.track_num = 123456 and name = 'USPS';

-- contact information for the customer
select first_name, last_name, date_of_birth
from order_product
         inner join track_num tn on order_product.order_id = tn.order_id
         inner join order_item oi on order_product.order_item_id = oi.id
         inner join product p on oi.product_id = p.id
         inner join online_packages op on tn.id = op.track_num
         inner join shipper s on op.shipper_id = s.id
         inner join customer on category_id = customer.id
    and tn.track_num = 123456 and name = 'USPS';

--isnerting
insert into order_product(order_id, order_item_id)
values(13, 67);



create table stores
(
    id       int generated always as identity unique,
    name     varchar(30),
    location varchar(30)
);



create table stores_product_amount
(
    stores_id  int,
    product_id int,
    amount     int,
    primary key (stores_id, product_id),
    foreign key (stores_id) references stores (id),
    foreign key (product_id) references product (id)
);



create view a as
select product_name
from stores_product_amount as s1
         inner join stores s on s1.stores_id = s.id
         inner join product p on p.id = s1.product_id
where location = 'California';

--only california products
select *
from a;
--all products
select product_name
from product;


-- Find those products that are out-of-stock at every store in California.
select product_name
from product
where product_name not in (select * from a);

create table manufacturer
(
    id                int generated always as identity unique,
    manufacturer_name varchar(30)
);

-- contact information for the customer
select * from
orders
    inner join track_num tn on Orders.id = tn.order_id
    inner join online_packages op on tn.id = op.track_num
where promise_date > delivered;