-- DDL - commands(Data Definition Language)
-- create, drop, alter  database or table
create database data_b;

create table students
(
    id      serial primary key,
    name    varchar(20),
    subject varchar(20)
);
drop table students;

alter table students
    add column age integer;

--DML insert , update, delete
insert into students(name, subject)
values ('Dimaska', 'CC');

insert into students(name, subject, age)
values ('dRuy', 'sc', 1);


update students
set subject = 'SS'
where id = 1;

delete
from students
where id = 3;
-------------------------------
create table customers
(
    id               INT GENERATED ALWAYS AS IDENTITY UNIQUE,
    full_name        VARCHAR(50) not null,
    timestamp        timestamp   not null,
    delivery_address text        not null,
    primary key (id)
);
-- drop table  product, order_items, orders, customers;

create table product
(
    id          INT GENERATED ALWAYS AS IDENTITY unique not null,
    name        varchar(100)                            not null unique,
    description text,
    price       double precision                        not null,
    primary key (id)
);


create table orders
(
    code        INT GENERATED ALWAYS AS IDENTITY unique not null,
    costumer_id int,
    total_sum   double precision                        not null CHECK ( total_sum > 0 ),
    is_paid     boolean                                 not null,
    foreign key (costumer_id) references customers (id),
    primary key (code)
);

create table order_items
(
    order_code INT,
    product_id INT,
    quantity   integer not null CHECK ( quantity > 0 ),
    foreign key (order_code) references orders (code),
    foreign key (product_id) references product (id),
    primary key (product_id, order_code)

);
--------------------------------------
create table student
(
    id                   int generated always as identity,
    full_name            varchar(60)      not null,
    age                  int              not null,
    birth_date           date             not null,
    gender               varchar(10)      not null,
    average_grade        double precision not null CHECK ( average_grade > 0 ),
    info_yourself        text,
    need_for_a_dormitory boolean          not null,
    additional_info      text,
    primary key (id)
);



create table instructor
(
    id                                   int generated always as identity,
    full_name                            varchar(60) not null,
    speaking_languages                   text,
    word_experience                      varchar(50) not null,
    possibility_of_having_remote_lessons boolean     not null,
    primary key (id)

);


create table lesson
(
    id            int generated always as identity,
    title         varchar(30),
    students      int not null ,
    instructor_id int not null ,
    room_number   int not null,
    foreign key (instructor_id) references instructor (id),
    foreign key (students) references student (id),
    primary key (id)
);
-------------------------------------------
insert into product(name, price)
values ('manga', 10.3);

insert into customers(full_name, timestamp, delivery_address)
values ('Dimashka', '2016-06-22 19:10:25-07', 'abay st.');

insert into orders(costumer_id, total_sum, is_paid)
values ((select id from customers where full_name='Dimashka' ), 13.3, true);

insert  into order_items(order_code, product_id, quantity)
values ((select code from orders where code = 1),(select id from product where id = 1),10);

update product
set description = 'asdf'
where description IS NULL;

delete from order_items where order_code = 1