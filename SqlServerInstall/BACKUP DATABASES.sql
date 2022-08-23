--ACA_Final_backup_2021_07_14_033002_6308733.bak 
-- restore filelistonly from disk = N'\\sedona\n$\MSSQL\dbBak\TestBAK\ACA_Final_backup_2021_07_14_033002_6308733.bak'


--select 'USE master
--GO
--ALTER DATABASE ' + name + ' SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE ' + name + ' TO  DISK = N''\\sedona\n$\MSSQL\dbBak\' + name + '.bak'' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N''' + name + ' Full backup'',  NOSKIP ,  STATS = 10, NOFORMAT
--GO'
--from sysdatabases 
--where name not in ('master', 'model', 'msdb', 'tempdb', 'distribution')
--order by name



 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE master
GO
ALTER DATABASE ACA_Final SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE ACA_Final TO  DISK = N'\\sedona\n$\MSSQL\dbBak\ACA_Final.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ACA_Final Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE ACA_Final_Archive SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE ACA_Final_Archive TO  DISK = N'\\sedona\n$\MSSQL\dbBak\ACA_Final_Archive.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ACA_Final_Archive Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO

--***************** NEED TO DEAL WITH MDF ****************************************************
--********************************************************************************************
--USE master
--GO
--ALTER DATABASE Archive_20210611 SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE Archive_20210611 TO  DISK = N'\\sedona\n$\MSSQL\dbBak\Archive_20210611.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'Archive_20210611 Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
--GO


--********************************************************************************************
--********************************************************************************************


USE master
GO
ALTER DATABASE AtlasReports SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE AtlasReports TO  DISK = N'\\sedona\n$\MSSQL\dbBak\AtlasReports.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'AtlasReports Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
--ALTER DATABASE C3_Sandbox SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE C3_Sandbox TO  DISK = N'\\sedona\n$\MSSQL\dbBak\C3_Sandbox.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'C3_Sandbox Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE DataTransformations SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE DataTransformations TO  DISK = N'\\sedona\n$\MSSQL\dbBak\DataTransformations.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'DataTransformations Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE Maintenance SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE Maintenance TO  DISK = N'\\sedona\n$\MSSQL\dbBak\Maintenance.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'Maintenance Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE MasterSetupAstute SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE MasterSetupAstute TO  DISK = N'\\sedona\n$\MSSQL\dbBak\MasterSetupAstute.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'MasterSetupAstute Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
--ALTER DATABASE ReportServer SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE ReportServer TO  DISK = N'\\sedona\n$\MSSQL\dbBak\ReportServer.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ReportServer Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
--GO
--USE master
--GO
--ALTER DATABASE ReportServerTempDB SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE ReportServerTempDB TO  DISK = N'\\sedona\n$\MSSQL\dbBak\ReportServerTempDB.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ReportServerTempDB Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE Salesforce SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE Salesforce TO  DISK = N'\\sedona\n$\MSSQL\dbBak\Salesforce.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'Salesforce Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
--USE master
--GO
--ALTER DATABASE Sandbox_20210203 SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE Sandbox_20210203 TO  DISK = N'\\sedona\n$\MSSQL\dbBak\Sandbox_20210203.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'Sandbox_20210203 Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
--USE master
--GO
--ALTER DATABASE SandboxTest SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE SandboxTest TO  DISK = N'\\sedona\n$\MSSQL\dbBak\SandboxTest.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'SandboxTest Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
--GO
USE master
GO
ALTER DATABASE ScanConversion SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE ScanConversion TO  DISK = N'\\sedona\n$\MSSQL\dbBak\ScanConversion.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ScanConversion Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE Sedona_Support SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE Sedona_Support TO  DISK = N'\\sedona\n$\MSSQL\dbBak\Sedona_Support.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'Sedona_Support Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE SedonaDocuments SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE SedonaDocuments TO  DISK = N'\\sedona\n$\MSSQL\dbBak\SedonaDocuments.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'SedonaDocuments Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
USE master
GO
ALTER DATABASE SedonaMaster SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE SedonaMaster TO  DISK = N'\\sedona\n$\MSSQL\dbBak\SedonaMaster.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'SedonaMaster Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO

--USE master
--GO
--ALTER DATABASE TaxDemo_Sandbox SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE TaxDemo_Sandbox TO  DISK = N'\\sedona\n$\MSSQL\dbBak\TaxDemo_Sandbox.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'TaxDemo_Sandbox Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
--GO

--USE master
--GO
--ALTER DATABASE TestDB SET RECOVERY FULL WITH NO_WAIT
--GO
--BACKUP DATABASE TestDB TO  DISK = N'\\sedona\n$\MSSQL\dbBak\TestDB.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'TestDB Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
--GO
USE master
GO
ALTER DATABASE [VIVIDREPORTS-SEDONA] SET RECOVERY FULL WITH NO_WAIT
GO
BACKUP DATABASE [VIVIDREPORTS-SEDONA] TO  DISK = N'\\sedona\n$\MSSQL\dbBak\VIVIDREPORTS-SEDONA.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'VIVIDREPORTS-SEDONA Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
GO
 