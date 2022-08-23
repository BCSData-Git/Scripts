use master
go

--select 'restore database ' + name + ' with recovery;' from sysdatabases
--where name not in ('distribution', 'master', 'model', 'msdb', 'tempdb', 'ReportServer', 'ReportServerTempDB')


restore database ACA_Final with recovery;
restore database ACA_Final_Archive with recovery;
restore database AtlasReports with recovery;
restore database DataTransformations with recovery;
restore database MAC_EDW with recovery;
restore database Maintenance with recovery;
restore database MasterSetupAstute with recovery;
--restore database MasterSetupStandard with recovery;
restore database ReportServer with recovery;
restore database ReportServerTempDB with recovery;
restore database Salesforce with recovery;
restore database ScanConversion with recovery;
restore database Sedona_Support with recovery;
restore database SedonaDocuments with recovery;
restore database SedonaMaster with recovery;
restore database [VIVIDREPORTS-SEDONA] with recovery;
