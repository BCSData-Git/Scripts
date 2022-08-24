USE [Maintenance]
GO
--UPDATE STATISTICS dbo.Contact
/****** Object:  Table [dbo].[mnttblUpdateStatsByDB_Log]    Script Date: 11/5/2021 9:10:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mnttblUpdateStatsByDB_Log](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[LogWritten] [datetime] NOT NULL,
	[ServerName] [nvarchar](100) NOT NULL,
	[DatabaseName] [varchar](500) NULL,
	[SqlStatement] [varchar](500) NULL,
 CONSTRAINT [PK_mnttblUpdateStatsByDB_Log] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




USE [Maintenance]
GO
/****** Object:  StoredProcedure [dbo].[mnt_sp_UpdateStatsALL]    Script Date: 11/5/2021 9:09:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris Becker
-- Create date: 10/13/2021
-- 10/27/2021 Added Check to run for any db not already ran w/in last 8 hours. Fixes cursor exiting prematurely.
-- Description:	Execute update_stats in all user dbs
-- =============================================
ALTER PROCEDURE [dbo].[mnt_sp_UpdateStatsALL] 

AS
BEGIN

	Declare @kill_stmt nvarchar(100), @alter_stmt nvarchar(500), @dbname nvarchar(50), @spid int

	IF EXISTS(
		SELECT top 1 hars.role_desc 
		FROM sys.databases d 
			inner join sys.dm_hadr_availability_replica_states hars ON d.replica_id = hars.replica_id 
		Where hars.role_desc = 'SECONDARY'
		)
	BEGIN
	  GOTO END_PROC
	END

	IF NOT EXISTS(
		Select d.[name]
		From sysdatabases d 
			Left Join Maintenance.dbo.mnttblUpdateStatsByDB_Log l On d.[name] = l.DatabaseName And l.LogWritten > DateAdd(Hour, -8, GetDate())
		Where l.DatabaseName Is NULL
			And d.[name] Not in ('Maintenance', 'ASPState') And d.dbid > 4
	)
	BEGIN
	  GOTO END_PROC
	END


	Declare c Cursor for
	Select distinct d.[name]
	From sysdatabases d 
		Left Join Maintenance.dbo.mnttblUpdateStatsByDB_Log l On d.[name] = l.DatabaseName And l.LogWritten > DateAdd(Hour, -8, GetDate())
	Where l.DatabaseName Is NULL
		And d.[name] Not in ('Maintenance', 'ASPState') And d.dbid > 4
	Order by d.[name]
 
	Open c 
	Fetch Next From c Into @dbname

	While @@FETCH_STATUS = 0 
	Begin
 
		Select @alter_stmt = 'use [' + @dbname + '];exec sp_updatestats;'  

		Exec sp_executesql @alter_stmt 
		--print @alter_stmt

		Insert Into Maintenance.dbo.mnttblUpdateStatsByDB_Log (LogWritten, ServerName, DatabaseName, SqlStatement)
		Select Getdate(), @@ServerName, @dbname, @alter_stmt

		Fetch Next From c Into @dbname
	end

	close c
	deallocate c
	 
	END_PROC:

END


