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
having sum(Amount) > 2000

--a)
Create view total_avg (date,total)
AS
Select date,count(id)
from sell
group by date
select total_avg.date,total, avg(total)
from sell,total_avg
group by total_avg.date,total


--b)
create view greatest_amount(date,sum)
as
    SELECT date,sum(amount)
    from sell
    group by date
    order by sum(amount) DESC
    LIMIT 5;
Select *
from greatest_amount;

--c)
create view tot_avg_dealer(dealer_id,total)
AS
    SELECT dealer_id,count(id)
from sell
group by dealer_id
select dealer_id,total,avg(total)
from tot_avg_dealer
group by dealer_id, total

--d)
create view dealers_earned(location,earned)
as
    select location,sum(amount*dealer.charge)
from dealer,sell
group by location
select *
from dealers_earned

--e)
create view avg_tot_location(location,total,avg)
as
select dealer.location,sum(sell.amount),avg(amount)
from dealer,sell
where dealer.id = sell.dealer_id
group by dealer.location
select *
from avg_tot_location

--f)
create view avg_tot_client(city,total,avg)
as
select client.city,sum(amount),avg(amount)
from client,sell
where client.id = sell.client_id
group by client.city
select *
from avg_tot_client

--g)
Select city,avg_tot_client.total,avg_tot_location.total
from avg_tot_client
full outer join avg_tot_location on city = location
where avg_tot_client.total > avg_tot_location.total
