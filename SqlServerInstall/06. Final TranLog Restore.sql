use msdb
go

--select 'exec sp_start_job @job_name = ' + name + ';' from sysjobs where name like 'lsres%'
--order by name

exec sp_start_job @job_name = LSRestore_SEDONA_ACA_Final;
exec sp_start_job @job_name = LSRestore_SEDONA_ACA_Final_Archive;
exec sp_start_job @job_name = LSRestore_SEDONA_AtlasReports;
exec sp_start_job @job_name = LSRestore_SEDONA_DataTransformations;
exec sp_start_job @job_name = LSRestore_SEDONA_Maintenance;
exec sp_start_job @job_name = LSRestore_SEDONA_MasterSetupAstute;
exec sp_start_job @job_name = LSRestore_SEDONA_Salesforce;
exec sp_start_job @job_name = LSRestore_SEDONA_ScanConversion;
exec sp_start_job @job_name = LSRestore_SEDONA_Sedona_Support;
exec sp_start_job @job_name = LSRestore_SEDONA_SedonaDocuments;
exec sp_start_job @job_name = LSRestore_SEDONA_SedonaMaster;
exec sp_start_job @job_name = [LSRestore_SEDONA_VIVIDREPORTS-SEDONA];
