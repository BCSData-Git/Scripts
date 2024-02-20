USE MASTER
GO
SELECT DISTINCT 
         s.volume_mount_point AS [Drive] 
       , CAST(s.available_bytes / 1048576.0 as decimal(20,2)) AS [AvailableMBs] 
       , CAST(s.available_bytes / 1048576.0 / 1024 as decimal(20,2)) AS [AvailableGBs] 
       , CAST(s.total_bytes / 1048576.0 as decimal(20,2)) AS [TotalMBs] 
       , CAST(s.total_bytes / 1048576.0 / 1024 as decimal(20,2)) AS [TotalGBs] 
       , CONVERT(DECIMAL(5, 2), ((s.available_bytes * 1.0)/s.total_bytes) * 100) AS PercentFree 
-- SELECT s.*, f.* 
FROM sys.master_files AS f 
	CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.[file_id]) AS s 
ORDER BY Drive

