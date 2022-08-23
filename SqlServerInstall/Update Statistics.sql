--select 'USE [' + name + ']; exec sp_updatestats;' from sysdatabases order by 1
-- 5 minutes!

--USE [ASPState]; exec sp_updatestats; 