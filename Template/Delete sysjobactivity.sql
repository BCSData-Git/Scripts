

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
from msdb.dbo.sysjobactivity s 
 join #tmp t ON t.session_id = s.session_id and t.job_id = s.job_id

 



