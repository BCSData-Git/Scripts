Objects for Framework 
Tables
-    mnttblArchivedTables
-    mnttblArchivedTables_RoutineErrors
-    mnttblArchivedTables_RunningQueues
-    stg_[source_table_stage_data]  (automatically created by archive PROC)
Trigger
-    tr_mnttblArchivedTables_fQueueID
Procedures
-    mnt_sp_ArchiveTables
-    mnt_sp_ArchiveTables_Activate_NewPeriods
-    mnt_sp_ArchiveTables_Create_temptables
    
 
SQL Jobs
-    Archive - Tables By Queue - Activate New Periods
    Archive - Tables By Queue - Q01
 
--mnttblTranReplPending
 
/****** Object:  Table [dbo].[mnttblTranReplPending]    Script Date: 1/17/2019 7:51:20 PM ******/
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mnttblTranReplPending_Archive] (
	[TRPID] [int]  NOT NULL,
	[PollDateTime] [datetime] NOT NULL,
	[PUB_DBNAME] [sysname] NULL,
	[ARTICLE_NAME] [sysname] NOT NULL,
	[TRANS_PENDING] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TRPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
 
 /****** Object:  Table [dbo].[stg_mnttblTranReplPending]    Script Date: 1/17/2019 8:01:15 PM ******/
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_mnttblTranReplPending](
	[TRPID] [int] NOT NULL,
	[fProcessed] [bit] NULL,
 CONSTRAINT [PK_stg_mnttblTranReplPending] PRIMARY KEY CLUSTERED 
(
	[TRPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


 
USE [Maintenance]
GO
 
INSERT INTO [dbo].[mnttblArchivedTables]
       ( [fWritten],[fDatabaseName],[fSchema],[fTableName],[fStagingTable],[fArchivedTable],[fDateBegin],[fDateEnd],[fRetentionDays],[fRetentionDays_ColumnName],[fArchived_RecordLimit],
       [fMoveToArchive],[fMovedToArchive],[fPrimaryKey_Number],[fPrimaryKey_1],[fPrimaryKey_2],[fPrimaryKey_3],[fPrimaryKey_4],[fArchivedRecordsCnt],[fDisabled],[fDelete],[fTime],
              [fModified],[fModifiedID],[fCreated],[fCreatedID],[fQueueID])
 
SELECT [fWritten]           = getdate() ,                    -- Recorded date
              [fDatabaseName]      = 'Maintenance', -- Source Database Name
              [fSchema]            = 'dbo',                         -- schema name from source table
              [fTableName]  = 'mnttblTranReplPending',  -- Sorce table where data will be taken from
              [fStagingTable]  = 'Maintenance.dbo.stg_mnttblTranReplPending', 
                           -- Staging table will be used to insert batch records to be archive PROC will create table if not exist
              [fArchivedTable] = 'Maintenance.dbo.mnttblTranReplPending_Archive',
                           -- Archive Destianation table 
              [fDateBegin]  = '01/01/2016',     -- Archive Period Start Date
              [fDateEnd]           = '12/31/2050',     -- Archive period End Date
              [fRetentionDays] = 30,                          -- VERY IMPORTANTANT How many days will be kept on Primary table
              [fRetentionDays_ColumnName] = 'PollDateTime', -- column that will be used by the archive process to get the records needed to be archived
              [fArchived_RecordLimit]     = 10000,  
                           -- BATCH SIZE How many records per execution will archive be careful with
                           -- table in replication  should not be more than 1,000 for tables in repl
              [fMoveToArchive]  = 1,                          -- if Set to 1 Archive will start for this period
              [fMovedToArchive] = 0,                          -- This will set to 1 by the proc once archive period is completed
              [fPrimaryKey_Number] = 1,                -- How many columns are part of the PK this is very important 
                                                                           -- for the archive scrip with tables that more than one column as PK up to 4
              [fPrimaryKey_1]            = 'TRPID',            -- Column 1 name of the PK 
              [fPrimaryKey_2]            = '',               -- Column 2 name of the PK 
              [fPrimaryKey_3]            = '',                  -- Column 3 name of the PK 
              [fPrimaryKey_4]            = '',               -- Column 4 name of the PK 
              [fArchivedRecordsCnt] = 0,                -- set to 0 for new config. This will be updated by the archive proc as records are archived
              [fDisabled]                = 0,                -- 0 for new config if set 1 Record  will ignored by the archive process
              [fDelete]                  = 0,                -- 0 for new config if set 1 Record  will ignored by the archive process
              [fTime]                           = Getdate(), -- current time of the config
              [fModified]                = Getdate(), -- this will be updated by the archive process on every execution
              [fModifiedID]        = 1,                -- your Employee ID from comtlbNames when modifying record or initial config
              [fCreated]                 = Getdate(), -- Record create date
              [fCreatedID]         = 1,                -- Employee ID from comtlbNames who created the configuration
              [fQueueID]                 = 1                 -- Queue ID is used as parameter from the SQL Job to find the tables to be archive by that particular job
 
GO
 
