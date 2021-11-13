-- 1.a
    select *
    from client
        inner join dealer as d
        on d.id = client.dealer_id;

--1.b
    select *
    from sell
        inner join client c on c.id = sell.client_id
        inner join dealer d on c.dealer_id = d.id;

--1.c
    select *
    from client inner join dealer on client.city = dealer.location;

--1.d
    select *
    from sell inner join client as c
        on c.id = sell.client_id
    where sell.amount between 100 and 500;

--1.e
    select dealer_id, count(client.id) as num_of_clients
        from dealer
            left join client on dealer.id = client.dealer_id
            group by (dealer_id);

--1.f

    select client.name, client.city,dealer.name,dealer.charge
        from client
            inner join dealer  on dealer.id = client.dealer_id;

--1.g
    select *
        from client
            inner join dealer  on dealer.id = client.dealer_id
        where dealer.charge > 0.12;

--1.h
    select client_id, count(client_id) as made_purchase
        from sell
            inner join client  on client.id = sell.client_id
                inner join dealer  on client.dealer_id = dealer.id
        group by (client_id);

--1.i


select sell.client_id, client.name, client.priority, dealer.name,sell.id,sell.amount
from sell
inner join client on sell.client_id = client.id
inner join dealer on sell.dealer_id = dealer.id
Where priority is not Null
group by sell.client_id, client.name, client.priority, dealer.name, sell.id
having sum(Amount) > 2000;

--a)




create view a as
select  date,  count(distinct (client_id)) as unique_client, sum(amount) as total, avg(amount) as avg
from sell
group by  date
order by  date;

select * from a;
drop view a;

--b)

create view b(date,sum)
as
    SELECT date,sum(amount)
    from sell
    group by date
    order by sum(amount) DESC
    LIMIT 5;
Select *
from b;
drop view b;


--2c
CREATE VIEW c AS
    select dealer_id, count(id) dealer_sale, avg(amount) avg_of_sales, sum(amount) as total
    from sell
    group by dealer_id;

SELECT * from c;
DROP VIEW c;

--2d
create view d as
select dealer_id, sum(amount)
from sell inner join dealer on
        sell.dealer_id = dealer.id
group by dealer_id;

create view d1 as
select  location, sum(d.sum*dealer.charge)
from d inner join dealer on d.dealer_id = dealer.id
group by location;


SELECT * from d1;
DROP VIEW d1;
DROP VIEW d;

--2e
create view e as
select location, count(sell.id), avg(amount), sum(amount) as tot
from sell
inner join dealer on
    dealer_id = dealer.id
group by location;
select * from e;
drop view e;

--2f
create view f as
select city, count(sell.id), avg(amount), sum(amount) as total
from sell
inner join client on
    sell.client_id = client.id
group by city;
select * from f;
drop view f;


--2g
CREATE VIEW g AS
    SELECT f.city
    FROM e INNER JOIN f on e.location = f.city
    WHERE f.total>e.tot;

SELECT * from g;
DROP VIEW g;