USE AspenProd ;  
GO  
EXEC sp_configure 'show advanced options', 1 ;   
RECONFIGURE ;   
GO  
EXEC sp_configure 'max text repl size', -1 ;   
GO  
RECONFIGURE;   
GO  
Configuration option 'max text repl size (B)' changed from 65536 to -1. Run the RECONFIGURE statement to install.

