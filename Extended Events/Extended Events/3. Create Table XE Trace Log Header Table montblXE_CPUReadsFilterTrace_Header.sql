USE [Maintenance]
GO 
--DROP TABLE [montblXE_CPUReadsFilterTrace_Header]
GO
CREATE TABLE [dbo].[montblXE_CPUReadsFilterTrace_Header](
	[fReportID] [int] NOT NULL identity(1,1),
	[fServerName] [varchar](100) NULL,
	[fCreatedDateTime] [datetime] NULL,
	[fProcessDateTimeBeg] [datetime] NULL,
	[fProcessDatetimeEnd] [datetime] NULL,
	[fTraceBatchMinEndTime] [datetime] NULL,
	[fTraceBatchMaxEndTime] [datetime] NULL,
	[fTraceBatchRowCount] [int] NULL
 CONSTRAINT [PK_montblXE_CPUReadsFilterTrace_Header] PRIMARY KEY CLUSTERED 
(
	[fReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO