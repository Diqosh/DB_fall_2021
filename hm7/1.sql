--1. In Postgres, Large Objects (also known as BLOBs) are used to hold data in the database that cannot be stored in a normal SQL table. They are stored in a separate table in a special format
--2.
--a
create role accountant;
create role administrator;
create role support;

--b
CREATE USER dimashka WITH ROLE administrator;
CREATE USER zhasikone WITH ROLE support;
CREATE USER kuanishbek WITH ROLE accountant;

--c
Alter user dimashka CREATEROLE;
--d
REVOKE GRANT OPTION FOR SELECT ON accounts FROM dimashka

--3.b
ALTER TABLE accounts ALTER COLUMN customer_id SET NOT NULL;

--5
--a
CREATE UNIQUE INDEX index_
ON accounts (currency,customer_id)

--b
CREATE INDEX index2
ON transactions (src_account, dst_account)

--6. Write a SQL transaction that illustrates money transaction from oneaccount to another:
--a)create transaction with “init” status
-- start a transaction
BEGIN;
UPDATE accounts SET balance = balance - 100.00
    WHERE account_id = 'AB10203';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE account_id = 'DK12000';
--not correct currency
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE account_id = 'NK90123';
SELECT account_id,customer_id,balance
    from accounts
--COMMIT;