use Maintenance
go

create Procedure mon_sp_Process_XE_CPUReadsFilterTrace

As

--***************************************************************
-- Author: Chris Becker
-- Created: 9/16/2018
-- Description: Process extended event trace file to insert into log table
--
--***************************************************************

CREATE TABLE #TracePreLoad ( 
	[SqlServerName] [nvarchar](100) NOT NULL  ,
	[timestamp] [datetime] NULL,
	[event_name] [nvarchar](200) NULL,
	[cpu_time] [decimal](20, 0) NULL,
	[duration] [decimal](20, 0) NULL,
	[physical_reads] [decimal](20, 0) NULL,
	[logical_reads] [decimal](20, 0) NULL,
	[writes] [decimal](20, 0) NULL,
	[object_name] [nvarchar](500) NULL,
	[statement] [nvarchar](max) NULL,
	[username] [nvarchar](500) NULL,
	[session_id] [int] NULL,
	[query_hash] [decimal](20, 0) NULL,
	[nt_username] [nvarchar](500) NULL,
	[database_name] [nvarchar](500) NULL,
	[database_id] [int] NULL,
	[client_hostname] [nvarchar](500) NULL,
	[sql_text] [nvarchar](max) NULL )
  

Declare @DateTimeProceessBeg datetime = GetUTCDate(), @DateTimeProcessEnd datetime
Declare @DateTimeMax datetime, @DateTimeMin datetime, @DateTimeLast datetime
Declare @iCount int

--Get LastEnd_Time 
Select @DateTimeLast = fTraceBatchMaxEndTime
From Maintenance.dbo.montblXE_CPUReadsFilterTrace_Header
Where fReportID = (Select MAX(fReportID) From Maintenance.dbo.montblXE_CPUReadsFilterTrace_Header with (nolock))
 
If @DateTimeLast IS NULL
Begin
	Set @DateTimeLast = '1/1/1900'
End

Insert Into #TracePreLoad ( SqlServerName, timestamp, event_name, cpu_time, duration, physical_reads, logical_reads, writes, object_name
	, statement, username, session_id, query_hash
	, nt_username, database_name, database_id, client_hostname, sql_text )
select @@servername as SqlServerName
	, event_xml.value('(./@timestamp)[1]', N'datetime2') AS [timestamp]
	, event_xml.value('(./@name)[1]', N'nvarchar(max)') AS [event_name2]
	, event_xml.value('(./data[@name="cpu_time"]/value)[1]', 'decimal(20, 0)') AS [cpu_time]
	, event_xml.value('(./data[@name="duration"]/value)[1]', 'decimal(20, 0)') AS [duration]
	, event_xml.value('(./data[@name="physical_reads"]/value)[1]', 'decimal(20, 0)') AS [physical_reads]
	, event_xml.value('(./data[@name="logical_reads"]/value)[1]', 'decimal(20, 0)') AS [logical_reads]
	, event_xml.value('(./data[@name="writes"]/value)[1]', 'decimal(20, 0)') AS [writes]
	, event_xml.value('(./data[@name="object_name"]/value)[1]', 'nvarchar(max)') AS [object_name]
	, event_xml.value('(./data[@name="statement"]/value)[1]', 'nvarchar(max)') AS [statement]
	, event_xml.value('(./action[@name="username"]/value)[1]', 'nvarchar(max)') AS [username]
	, event_xml.value('(./action[@name="session_id"]/value)[1]', 'int') AS [session_id]
	, event_xml.value('(./action[@name="query_hash"]/value)[1]', 'nvarchar(max)') AS [query_hash]
	, event_xml.value('(./action[@name="nt_username"]/value)[1]', 'nvarchar(max)') AS [nt_username]
	, event_xml.value('(./action[@name="database_name"]/value)[1]', 'nvarchar(250)') AS [database_name]
	, event_xml.value('(./action[@name="database_id"]/value)[1]', 'int') AS [database_id]
	, event_xml.value('(./action[@name="client_hostname"]/value)[1]', 'nvarchar(max)') AS [client_hostname]
	, event_xml.value('(./action[@name="sql_text"]/value)[1]', 'nvarchar(max)') AS [sql_text] 
 FROM  (SELECT CAST(event_data AS XML) xml_event_data 
   FROM sys.fn_xe_file_target_read_file('F:\MSSQL\dbTrace\XE_CPU_Reads_Filter_Trace*.xel', NULL, NULL, NULL)) AS event_table
  CROSS APPLY xml_event_data.nodes('//event') n (event_xml) 
WHERE event_xml.value('(./@timestamp)[1]', N'datetime2') > @DateTimeLast
;

Select @DateTimeMax = Max([timestamp]), @DateTimeMin = Min([timestamp]) From #TracePreLoad

Insert Into Maintenance.dbo.montblXE_CPUReadsFilterTrace ( 
	SqlServerName, timestamp, event_name, cpu_time, duration, physical_reads, logical_reads, writes, object_name
	, statement, username, session_id, query_hash, nt_username, database_name, database_id, client_hostname, sql_text )
Select t.SqlServerName, t.[timestamp], t.event_name, t.cpu_time, t.duration, t.physical_reads, t.logical_reads, t.writes, t.[object_name]
	, t.[statement], t.username, t.session_id, t.query_hash, t.nt_username, t.database_name, t.database_id, t.client_hostname, t.sql_text 
From #TracePreLoad t
  Left Join Maintenance.dbo.montblXE_CPUReadsFilterTrace m On t.[timestamp] = m.[timestamp] and t.duration = m.duration
Where m.[timestamp] Is Null
  and m.duration Is Null --seeing dupes, this will help prevent

Select @iCount = @@rowcount

Insert Into Maintenance.dbo.montblXE_CPUReadsFilterTrace_Header (fServerName, fCreatedDateTime, fProcessDateTimeBeg, fProcessDatetimeEnd
	, fTraceBatchMinEndTime, fTraceBatchMaxEndTime, fTraceBatchRowCount)
Select @@ServerName, GetUTCDate(), @DateTimeProceessBeg, GetUTCDate()
	, @DateTimeMin, @DateTimeMax, @iCount


	 
GO


--select * from fxDBMonitoring.dbo.montblXE_CPUReadsFilterTrace_Header

--select * from   dbo.montblXE_CPUReadsFilterTrace order by 3

--TRUNCATE TABLE fxDBMonitoring.dbo.montblXE_CPUReadsFilterTrace
--truncate table fxDBMonitoring.dbo.montblXE_CPUReadsFilterTrace_Header