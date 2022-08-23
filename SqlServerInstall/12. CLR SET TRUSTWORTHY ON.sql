
 
--use master
--go

--select 'alter database [' + name + '] SET TRUSTWORTHY ON
--GO
--' from sysdatabases 
--where name not in ('distribution', 'master', 'model', 'msdb', 'tempdb', 'ReportServer', 'ReportServerTempDB')
--order by 1



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
alter database [ACA_Final] SET TRUSTWORTHY ON
GO
alter database [ACA_Final_Archive] SET TRUSTWORTHY ON
GO
alter database [AtlasReports] SET TRUSTWORTHY ON
GO
alter database [DataTransformations] SET TRUSTWORTHY ON
GO
alter database [MAC_EDW] SET TRUSTWORTHY ON
GO
alter database [Maintenance] SET TRUSTWORTHY ON
GO
alter database [MasterSetupAstute] SET TRUSTWORTHY ON
GO
alter database [MasterSetupStandard] SET TRUSTWORTHY ON
GO
alter database [Salesforce] SET TRUSTWORTHY ON
GO
alter database [ScanConversion] SET TRUSTWORTHY ON
GO
alter database [Sedona_Support] SET TRUSTWORTHY ON
GO
alter database [SedonaDocuments] SET TRUSTWORTHY ON
GO
alter database [SedonaMaster] SET TRUSTWORTHY ON
GO
alter database [VIVIDREPORTS-SEDONA] SET TRUSTWORTHY ON
GO
