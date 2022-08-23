use master
go
--Enable CLR 
EXEC dbo.sp_configure 'clr enabled',1 
GO
RECONFIGURE
GO
--RECONFIGURE



SELECT name, description, is_advanced  ,value_in_use
FROM sys.configurations
Where name in ('clr enabled')