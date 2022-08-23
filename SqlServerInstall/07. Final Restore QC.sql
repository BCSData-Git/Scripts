use msdb
go
--\\sedona\n$\MSSQL\dbBak\TranLogs\ACA_Final_Archive_20210828235604.trn
--Log Shipping QC

select d.name as primary_database 
                , case 
                                when p.primary_database is null then 'NO LS' 
                                when right(p.last_backup_file, len(p.last_backup_file) - 29) = right(s.last_restored_file, len(s.last_restored_file) - 7)  then 'OK' 
                                when p.last_backup_file = s.last_restored_file THEN 'OK' 
                                when s.last_restored_file is null then 'NO SYNC' 
                                else 'NO SYNC' end as FileSyncStatus 
                 , p.primary_database, p.last_backup_date , p.last_backup_file 
                , s.last_restored_file, s.secondary_database, s.last_restored_date  
from [SEDONA].master.dbo.sysdatabases d 
                left join [SEDONA].msdb.dbo.log_shipping_primary_databases p on d.name = p.primary_database 
                left join log_shipping_secondary_databases s on s.secondary_database = p.primary_database 
where d.name not in ('master', 'model', 'msdb', 'tempdb') 
order by 1



