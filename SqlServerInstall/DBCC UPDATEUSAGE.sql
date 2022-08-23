use master
go

--select 'USE [' + name + ']; DBCC UPDATEUSAGE (0);' from sysdatabases order by 1

USE [ASPState]; DBCC UPDATEUSAGE (0); 