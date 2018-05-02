@chcp 866
cls
echo off

:: Run this when the master is not ready
:: Run again when what?

:: change slave IP by copying OpenVPN configs
:: ???

:: make slave work as a master
pg_ctl promote -D "C:\Program Files\PostgreSQL\10\data"

::needed! for great justice
(
echo select pg_drop_replication_slot('slot_1'^^^);
) | psql -U postgres

copy "C:\Program Files\PostgreSQL\10\data\postgresql.conf.master" "C:\Program Files\PostgreSQL\10\data\postgresql.conf"

::when srv2 wakes up

net stop postgresql-x64-10
net start postgresql-x64-10

(
echo select pg_create_physical_replication_slot('slot_1'^^^);
) | psql -U postgres

pause