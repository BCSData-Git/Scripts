--USE [msdb]
--GO
--EXEC msdb.dbo.sp_update_job @job_name=N'Auto Aging',  @enabled=0
--GO

--select 'EXEC msdb.dbo.sp_update_job @job_name=N''' + name + ''',  @enabled=0
--GO
--' from sysjobs 
--WHERE name Not like 'LS%'
--order by name


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC msdb.dbo.sp_update_job @job_name=N'ACA_Final - Archive AR_ACH_CreatedBy',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Auto Aging',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Correct ACH Records',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Fix BranchId arcBill arcSite',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Inventory Maintenance',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Load Category Code Info',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Blocking Alert',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Blocking Logging',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Check Counters',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Correct Jobs Missing Notifications',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Custom Profiler db Trace',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Custom Profiler MinCPU',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Cycle SQL Error Logs',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Get Client Connection Info',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Kill Maint Jobs Running Long',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Load Error Events from Files',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Maintenance - Purge Table Data',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'MaintenancePlan - Backup Databases Full.Subplan_1',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'MaintenancePlan - Check Integrity.Subplan_1',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'MaintenancePlan - Rebuild Indexes.Subplan_1',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'MaintenancePlan - Tran Log Backups.Subplan_1',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'MaintenancePlan - Update Stats.Subplan_1',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Master Account Clean Up',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Monitoring - Sedona GL Out of Balance Alert',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'RESET_TOTALS',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - Account Information Aging Fixes',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - DBAmp Refresh Tables - Every 30 Minutes',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - DBAmp Replicate Tables - Nightly',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - DBAmp Replication- Account Information',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - Next Bill Date - Staging',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce - Sync Last Paid Date with Sedona',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Salesforce DBAmp Refresh Account Oppt Tables',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Sedona - Fix Refund Void',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Sedona-Ganesha New Account Sync',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'SedonaTransfer LastPaid',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'syspolicy_purge_history',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Update SFDC Critical Msg Pend EFT',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'UPDATE WHERE PO NUMBER IS NULL',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'UpdateSedonaARTaxTableFromARTaxTableDate',  @enabled=0
GO
EXEC msdb.dbo.sp_update_job @job_name=N'VividReportsCPMTranUpdate',  @enabled=0
GO 