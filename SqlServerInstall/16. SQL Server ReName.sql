-- for a Default Instance
EXEC sp_dropserver 'MACEUSSQL01A';  
GO  
EXEC sp_addserver 'SEDONA', local;  
GO  
