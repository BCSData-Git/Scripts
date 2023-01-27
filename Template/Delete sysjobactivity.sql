Select * From msdb.dbo.sysjobactivity
where start_execution_date = 'Jan 14 2023 2:00AM'


delete from msdb.dbo.sysjobactivity 
where session_id = 17 and job_id = '4A5FA973-8239-47D5-88B3-AB11FDA587A4'





--create temp table find pattern ones that are NULL are last_executed_step_id, last_executed_step_date, stop_execution_date, job_history_id,
-- next_scheduled_run_date
--then create delete that joins tmp table to sysjobactivity with jobid or session id or both


Create Table #tmp(
	[session_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[run_requested_date] [datetime] NULL,
	[run_requested_source] [sysname] NULL,
	[queued_date] [datetime] NULL,
	[start_execution_date] [datetime] NULL,
	[last_executed_step_id] [int] NULL,
	[last_executed_step_date] [datetime] NULL,
	[stop_execution_date] [datetime] NULL,
	[job_history_id] [int] NULL,
	[next_scheduled_run_date] [datetime] NULL
) 

Insert Into #tmp ([session_id], [job_id])
Select [session_id], [job_id]
from msdb.dbo.sysjobactivity
where start_execution_date < GETDATE()-3 and stop_execution_date is NULL


Delete s
from dbo.sysjobactivity s 
 join #tmp t ON t.session_id = s.session_id and t.job_id = s.job_id

 



