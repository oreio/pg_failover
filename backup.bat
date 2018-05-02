@chcp 866
cls
echo off

:: CD /D c:\
:: SET POSTGRE="Program Files\PostgreSQL\9.3\bin"
:: CD %POSTGRE%

CD /D C:\
blat.exe -install smtp.mail.ru umai.server@mail.ru 3 2525 profile_test_mail umai.server@mail.ru umai.asdf123$

ECHO OK
:: SET DATETIME=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2% %TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
  set dow=%%i
  set month=%%j
  set day=%%k
  set year=%%l
)
set DATESTR=%month%-%day%-%year%
set DATETIME=%DATESTR%-%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
::echo DATETIME is %DATETIME%

SET DUMPFILE=kiosk%DATETIME%.backup
SET LOGFILE=kiosk%DATETIME%.log
SET PGPASSWORD=kiosk

set ZIPPATH="D:\Backup\kiosk%DATETIME%"
:: IF NOT EXIST Backup MD Backup
IF NOT EXIST D:\Backup MD D:\Backup

:: SET DUMPPATH="D:\Backup\%DATETIME%%DUMPFILE%"
:: SET LOGPATH="D:\Backup\%DATETIME%%LOGFILE%"
SET DUMPPATH="D:\Backup\%DATESTR%\%DUMPFILE%"
SET LOGPATH="D:\Backup\%DATESTR%\%LOGFILE%"
IF NOT EXIST D:\Backup\%DATESTR% MD D:\Backup\%DATESTR%
echo %DUMPPATH%
echo %LOGPATH%

pg_dump  --format=custom --verbose --file=%DUMPPATH% -U kiosk kiosk>%LOGPATH%
ECHO ---PG_DUMP_INFORMATION---------------------------------------------------------------->>%LOGPATH%
pg_dump  -v --format=custom --file=%DUMPPATH% -U kiosk kiosk  2>>%LOGPATH%

:: Analysis of the code completion
echo error number = %ERRORLEVEL%
IF NOT %ERRORLEVEL%==0 GOTO Error
GOTO Successfull

:Error
DEL %DUMPPATH%
set err=%ERRORLEVEL%
ECHO ---BACKUP_INFORMATION---------------------------------------------------------------->>%LOGPATH%
ECHO %DATETIME% Backup failed. Error create copy of BD %DUMPFILE%.>> %LOGPATH%
ECHO ---INFORMATION_ABOUT_SENDING_MESSAGES------------------------------------------------->>%LOGPATH%
blat.exe -p profile_test_mail -charset UTF-8 -tf C:\openssh\blat\sendmail.txt -subject "Backup info" -body "Backup failed :( %DATETIME% " >>%LOGPATH%
ECHO ---INFORMATION_ABOUT_SENDING_ARCHIVING------------------------------------------------->>%LOGPATH%
7z a %ZIPPATH%.zip %LOGPATH%
GOTO End

:Successfull
ECHO ---BACKUP_INFORMATION---------------------------------------------------------------->>%LOGPATH%
ECHO %DATETIME% successful backup %DUMPFILE% >>%LOGPATH%
ECHO ---INFORMATION_ABOUT_SENDING_MESSAGES------------------------------------------------->>%LOGPATH%
blat.exe -p profile_test_mail -charset UTF-8 -tf C:\openssh\blat\sendmail.txt -subject "Backup info" -body "Backup has been done! %DATETIME% " >>%LOGPATH%
ECHO ---INFORMATION_ABOUT_SENDING_ARCHIVING------------------------------------------------->>%LOGPATH%
7z a %ZIPPATH%.zip %DUMPPATH% >>%LOGPATH%
7z a %ZIPPATH%.zip %LOGPATH%
GOTO End

:End
echo put "D:/backup/kiosk%DATETIME%.zip" backup/ > C:\openssh\send.bat
ECHO ---INFORMATION_ABOUT_SENDING_TO_THE_REMOTE_SERVER------------------------------------------------->>%LOGPATH%
:: sftp.exe -b send.bat  Администратор@10.76.0.20 >>%LOGPATH%
