select @@ServerName as SQLServerName,    dbid,d.name ,d.compatibility_level,d.recovery_model_desc,convert(decimal(18,2),(sum(size)*8)/1024.0) as db_size_in_mb
       , (select convert(decimal(18,2),(Sum(size)*8)/1024.0) from sys.sysaltfiles
              where dbid=saf.dbid and groupid=0
              group by groupid) as log_size_in_mb
       ,  Round(((select convert(decimal(18,2),(Sum(size)*8)/1024.0) from sys.sysaltfiles
                             where dbid=saf.dbid and groupid=0 group by groupid)
              / convert(decimal(18,2),(sum(size)*8)/1024.0))* 100,2) as log_size_percent
       , (select max(backup_finish_date) from msdb.dbo.backupset b
              where type = 'D'
                and b.database_name = d.name) as LastFullBackup
       , (select max(backup_finish_date) from msdb.dbo.backupset b
              where type = 'L'
                and b.database_name = d.name) as LastLogBackup
       , d.create_date
from master.sys.sysaltfiles saf   
  join master.sys.databases d on saf.dbid=d.database_id
where groupid>0  and dbid not in (1,3,4)
group by dbid,d.name,d.compatibility_level,d.recovery_model_desc, d.create_date