USE [Maintenance]
GO
--drop TABLE [dbo].[montblXE_CPUReadsFilterTrace]
go
/****** Object:  Table [dbo].[montblXE_CPUReadsFilterTrace]    Script Date: 9/17/2018 3:29:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[montblXE_CPUReadsFilterTrace](
	[XEID] [int] IDENTITY(1,1) NOT NULL ,
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
	[sql_text] [nvarchar](max) NULL
PRIMARY KEY CLUSTERED 
(
	[XEID] ASC,
	[SqlServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
  
--USE [fxDBMonitoring]
--GO
--drop table [montblXE_CPUReadsFilterTrace]
--/****** Object:  Table [dbo].[montblXE_CPUReadsFilterTrace]    Script Date: 9/17/2018 3:30:06 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[montblXE_CPUReadsFilterTrace](
--	[XEID] [int] IDENTITY(1,1) NOT NULL,
--	[SqlServerName] [nvarchar](100) NOT NULL,
--	[timestamp] [datetime] NULL,
--	[event_name] [nvarchar](200) NULL,
--	[cpu_time] [decimal](20, 0) NULL,
--	[duration] [decimal](20, 0) NULL,
--	[physical_reads] [decimal](20, 0) NULL,
--	[logical_reads] [decimal](20, 0) NULL,
--	[writes] [decimal](20, 0) NULL,
--	[object_name] [nvarchar](max) NULL,
--	[statement] [nvarchar](max) NULL,
--	[username] [nvarchar](max) NULL,
--	[session_id] [int] NULL,
--	[query_hash] [decimal](20, 0) NULL,
--	[nt_username] [nvarchar](max) NULL,
--	[database_name] [nvarchar](max) NULL,
--	[database_id] [int] NULL,
--	[client_hostname] [nvarchar](max) NULL,
--	[sql_text] [nvarchar](max) NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[XEID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--GO



--CREATE TABLE [dbo].[montblXE_CPUReadsFilterTrace](
--	[name] [nvarchar](100) NULL, --[nvarchar](max) 
--	[timestamp] [datetime] NULL, --[datetimeoffset](7)
--	[timestamp (UTC)] [datetime] NULL, --[datetimeoffset](7)
--	[cpu_time] [decimal](20, 0) NULL,
--	[duration] [decimal](20, 0) NULL,
--	[physical_reads] [decimal](20, 0) NULL,
--	[logical_reads] [decimal](20, 0) NULL,
--	[writes] [decimal](20, 0) NULL,
--	--[result] [nvarchar](max) NULL,
--	[row_count] [decimal](20, 0) NULL,
--	[connection_reset_option] [nvarchar](max) NULL,
--	[object_name] [nvarchar](max) NULL,
--	[statement] [nvarchar](max) NULL,
--	[data_stream] [varbinary](max) NULL,
--	[output_parameters] [nvarchar](max) NULL,
--	[username] [nvarchar](max) NULL,
--	[session_id] [int] NULL,
--	[query_hash] [decimal](20, 0) NULL,
--	[nt_username] [nvarchar](max) NULL,
--	[database_name] [nvarchar](max) NULL,
--	[database_id] [int] NULL,
--	[client_hostname] [nvarchar](max) NULL,
--	[sql_text] [nvarchar](max) NULL,
--	[last_row_count] [decimal](20, 0) NULL,
--	[line_number] [int] NULL,
--	[offset] [int] NULL,
--	[offset_end] [int] NULL,
--	[parameterized_plan_handle] [varbinary](max) NULL
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--GO   
 