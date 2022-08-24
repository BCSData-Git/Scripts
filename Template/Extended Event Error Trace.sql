use master
go
CREATE EVENT SESSION [ErrorCapture] ON SERVER 
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.sql_text,sqlserver.username)
    WHERE ([severity]>=(11)))
ADD TARGET package0.event_file(SET filename=N'F:\MSSQL\dbTrace\VSQLSERVER_ErrorCapture.xel',max_file_size=(2))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB
,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO
 

USE [Maintenance]
GO

/****** Object:  Table [dbo].[mntblSQLExceptionLog_Header]    Script Date: 5/28/2021 11:58:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mntblSQLExceptionLog_Header](
	[fReportID] [bigint] IDENTITY(1,1) NOT NULL,
	[fEnvironment] [varchar](20) NULL,
	[fCreated] [datetime] NULL,
	[fDateTimeBeg] [datetime] NULL,
	[fDatetimeEnd] [datetime] NULL,
 CONSTRAINT [PK_mntblSQLExceptionLog_Header] PRIMARY KEY CLUSTERED 
(
	[fReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO



USE [Maintenance]
GO

/****** Object:  Table [dbo].[mntblSQLExceptionLog_Detail]    Script Date: 5/28/2021 11:58:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mntblSQLExceptionLog_Detail](
	[fReportID] [int] NOT NULL,
	[ItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[ServerName] [nvarchar](100) NOT NULL,
	[ClientHostName] [nvarchar](100) NULL,
	[DatabaseID] [int] NULL,
	[UserName] [nvarchar](100) NULL,
	[ErrorSeverity] [bigint] NULL,
	[ErrorNumber] [bigint] NULL,
	[Error] [nvarchar](512) NULL,
	[ErrorMessage] [nvarchar](512) NULL,
	[SQLText] [nvarchar](max) NULL,
	[EventData] [xml] NULL,
 CONSTRAINT [PK_mntblSQLExceptionLog_Detail] PRIMARY KEY CLUSTERED 
(
	[fReportID] ASC,
	[ItemID] ASC,
	[ErrorTime] ASC,
	[ServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


SELECT * fROM [mntblSQLExceptionLog_Detail]


 USE [Maintenance]
GO
/****** Object:  StoredProcedure [dbo].[mnt_sp_ProcessErrorCapture]    Script Date: 5/28/2021 11:58:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[mnt_sp_ProcessErrorCapture]
as

SET ANSI_PADDING ON

Declare @ReportID Int
Declare @MinErrTime DateTime
Declare @MaxErrTime DateTime

Create table #Report (fReportID INT, [ErrorTime] [datetime] NOT NULL,	[ServerName] [nvarchar](100) NOT NULL,	[ClientHostName] [nvarchar](100) NULL,	[DatabaseID] [int] NULL,
	[UserName] [nvarchar](100) NULL,	[ErrorSeverity] [bigint] NULL,	[ErrorNumber] [bigint] NULL,	[Error] [nvarchar](512) NULL,	[ErrorMessage] [nvarchar](512) NULL,	[SQLText] [nvarchar](max) NULL,
	[EventData] [xml] NULL) 
	

--Declare @LastProcessTime DateTime
Insert into mntblSQLExceptionLog_Header
	(fEnvironment, fCreated, fDateTimeBeg, fDatetimeEnd )
Select 'Production',GetDate(),Getdate(),GetDate()

Select @ReportID = Max(fReportID) from mntblSQLExceptionLog_Header with (nolock)


--Select @LastProcessTime = Convert(dateTime,Value) from [montblErrorCaptureSetting]

;with events_cte as(
select 
	DATEADD(mi,
	DATEDIFF(mi, GETUTCDATE(), CURRENT_TIMESTAMP),
	xevents.event_data.value('(event/@timestamp)[1]', 'datetime2')) AS [err_timestamp],
	--xevents.event_data.value('(event/action[@name="server_instance_name"]/value)[1]', 'nvarchar(100)') AS [server_instance_name],  Not avialable in SQL 2008
	Substring(file_name,CHARINDEX('\',file_name,5) + 1 ,CHARINDEX('_', file_name,5) - (CHARINDEX('\',file_name,5)+1)) as [server_instance_name],
	xevents.event_data.value('(event/action[@name="client_hostname"]/value)[1]', 'nvarchar(100)') AS [client_hostname],
	xevents.event_data.value('(event/action[@name="database_id"]/value)[1]', 'int') AS [database_id],
	xevents.event_data.value('(event/action[@name="username"]/value)[1]', 'nvarchar(100)') AS [username],
	xevents.event_data.value('(event/data[@name="severity"]/value)[1]', 'bigint') AS [err_severity],
	xevents.event_data.value('(event/data[@name="error_number"]/value)[1]', 'bigint') AS [err_number],
	xevents.event_data.value('(event/data[@name="error"]/value)[1]', 'nvarchar(512)') AS [Error],
	xevents.event_data.value('(event/data[@name="message"]/value)[1]', 'nvarchar(512)') AS [err_message],
	xevents.event_data.value('(event/action[@name="sql_text"]/value)[1]', 'nvarchar(max)') AS [sql_text],
	xevents.event_data
from sys.fn_xe_file_target_read_file
	('F:\MSSQL\dbTrace\*.xel', 
	'F:\MSSQL\dbTrace\*.xem',
	null, null)
cross apply (select CAST(event_data as XML) as event_data) as xevents
)



INSERT INTO #Report (ErrorTime, ServerName,ClientHostName, DatabaseID, UserName,
				 ErrorSeverity, ErrorNumber,Error, ErrorMessage, SQLText,[EventData]
 )
SELECT [err_timestamp],[server_instance_name],[client_hostname],[database_id],[username],
			[err_severity],[err_number],[Error],[err_message],[sql_text],event_data
	
--from events_cte e left outer join #Errors t on e.server_instance_name = t.ServerName and e.err_timestamp > t.MaxErrorTime
from events_cte e where err_message is not null
order by err_timestamp;

Select @MinErrTime = MIN (ErrorTime) ,@MaxErrTime =MAX(ErrorTime) from #Report

Update mntblSQLExceptionLog_Header
Set fDateTimeBeg = @MinErrTime, fDatetimeEnd= @MaxErrTime
Where fReportID = @ReportID

Insert into [dbo].[mntblSQLExceptionLog_Detail] (fReportID, ErrorTime, ServerName, ClientHostName, DatabaseID, UserName, ErrorSeverity, ErrorNumber, Error, ErrorMessage, SQLText, EventData)
Select @ReportID,ErrorTime, ServerName,ClientHostName, DatabaseID, UserName,ErrorSeverity, ErrorNumber,Error, ErrorMessage, SQLText,[EventData]
from #Report

