USE master ;  
GO  
EXEC sp_configure 'show advanced options', 1 ;   
RECONFIGURE ;   
GO  
EXEC sp_configure 'max text repl size', 2147483647;   
GO  
RECONFIGURE;   
GO
 