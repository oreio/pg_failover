@chcp 866
cls
echo off

:: change slave IP by copying OpenVPN configs

net stop postgresql-x64-10

::rmdir /s /q "C:\Program Files\PostgreSQL\10\data"
::mkdir "C:\Program Files\PostgreSQL\10\data"

del /s /f /q "C:\Program Files\PostgreSQL\10\data"
for /f %f in ('dir /ad /b "C:\Program Files\PostgreSQL\10\data"') do rd /s /q "C:\Program Files\PostgreSQL\10\data\%f"

pg_basebackup -h 10.76.0.238 -D "C:\Program Files\PostgreSQL\10\data" -U postgres

copy "C:\Program Files\PostgreSQL\10\data\postgresql.conf.slave" "C:\Program Files\PostgreSQL\10\data\postgresql.conf"
copy "C:\Program Files\PostgreSQL\10\data\recovery.conf.srv1" "C:\Program Files\PostgreSQL\10\data\recovery.conf"
:: ren "C:\Program Files\PostgreSQL\10\data\recovery.done" "recovery.conf"

:: run this only after second server is promoted
:: net start postgresql-x64-10

if NOT %ERRORLEVEL%==0 goto error
echo ok
pause
:: exit

:error
echo There was a problem while failover attempt
pause