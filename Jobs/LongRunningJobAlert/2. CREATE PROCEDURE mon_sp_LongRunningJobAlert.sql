 use Maintenance
 go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris Becker
-- Create date: 1/11/2022
-- Description:	Sends email alert when job running longer than average duration plus 2 std deviations
-- =============================================
ALTER PROCEDURE mon_sp_LongRunningJobAlert

AS
BEGIN 

	SET NOCOUNT ON;
	
	 
	/*=============================================
	  Variables:
		@MinHistExecutions - Minimum number of job executions we want to consider 
		@MinAvgSecsDuration - Threshold for minimum job duration we care to monitor
		@HistoryStartDate - Start date for historical average
		@HistoryEndDate - End date for historical average
 
	  These variables allow for us to control a couple of factors. First
	  we can focus on jobs that are running long enough on average for
	  us to be concerned with (say, 30 seconds or more). Second, we can
	  avoid being alerted by jobs that have run so few times that the
	  average and standard deviations are not quite stable yet. This script
	  leaves these variables at 1.0, but I would advise you alter them
	  upwards after testing.
 
	  Returns: One result set containing a list of jobs that
	  are currently running and are running longer than two standard deviations 
	  away from their historical average. The "Min Threshold" column
	  represents the average plus two standard deviations. 

	  note [1] - comment this line and note [2] line if you want to report on all history for jobs
	  note [2] - comment just this line is you want to report on running and non-running jobs
	 =============================================*/
	 --drop table #final

	DECLARE @HistoryStartDate datetime 
	  ,@HistoryEndDate datetime  
	  ,@MinHistExecutions int   
	  ,@MinAvgSecsDuration int  
 
	SET @HistoryStartDate = '19000101'
	SET @HistoryEndDate = GETDATE()
	SET @MinHistExecutions = 1.0
	SET @MinAvgSecsDuration = 1.0
 
	DECLARE @currently_running_jobs TABLE (
		job_id UNIQUEIDENTIFIER NOT NULL
		,last_run_date INT NOT NULL
		,last_run_time INT NOT NULL
		,next_run_date INT NOT NULL
		,next_run_time INT NOT NULL
		,next_run_schedule_id INT NOT NULL
		,requested_to_run INT NOT NULL
		,request_source INT NOT NULL
		,request_source_id SYSNAME NULL
		,running INT NOT NULL
		,current_step INT NOT NULL
		,current_retry_attempt INT NOT NULL
		,job_state INT NOT NULL
		) 
 
	--capture details on jobs
	INSERT INTO @currently_running_jobs
	EXECUTE master.dbo.xp_sqlagent_enum_jobs 1,''
 
	;WITH JobHistData AS
	(
	  SELECT job_id
	 ,date_executed=msdb.dbo.agent_datetime(run_date, run_time)
	 ,secs_duration=run_duration/10000*3600
						  +run_duration%10000/100*60
						  +run_duration%100
	  FROM msdb.dbo.sysjobhistory
	  WHERE step_id = 0   --Job Outcome
	  AND run_status = 1  --Succeeded
	)
	,JobHistStats AS
	(
	  SELECT job_id
			,AvgDuration = AVG(secs_duration*1.)
			,AvgPlus2StDev = AVG(secs_duration*1.) + 2*stdevp(secs_duration)
	  FROM JobHistData
	  WHERE date_executed >= DATEADD(day, DATEDIFF(day,'19000101',@HistoryStartDate),'19000101')
	  AND date_executed < DATEADD(day, 1 + DATEDIFF(day,'19000101',@HistoryEndDate),'19000101') 
	  GROUP BY job_id HAVING COUNT(*) >= @MinHistExecutions
	  AND AVG(secs_duration*1.) >= @MinAvgSecsDuration
	)
	SELECT jd.job_id
		  ,j.name AS [JobName]
		  ,MAX(act.start_execution_date) AS [ExecutionDate]
		  ,AvgDuration AS [Historical Avg Duration (secs)]
		  ,AvgPlus2StDev AS [Min Threshhold (secs)]
	Into #Final
	FROM JobHistData jd
	JOIN JobHistStats jhs on jd.job_id = jhs.job_id
	JOIN msdb..sysjobs j on jd.job_id = j.job_id
	JOIN @currently_running_jobs crj ON crj.job_id = jd.job_id --see note [1] above
	JOIN msdb..sysjobactivity AS act ON act.job_id = jd.job_id
	AND act.stop_execution_date IS NULL
	AND act.start_execution_date IS NOT NULL
	WHERE DATEDIFF(SS, act.start_execution_date, GETDATE()) > AvgPlus2StDev
	--AND crj.job_state = 1 --see note [2] above
	GROUP BY jd.job_id, j.name, AvgDuration, AvgPlus2StDev

   
	If Exists (Select * From #Final)
	Begin

		DECLARE @tableHTML  NVARCHAR(MAX) ;
		--[JobName]
		--[ExecutionDate]
	 --   [Historical Avg Duration (secs)]
	 --   [Min Threshhold (secs)]

			SET @tableHTML =
			N'<H1>Long Running Job Alert</H1>' +
			N'<table border="1">' +
			N'<tr><th>JobName</th><th>ExecutionDate</th>' +
			N'<th>[Historical Avg Duration (secs)]</th><th>[Min Threshhold (secs)]</th></tr>' + 
			cast( ( select 
				td = rtrim(f.JobName), '',
				td = rtrim(f.ExecutionDate), '',
				td = rtrim(f.[Historical Avg Duration (secs)]), '',
				td = rtrim(f.[Min Threshhold (secs)]) 
			from #Final f    
			 FOR XML PATH('tr'), TYPE 
			) AS NVARCHAR(MAX) ) +
			N'</table>' ;
	 
		  Declare @subj nvarchar(100) = 'Long Running Job Alert - ' + @@serverName

			EXEC msdb..sp_send_dbmail
				@profile_name =  'SQLAlerts', 
				@recipients = 'chrisb@bcsdata.net',  
				@subject = @subj, --'Long Running Job Alert',
				@body = @tableHTML,
				@body_format = 'HTML',
				@importance ='HIGH'

	End


	Declare @jobName Nvarchar(250)

	--Stop Maintenance Jobs
	Select top 1 @jobName = f.JobName  
	From #Final f 
	Where f.JobName like 'Maintenance%'

    --Exec msdb.dbo.sp_stop_job @job_name = @jobName

	 
	Drop Table #Final
	 
	 
END

GO
