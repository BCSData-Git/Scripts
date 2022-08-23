--select 'USE [' + name + ']; exec sp_updatestats;' from sysdatabases  
--where name not in ('distribution', 'master', 'model', 'msdb', 'tempdb', 'ReportServer', 'ReportServerTempDB')
--order by 1

--USE [ASPState]; exec sp_updatestats; 


USE [ACA_Final]; exec sp_updatestats;
USE [ACA_Final_Archive]; exec sp_updatestats;
USE [AtlasReports]; exec sp_updatestats;
USE [DataTransformations]; exec sp_updatestats;
USE [MAC_EDW]; exec sp_updatestats;
USE [Maintenance]; exec sp_updatestats;
USE [MasterSetupAstute]; exec sp_updatestats;
USE [MasterSetupStandard]; exec sp_updatestats;
USE [Salesforce]; exec sp_updatestats;
USE [ScanConversion]; exec sp_updatestats;
USE [Sedona_Support]; exec sp_updatestats;
USE [SedonaDocuments]; exec sp_updatestats;
USE [SedonaMaster]; exec sp_updatestats;
USE [VIVIDREPORTS-SEDONA]; exec sp_updatestats;
