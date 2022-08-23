

EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO  
EXEC dbo.sp_configure 'backup compression default', 1
GO  
RECONFIGURE WITH OVERRIDE;  
GO  

SELECT name, description, is_advanced  ,value_in_use
FROM sys.configurations
Where name in (  'backup compression default') ;

