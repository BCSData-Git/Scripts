USE master
go
--Enable Optimize for Adhoc Workloads
-- Set AdHoc Workloads = True
--If your adhoc plan cache is 20-30% of total Plan Cache, 
SELECT AdHoc_Plan_MB, Total_Cache_MB,
        AdHoc_Plan_MB*100.0 / Total_Cache_MB AS 'AdHoc %'
FROM (
SELECT SUM(CASE
            WHEN objtype = 'adhoc'
            THEN cast(size_in_bytes as decimal(18,2))
            ELSE 0 END) / 1048576.0 AdHoc_Plan_MB,
        SUM(cast(size_in_bytes as decimal(18,2))) / 1048576.0 Total_Cache_MB
FROM sys.dm_exec_cached_plans) T


-- if you haven't looked at advanced options before in SP_CONFIGURE
SP_CONFIGURE 'Show Advanced Options', 1
GO
-- To make that online setting take effect
RECONFIGURE
GO
 
-- Change Optimize for Ad Hoc Workload Setting to 1 - or enabled
SP_CONFIGURE 'optimize for ad hoc workloads', 1
GO
RECONFIGURE
GO


-- Check the Disabled record.
SELECT * FROM SYS.CONFIGURATIONS WHERE Name = 'optimize for ad hoc workloads'
