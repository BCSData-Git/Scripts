
--select 'USE ' + name + '; EXEC sp_changedbowner ''sa'';'   from sysdatabases order by 1

USE ASPState; EXEC sp_changedbowner 'sa'; 