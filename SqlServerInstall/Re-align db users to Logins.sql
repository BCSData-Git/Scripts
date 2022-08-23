 /*
--Check Logins and realign Logins
Use EuronetData;
Select 'exec sp_change_users_login ''UPDATE_ONE'',''' + name + 
	''',''' + name + ''''
from sys.sysusers where issqluser = 1 and name not in ('dbo', 'sys', 'INFORMATION_SCHEMA', 'guest')
order by name;
*/


  /*-----------------------------------------------------------------------------*
   |   Author: Bruce Canaday                                                     |
   |     Date: 09/16/2003                                                        |
   |-----------------------------------------------------------------------------|
   |  Purpose: Generate the 'sp_change_users_login' statements necessary to      |
   |           synch all users in all databases on the server.                   |
   |-----------------------------------------------------------------------------|
   | Modified:                                                                   |
   *-----------------------------------------------------------------------------*/
  
set nocount on
set quoted_identifier off
 
declare @dbId int,
	@dbName varchar(255)

select @dbId = min(dbId) from master..sysdatabases where dbid > 3

while exists (select * from master..sysdatabases where dbid = @dbId)
begin
	select @dbName =  name from master..sysdatabases where dbid = @dbId
	PRINT 'USE [' +@dbName+ ']'
	PRINT 'GO'
	exec("select 'exec sp_change_users_login ''UPDATE_ONE'',''' +name+ ''',''' +name+ ''''
				from [" +@dbName+ "]..sysusers where issqluser = 1 and uid > 2")
	PRINT 'GO'
	PRINT ''
	select @dbId = min(dbId) from master..sysdatabases where dbid > @dbId
end

--USE master
--set nocount off

-- --select * from sysusers
-- DECLARE @name varchar(1000)
--DECLARE c cursor for
--select name from sysusers where issqluser = 1 and uid > 2

--open c
--fetch next from c into @name
--while @@fetch_status = 0 
--begin

--  print 'exec sp_change_users_login ''UPDATE_ONE'',''' + @name + ''',''' + @name + ''''
--  print 'GO'
--  fetch next from c into @name
--end

--close c
--deallocate c

 