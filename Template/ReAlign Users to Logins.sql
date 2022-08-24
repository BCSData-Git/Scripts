

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
              from [" +@dbName+ "]..sysusers where issqluser = 1  and uid > 2")
	PRINT 'GO'
	PRINT ''
	select @dbId = min(dbId) from master..sysdatabases where dbid > @dbId
   end

USE master
set nocount off

 