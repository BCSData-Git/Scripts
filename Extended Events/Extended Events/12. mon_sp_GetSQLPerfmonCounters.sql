use maintenance
go
select * from counterdetails 
where countername like '%proc%'

select counterdatetime, round(countervalue, 0) as countervalue from counterdata with (nolock)
where counterid in(30, 33, 58, 198, 248)
  and counterdatetime > '2018-08-27 00:00:07.740'
  --and countervalue > 75
order by counterdatetime desc

select top 500 counterdatetime, round(countervalue, 0) as countervalue 
from counterdata with (nolock)
where counterid in (30, 33, 58)
  and counterdatetime > '2018-08-20 00:00:07.740'
order by counterdatetime desc

--SRVGAMMA2
use Maintenance
go

  SELECT convert(varchar(25), getdate(), 120) 

   select DATEADD(HOUR,18,CONVERT(VARCHAR(10), GETDATE()-1,110))
  select DATEADD(HOUR,6,CONVERT(VARCHAR(10), GETDATE()-1,110))


exec mon_sp_GetSQLPerfmonCounters @datebeg = '2018-09-27 06:00:07.740', @dateend = '2018-09-27 20:00:07.740'

create proc mon_sp_GetSQLPerfmonCounters
	@datebeg varchar(50)= NULL,
	@dateend varchar(50)= NULL
as

if @datebeg is null or @dateend is null
begin
	set @datebeg = convert(varchar(25),  DATEADD(HOUR,6,CONVERT(VARCHAR(10), GETDATE()-1,110)), 120) --6am yesterday
	set @dateend = convert(varchar(25),  DATEADD(HOUR,18,CONVERT(VARCHAR(10), GETDATE()-1,110)), 120) --6pm yesterday
end
 
select  counterdatetime, round(countervalue, 0) as countervalue 
from Maintenance.dbo.counterdata with (nolock)
where counterid in (1)
  and counterdatetime > @datebeg--'2018-09-27 06:00:07.740'
  and counterdatetime < @dateend
order by counterdatetime 

use Maintenance
go
select * from counterdetails

--SRVRHO2
select  counterdatetime, round(countervalue, 0) as countervalue 
from Maintenance.dbo.counterdata with (nolock)
where counterid in  (3, 55, 107)
  and counterdatetime > '2018-09-06 06:00:07.740'
  and counterdatetime < '2018-09-06 20:00:07.740'
order by counterdatetime 

--*************************************************
--			PLE
--*************************************************

use maintenance
go
select * from counterdetails 
where countername like '%Page%'

select counterdatetime, round(countervalue, 0) as countervalue from counterdata with (nolock)
where counterid in(35, 40) --PLE
  and counterdatetime > '2018-03-15 00:00:00'
  --and countervalue > 75
order by counterdatetime desc





Run for 10 minute(s) until Oct 28 2017  7:53AM



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
where r.session_id > 50
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