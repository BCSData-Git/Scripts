USE [Maintenance]
GO

Create Table dbo.stgtblIndexSizesMB (DatabaseName varchar(100), Indexname varchar(500), IndexSizeMB decimal(18,2))

Create Table dbo.montblUnusedIndexes_Log (LogId int not null identity(1,1) primary key, DatabaseName varchar(100), DateWritten datetime  )


/****** Object:  Table [dbo].[montblUnusedIndexes]    Script Date: 10/21/2021 9:08:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[montblUnusedIndexes](
	[UnUsedIndexesID] [int] IDENTITY(1,1) NOT NULL,
	[DateCollected] [datetime] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[LastStartTime] [datetime] NOT NULL,
	[DatabaseName] [varchar](100) NULL,
	[TableName] [varchar](500) NULL,
	[IndexName] [varchar](500) NULL,
	[IndexID] [int] NULL,
	[IndexType] [varchar](500) NULL,
	[userseeks] [bigint] NULL,
	[userscans] [bigint] NULL,
	[userlookups] [bigint] NULL,
	[userupdates] [bigint] NULL,
	[NumRows] [bigint] NULL,
	[NumPages] [bigint] NULL,
	[TotMBs] [bigint] NULL,
	[UsedMBs] [bigint] NULL,
	[IndexMBs] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[UnUsedIndexesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [Maintenance]
GO

/****** Object:  Table [dbo].[UnusedIndexes]    Script Date: 10/21/2021 9:00:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stgtblUnusedIndexes](
	[stgID] [int] IDENTITY(1,1) NOT NULL,
	[DateCollected] [datetime] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[LastStartTime] [datetime] NOT NULL,
	[DatabaseName] [varchar](100) NULL,
	[TableName] [varchar](500) NULL,
	[IndexName] [varchar](500) NULL,
	[IndexID] [int] NULL,
	[IndexType] [varchar](500) NULL,
	[userseeks] [bigint] NULL,
	[userscans] [bigint] NULL,
	[userlookups] [bigint] NULL,
	[userupdates] [bigint] NULL,
	[NumRows] [bigint] NULL,
	[NumPages] [bigint] NULL,
	[TotMBs] [bigint] NULL,
	[UsedMBs] [bigint] NULL,
	[IndexMBs] [decimal](18, 2) NULL
) ON [PRIMARY]
GO



USE [Maintenance]
GO
/****** Object:  StoredProcedure [dbo].[sp_CollectUnusedIndexes]    Script Date: 10/21/2021 8:59:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Description:
	  Duplicate/Unused index management

	Database Target: Maintenance
		
	Revision History:
		2019-04-11	CB	Created
		2021-03-15  CB	Joins causing duplicates, removed, collecting index sizes individually
		2021-04-05  cb	Exclude unique constraints or unique indexes, do not want to affect FKs or integrity  
		
*/
CREATE PROCEDURE [dbo].[mon_sp_CollectUnusedIndexes]
AS
BEGIN


	truncate table Maintenance.dbo.stgtblUnusedIndexes
	truncate table Maintenance.dbo.stgtblIndexSizesMB 
	  
	--Check if Dbs need processing based on missing from log table
	IF NOT EXISTS (
		Select d.[name]
		From sysdatabases d 
		  Left Join Maintenance.dbo.montblUnusedIndexes_Log l On d.[name] = l.DatabaseName And l.DateWritten > DateAdd(Hour, -8, GetDate())
		Where l.DatabaseName Is NULL
		  And d.[name] Not in ('Maintenance', 'ASPState') And d.dbid > 4 )
	BEGIN
		GOTO END_PROC 
	END
	 
	Declare @dbName varchar(100), @SQLCommand Nvarchar(4000)

	Declare c Cursor For
	Select d.[name]
	From sysdatabases d 
		Left Join Maintenance.dbo.montblUnusedIndexes_Log l On d.[name] = l.DatabaseName And l.DateWritten > DateAdd(Hour, -8, GetDate())
	Where l.DatabaseName Is NULL
		And d.[name] Not in ('Maintenance', 'ASPState') And d.dbid > 4

	Open c
	Fetch Next from c Into @dbName

	While @@FETCH_STATUS = 0
	Begin

		Set @SQLCommand = 'use ' + @dbname + ';
		INSERT INTO Maintenance.dbo.stgtblUnusedIndexes
		SELECT getdate() as DateCollected
		, @@servername as ServerName
		, (SELECT sqlserver_start_time FROM sys.dm_os_sys_info with (nolock)) AS [LastStartTime]
		, DB_NAME() as DatabaseName, OBJECT_NAME(S.[OBJECT_ID]) AS TableName
		, I.[NAME] AS IndexName , I.index_id , I.Type as IndexType
		, USER_SEEKS, USER_SCANS, USER_LOOKUPS, USER_UPDATES 
		, 0 AS NumRows 
		, 0 AS NumPages
			 , 0 AS TotMBs
			 , 0 AS UsedMBs
			 , 0 AS DataMBs
		FROM   SYS.DM_DB_INDEX_USAGE_STATS AS S WITH (NOLOCK)
			INNER JOIN SYS.INDEXES AS I WITH (NOLOCK) ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID  
		WHERE  OBJECTPROPERTY(S.[OBJECT_ID],''IsUserTable'') = 1
			   AND S.database_id = DB_ID()
			   And (i.is_unique_constraint <> 1 or i.is_unique <> 1) 
		'
		Exec sp_executesql @SQLCommand
	
		Set @SQLCommand = 'use ' + @dbname + ';
			Insert Into Maintenance.dbo.stgtblIndexSizesMB (DatabaseName, Indexname, IndexSizeMB)
			SELECT DB_NAME() As DatabaseName, i.[name] As IndexName
				, (SUM(s.[used_page_count]) * 8) / 1024 As IndexSizeMB
			FROM sys.dm_db_partition_stats As s
			INNER JOIN sys.indexes As i ON s.[object_id] = i.[object_id]
				AND s.[index_id] = i.[index_id]
			Where i.[name] IS NOT NULL
			GROUP BY i.[name] 
		 '
	  
		Exec sp_executesql @SQLCommand
		 
		Update u set IndexMBs = IndexSizeMB
		--Select u.*, i.* 
		from Maintenance.dbo.stgtblUnusedIndexes u
		  Join Maintenance.dbo.stgtblIndexSizesMB i On u.DatabaseName = i.DatabaseName and u.IndexName = i.IndexName
		Where i.DatabaseName = @dbname
		 
		Insert Into Maintenance.dbo.montblUnusedIndexes_Log (DatabaseName, DateWritten)
		Select @dbname, Getdate()

		Fetch Next from c Into @dbName

	END 

	Close c
	Deallocate c

	Insert Into Maintenance.dbo.montblUnusedIndexes (
		[DateCollected], [ServerName], [LastStartTime], [DatabaseName], [TableName], [IndexName], [IndexID], [IndexType]
		, [userseeks], [userscans], [userlookups], [userupdates]
		, [NumRows], [NumPages], [TotMBs], [UsedMBs], [IndexMBs] ) 
	Select [DateCollected], [ServerName], [LastStartTime], [DatabaseName], [TableName], [IndexName], [IndexID], [IndexType]
		, [userseeks], [userscans], [userlookups], [userupdates]
		, [NumRows], [NumPages], [TotMBs], [UsedMBs], [IndexMBs]  
	From Maintenance.dbo.stgtblUnusedIndexes with (nolock) 
	Where DatabaseName NOT IN ('tempdb', 'master', 'msdb', 'model', 'Maintenance' )
	  And IndexName IS NOT NULL AND IndexType > 1
	  And userseeks = 0 AND userscans = 0 AND userlookups = 0 


END_PROC:

END


GO
SELECT distinct databasename FROM Maintenance.dbo.montblUnusedIndexes_Log 
select * from Maintenance.dbo.montblUnusedIndexes
 go


   
