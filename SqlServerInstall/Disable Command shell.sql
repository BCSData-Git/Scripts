USE master
go
-- To allow advanced options to be changed. 
EXEC sp_configure 'show advanced options', 1 
GO 

-- To update the currently configured value for advanced options. 

RECONFIGURE 
GO  

SELECT * FROM SYS.CONFIGURATIONS WHERE Name = 'show advanced options'

--Disabling xp_cmdshell 
EXEC sp_configure 'xp_cmdshell', 0
GO
RECONFIGURE
GO

