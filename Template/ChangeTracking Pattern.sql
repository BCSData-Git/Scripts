--CT PATTERN

-- 1. CREATE VERSION CONTROL TABLE

select * from AspenProd.dbo.ChangeTrackingControl
select * from AspenProd.dbo.ChangeTrackingCurrentVersion

--/****** Object:  Table [ETL].[Change_Tracking_Version]    Script Date: 7/19/2018 1:34:14 PM ******/
--SET ANSI_NULLS ON
--GO 
--SET QUOTED_IDENTIFIER ON
--GO 
--SET ANSI_PADDING ON
--GO

--CREATE TABLE [ETL].[Change_Tracking_Version](
--	[fCTId] [bigint] IDENTITY(1,1) NOT NULL,
--	[fTable_Name] [varchar](100) NOT NULL,
--	[fTable_Type] [varchar](100) NULL,
--	[fChange_Tracking_Version] [bigint] NULL,
--	[fModifiedDate] [datetime] NULL,
--	[fDatabase_Name] [varchar](255) NULL,
--	[fProcessed] [bit] NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[fCTId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

--ALTER TABLE [ETL].[Change_Tracking_Version] ADD  DEFAULT ((0)) FOR [fProcessed]
--GO



--2. GET START AND END VERSION FOR QUERY
DECLARE @StartVersionID BIGINT
	, @EndVersionID BIGINT
  
-- Set the starting version ID
SET @StartVersionID = (
	SELECT CTVersion
	FROM dbo.ChangeTrackingControl with (nolock)
	WHERE TableName = 'Account'
	  And  CTType = 'AccountAgingSummary')

-- Set the ending version ID
SET @EndVersionID = CHANGE_TRACKING_CURRENT_VERSION()

--3. HOW TO USE START AND END VERSION
select a.AccountId
From dbo.Account a with (nolock)  
  Inner Join CHANGETABLE (CHANGES dbo.Account, @StartVersionID) as ct on a.AccountId = ct.AccountId
Where (
	Select MAX(v) 
	From (VALUES(ct.SYS_CHANGE_VERSION), (ct.SYS_CHANGE_CREATION_VERSION)) AS VALUE(v)) <= @EndVersionID



--4. UPDATE WHEN ALL DONE 
 Update dbo.ChangeTrackingControl SET CTVersion = @EndVersionID 
 , DateLastUpdated = GETDATE()
Where TableName = 'Account'
  And CTType = 'AccountAgingSummary'



