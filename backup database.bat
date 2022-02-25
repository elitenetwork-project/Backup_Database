@ECHO OFF
REM Search the date
set currentdate=%DATE:~-2%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%_%TIME:~3,2%
 
REM Setting folder "bin" MySql
set mysqldir=C:\xampp\mysql\bin\
 
REM Set the temporary backup folder - preferably empty
set mysqlbkpdir=C:\Backup_Database\backup_temp\
 
REM MySQL user and relative pass
set mysqluser=root
set mysqlpass=
 
REM Compression application path - if you are not using RAR check the correct syntax for the application 
set zipexe=C:\Program Files\WinRAR\Rar.exe
 
REM Path to the compressed output file
set rardestfolder=C:\Backup_Database\backup_output\
 
REM Extract the list of databases (excluding the system ones) and perform the dump
IF "%mysqlpass%"=="" (
    %mysqldir%mysql.exe -u %mysqluser% -s -N -e "SHOW DATABASES" | for /F "usebackq" %%D in (`findstr /V "information_schema performance_schema"`) do %mysqldir%mysqldump -u %mysqluser% %%D  > %mysqlbkpdir%%%D.sql
) ELSE (
    %mysqldir%mysql.exe -u %mysqluser% -p%mysqlpass% -s -N -e "SHOW DATABASES" | for /F "usebackq" %%D in (`findstr /V "information_schema performance_schema"`) do %mysqldir%mysqldump -u %mysqluser% -p%mysqlpass% %%D  > %mysqlbkpdir%%%D.sql
)
REM Compress the extracted SQL files into a single RAR file
"%zipexe%" a -r %rardestfolder%DBBackup_%currentdate%.rar %mysqlbkpdir%*.sql
 
REM Delete temporary sql files
del %mysqlbkpdir%*.sql
timeout /t 5 /nobreak