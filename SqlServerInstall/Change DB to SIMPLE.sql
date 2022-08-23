--USE [master]
--GO
--select 'ALTER DATABASE [' + name + '] SET RECOVERY SIMPLE WITH NO_WAIT;' from sysdatabases  order by 1

ALTER DATABASE [ASPState] SET RECOVERY SIMPLE WITH NO_WAIT; 