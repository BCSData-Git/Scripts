--Top CPU Consumers Running Now
select
  r.session_id,start_time,r.status,DB_Name(Database_id),cpu_time,total_elapsed_time,reads,writes,logical_reads,row_count,hostname,loginame,
  t.text as Query,
  SUBSTRING(t.text, r.statement_start_offset / 2, 
    (CASE WHEN r.statement_end_offset = -1 
        THEN DATALENGTH(t.text)
        ELSE r.statement_end_offset END  - r.statement_start_offset) / 2)
      as sqlcmd
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(r.sql_handle) as t
Join master..sysprocesses s on r.session_id = s.spid
where r.session_id > 10
  and r.status = 'running'
order by cpu_time desc;
 
 --TOP READS
 select
  r.session_id,start_time,r.status,DB_Name(Database_id),cpu_time,total_elapsed_time,reads,writes,logical_reads,row_count,hostname,loginame,
  t.text as Query,
  SUBSTRING(t.text, r.statement_start_offset / 2, 
    (CASE WHEN r.statement_end_offset = -1 
        THEN DATALENGTH(t.text)
        ELSE r.statement_end_offset END  - r.statement_start_offset) / 2)
      as sqlcmd
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(r.sql_handle) as t
Join master..sysprocesses s on r.session_id = s.spid
where r.session_id > 50
  and r.status = 'running'
order by logical_reads desc;
