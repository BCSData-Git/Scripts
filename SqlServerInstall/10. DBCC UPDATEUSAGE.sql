use master
go

--select 'USE [' + name + ']; DBCC UPDATEUSAGE (0);' from sysdatabases 
--where name not in ('distribution', 'master', 'model', 'msdb', 'tempdb', 'ReportServer', 'ReportServerTempDB')
--order by 1


USE [ACA_Final]; DBCC UPDATEUSAGE (0);
USE [ACA_Final_Archive]; DBCC UPDATEUSAGE (0);
USE [AtlasReports]; DBCC UPDATEUSAGE (0);
USE [DataTransformations]; DBCC UPDATEUSAGE (0);
USE [MAC_EDW]; DBCC UPDATEUSAGE (0);
USE [Maintenance]; DBCC UPDATEUSAGE (0);
USE [MasterSetupAstute]; DBCC UPDATEUSAGE (0);
USE [MasterSetupStandard]; DBCC UPDATEUSAGE (0);
USE [Salesforce]; DBCC UPDATEUSAGE (0);
USE [ScanConversion]; DBCC UPDATEUSAGE (0);
USE [Sedona_Support]; DBCC UPDATEUSAGE (0);
USE [SedonaDocuments]; DBCC UPDATEUSAGE (0);
USE [SedonaMaster]; DBCC UPDATEUSAGE (0);
USE [VIVIDREPORTS-SEDONA]; DBCC UPDATEUSAGE (0);

