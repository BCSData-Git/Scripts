--\\VSQLSERVER2\dbBak\VSQLSERVER
--BACKUP DATABASE AspenProd TO  DISK = N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenProd_REpl.bak' WITH  INIT ,  COMPRESSION, NOUNLOAD 
--	,  NAME = N'AspenProd Full backup',  NOSKIP ,  STATS = 10,  NOFORMAT


--N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenProd_REpl.bak' 
RESTORE FILELISTONLY FROM DISK = N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenProd_REpl.bak'

RESTORE DATABASE AspenProd_Reports FROM DISK = N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenProd_REpl.bak'
	WITH FILE = 1, NOUNLOAD, STATS = 5, RECOVERY, REPLACE, 
		MOVE N'AspenTest' TO N'C:\MSSQL\dbData\AspenProd_Reports.mdf', 
		MOVE N'AspenTest_log' TO N'C:\MSSQL\dbLogs\AspenProd_Reports_log.ldf' 

		 

--**************************************************************************************************
--**************************************************************************************************
--*****************************     RESTORE DEV  ***************************************************
--**************************************************************************************************
--**************************************************************************************************

--N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenProd_REpl.bak' 
RESTORE FILELISTONLY FROM DISK = N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenTest_Repl.bak'

RESTORE DATABASE AspenTest_Reports FROM DISK = N'\\VSQLSERVER2\dbBak\VSQLSERVER\AspenTest_REpl.bak'
	WITH FILE = 1, NOUNLOAD, STATS = 5, RECOVERY, REPLACE, 
		MOVE N'AspenTest' TO N'C:\MSSQL\Data\AspenTest_Reports.mdf', 
		MOVE N'AspenTest_log' TO N'C:\MSSQL\Data\AspenTest_Reports_log.ldf' 

		use aspentest
		go
		select * from sysfiles


--RESTORE LOG AspenProd_03162018_2am
--   FROM DISK =  N'\\VSQLSERVER2\dbBak\VSQLSERVER\TranLogs\TaxDataProd_backup_2016_09_26_100001_1795511.trn'
--   WITH FILE = 1,
--		STATS = 10,
--		NORECOVERY
--GO 

USE [AspenTest_Reports]
GO
 
exec sp_change_users_login 'UPDATE_ONE','AspenClient','AspenClient'
--exec sp_change_users_login 'UPDATE_ONE','Andrew','Andrew'

GO


xp_fixeddrives

--TRUNCATE TALBE, SAVE MOST RECENT DATA TO SAVE SPACE

use AspenTest_Reports
go

drop table DataTransformations.dbo.AccountAgingSummaryHistory_Bak

--select top 10 * from AccountAgingSummaryHistory order by DateCreated desc
select  * 
into DataTransformations.dbo.AccountAgingSummaryHistory_Bak
from AccountAgingSummaryHistory 
where DateCreated > '1/25/2018'

Truncate table AccountAgingSummaryHistory

insert into AccountAgingSummaryHistory (AccountId, DateCreated, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Total, Bucket6, Bucket7)
select * From DataTransformations.dbo.AccountAgingSummaryHistory_Bak

--DocumentESignSignature
select top 100 * 
into DataTransformations.dbo.DocumentESignSignature_Bak
from DocumentESignSignature order by 1 desc

Truncate table DocumentESignSignature

SET IDENTITY_INSERT DocumentESignSignature ON
GO

insert into DocumentESignSignature (DocumentESignSignatureId, DocumentESignId, SignatureType, SignatureImage, DateCreated, FileName)
select DocumentESignSignatureId, DocumentESignId, SignatureType, SignatureImage, DateCreated, FileName From DataTransformations.dbo.DocumentESignSignature_Bak
GO
SET IDENTITY_INSERT DocumentESignSignature OFF


--ChangeLog
select top 1000 *
into DataTransformations.dbo.ChangeLog_bak
 from ChangeLog order by 1 desc
 
Truncate table ChangeLog

SET IDENTITY_INSERT ChangeLog ON
GO
INSERT INTO ChangeLog (  ChangeLogId, TableName, FieldName, BeforeValue, AfterValue, DateCreated, ChangedById, AccountId, DealerId)
SELECT * FROM DataTransformations.dbo.ChangeLog_bak
GO
SET IDENTITY_INSERT ChangeLog OFF
