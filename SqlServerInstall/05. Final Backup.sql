use msdb
go
--select 'exec sp_start_job @job_name = ' + name + ';' from sysjobs where name like 'LSBackup%'
--order by name

exec sp_start_job @job_name = LSBackup_ACA_Final;
exec sp_start_job @job_name = LSBackup_ACA_Final_Archive;
exec sp_start_job @job_name = LSBackup_AtlasReports;
exec sp_start_job @job_name = LSBackup_DataTransformations;
exec sp_start_job @job_name = LSBackup_Maintenance;
exec sp_start_job @job_name = LSBackup_MasterSetupAstute;
exec sp_start_job @job_name = LSBackup_Salesforce;
exec sp_start_job @job_name = LSBackup_ScanConversion;
exec sp_start_job @job_name = LSBackup_Sedona_Support;
exec sp_start_job @job_name = LSBackup_SedonaDocuments;
exec sp_start_job @job_name = LSBackup_SedonaMaster;
exec sp_start_job @job_name = [LSBackup_VIVIDREPORTS-SEDONA];