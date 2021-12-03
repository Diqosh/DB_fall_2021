--1. In Postgres, Large Objects (also known as BLOBs) are used to hold data in the database that cannot be stored in a normal SQL table. They are stored in a separate table in a special format
--2.
--a

create role accountant;
create role administrator;
create role support;

--a--c
CREATE USER dimashka WITH ROLE administrator;

grant All privileges on accounts to dimashka;
grant All privileges on customers to dimashka;
grant All privileges on transactions to dimashka;

CREATE USER zhasikone WITH ROLE support;

grant update, insert, select on accounts to zhasikone;
grant update, insert, select on customers to zhasikone;
grant update, insert, select on transactions to zhasikone;

CREATE USER kuanishbek WITH ROLE accountant;

grant select on accounts to kuanishbek;
grant select on customers to kuanishbek;
grant select on transactions to kuanishbek;



REVOKE ALL ON accounts FROM PUBLIC;
REVOKE ALL ON customers FROM PUBLIC;
REVOKE ALL ON transactions FROM PUBLIC;
--c

Alter user dimashka CREATEROLE;

--d
REVOKE select on accounts FROM dimashka;

--3.b

ALTER TABLE accounts ALTER COLUMN customer_id SET NOT NULL;

--5

--a
CREATE UNIQUE INDEX index_
ON accounts (currency,customer_id);

--b
CREATE INDEX index2
ON transactions (src_account, dst_account);

--6. Write a SQL transaction that illustrates money transaction from oneaccount to another:
--a)create transaction with “init” status
-- start a transaction


BEGIN;
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance - 100.00
    WHERE account_id = 'AB10203';



UPDATE accounts SET balance = balance + 100.00
    WHERE account_id = 'DK12000';

ROLLBACK TO my_savepoint;

UPDATE accounts SET balance = balance + 100.00
    WHERE account_id = 'NK90123';

SELECT account_id,customer_id,balance
    from accounts
COMMIT;