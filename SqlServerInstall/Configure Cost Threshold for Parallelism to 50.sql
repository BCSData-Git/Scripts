--Configure Cost Threshold for Parallelism to 50

--Configure for each db
USE master ;  
GO  
EXEC sp_configure 'show advanced options', 1 ;  
GO  
RECONFIGURE  
GO  
EXEC sp_configure 'cost threshold for parallelism', 50 ;  
GO  
RECONFIGURE  
GO  


-- Check the Disabled record.
SELECT * FROM SYS.CONFIGURATIONS WHERE Name = 'cost threshold for parallelism'
