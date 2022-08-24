--CT PATTERN

-- 1. CREATE VERSION CONTROL TABLE
USE DBTEST
GO
drop table [dbo].[ChangeTrackingCurrentVersion]

/****** Object:  Table [ETL].[Change_Tracking_Version]    Script Date: 7/19/2018 1:34:14 PM ******/
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ChangeTrackingCurrentVersion](
	[CTCurrentVersionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CTTableName] [varchar](100) NOT NULL,
	[CTType] [varchar](100) NULL,
	[CTCurrentVersion] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[DatabaseName] [varchar](255) NULL,
	[IsProcessed] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CTCurrentVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS 
= ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ChangeTrackingCurrentVersion] ADD  DEFAULT ((0)) FOR [CTIsProcessed]
GO

  
 




--2. GET START AND END VERSION FOR QUERY
DECLARE @StartVersionID BIGINT
	, @EndVersionID BIGINT
  
-- Set the starting version ID
SET @StartVersionID = (
	SELECT [CTCurrentVersion]
	FROM dbo.[ChangeTrackingCurrentVersion] with (nolock)
	WHERE [CTTableName] = 'ArPostingInfo'
	  And [CTType] = 'lttblOrders_mttblOrders')

-- Set the ending version ID
 

--3. HOW TO USE START AND END VERSION
From  dbo.Orders  l with (nolock)  
  Inner Join CHANGETABLE (CHANGES dbo.Orders, @StartVersionID) as ct on l.fOrderID = ct.fOrderID  
Where (
	Select MAX(v) 
	From (VALUES(ct.SYS_CHANGE_VERSION), (ct.SYS_CHANGE_CREATION_VERSION)) AS VALUE(v)) <= @EndVersionID


--4. UPDATE WHEN ALL DONE 
 Update Maintenance.dbo.ChangeTrackingCurrentVersion SET fChange_Tracking_Version = @EndVersionID 
 , fModifiedDate = GETDATE()
Where fTable_Name = 'Orders'
  And fTable_Type = 'Orders Event Processing'



