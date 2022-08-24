use maintenance
go
[usp_ReplLogReaderAgent_StatusGet]  'chris.b@alder.com'
[usp_ReplDistributionAgent_StatusGet] 'chris.b@alder.com'


--/*  
--Description: Checks the status of the LogReader job or jobs.  
--*/  
  
ALTER PROCEDURE [dbo].[usp_ReplLogReaderAgent_StatusGet]    
	@pRecipients varchar(255) = 'your_email@yourcompany.com'  
AS  
  
  SET NOCOUNT ON;  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
  DECLARE @is_sysadmin INT  
  DECLARE @job_owner   sysname  
  DECLARE @job_id uniqueidentifier  
  DECLARE @job_name sysname  
  DECLARE @running int   
  DECLARE @cnt int  
  DECLARE @msg varchar(8000)  
  DECLARE @msg_header varchar(1000)  
  DECLARE @categoryid int   
    
  
select 
	la.name,
	la.publisher_db,  
	case lh.runstatus  
		when 1 then 'Start'  
		when 2 then 'Succeed'  
		when 3 then 'In progress'  
		when 4 then 'Idle'  
		when 5 then 'Retry'  
		when 6 then 'Fail'  
		else 'Unknown'  
	end as runstatus, 
	lh.time, 
	lh.comments  
from distribution..MSlogreader_history lh   
inner join distribution..MSlogreader_agents la on lh.agent_id = la.id  
inner join (select lh.agent_id, max(lh.time) as LastTime  
	from distribution..MSlogreader_history lh   
	inner join distribution..MSlogreader_agents la on lh.agent_id = la.id  
	group by lh.agent_id) r on r.agent_id = lh.agent_id and r.LastTime = lh.time  
where lh.runstatus not in (3,4) -- 3:In Progress, 4: Idle  
  
if @@rowcount > 0    

BEGIN  
  SELECT  @job_owner =   SUSER_SNAME()  
         ,@is_sysadmin = 1   
         ,@running = 0  
         ,@categoryid = 13 -- LogReader jobs  
  
  CREATE TABLE #job (job_id  UNIQUEIDENTIFIER NOT NULL,  
                    last_run_date         INT ,  
                    last_run_time         INT ,  
                    next_run_date         INT ,  
                    next_run_time         INT ,  
                    next_run_schedule_id  INT ,  
                    requested_to_run      INT ,   
                    request_source        INT ,  
                    request_source_id     sysname COLLATE database_default NULL,  
                    running               int ,  
                    current_step          INT ,  
                    current_retry_attempt INT ,  
                    job_state             INT)  
  
      INSERT INTO #job  
      EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner--, @job_id   
    
      SELECT @running = isnull(sum(j.running),-1),@cnt = count(*)   
      FROM #job j  
      join msdb..sysjobs s on j.job_id = s.job_id  
      where category_id = @categoryid -- logreader jobs  
  
 if @running <> @cnt  
 BEGIN  
  SELECT @msg_header = 'LogReader job(s) FAILING OR STOPPED. Please check replication job(s) ASAP.'  
  SELECT @msg_header = @msg_header + char(10)   
  SELECT @msg_header = @msg_header + '************************************************************************'   

  set @msg = ''    
  SELECT @msg = @msg + char(10)+'"' + s.[name] + '" - '+ convert(varchar, isnull(j.running,-1))  
  FROM #job j  
  join msdb..sysjobs s on j.job_id = s.job_id  
  where category_id = @categoryid  
  and isnull(j.running,-1) <> 1  
    
  SELECT @msg = @msg_header + char(10) + nullif(@msg,'')  
     
  if @@version like 'Microsoft SQL Server  2000%'  
     exec master.dbo.xp_sendmail  @profile_name = 'SQLAlerts',                     
     @recipients= @pRecipients , --'youremail@yourcompany.com',  
     @subject='Production Replication LogReader Agent Alert',  
     @message = @msg,  
       @width = 100    
  else   
    exec msdb.dbo.sp_send_dbmail  @profile_name = 'SQLAlerts',                     
     @recipients= @pRecipients , --'youremail@yourcompany.com',  
     @subject= 'Production Replication LogReader Agent Alert',  
     @body = @msg   
 END  
  
END  

GO


/*
Description : Check continous distributor agent to see if it stopped or running
*/

ALTER PROCEDURE [dbo].[usp_ReplDistributionAgent_StatusGet]    
@pRecipients varchar(255) = 'youremail@yourcompany.com'  
AS  
begin

SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  

DECLARE @is_sysadmin INT  
DECLARE @job_owner   sysname  
DECLARE @job_id uniqueidentifier  
DECLARE @job_name sysname  
DECLARE @running int   
DECLARE @cnt int  
DECLARE @msg varchar(8000)  
DECLARE @msg_header varchar(4000)  
DECLARE @categoryid int   

SELECT  @job_owner =   SUSER_SNAME()  
     ,@is_sysadmin = 1   
     ,@running = 0  
     ,@categoryid = 10 -- Distributor jobs  

CREATE TABLE #jobStatus (job_id  UNIQUEIDENTIFIER NOT NULL,  
                last_run_date         INT ,  
                last_run_time         INT ,  
                next_run_date         INT ,  
                next_run_time         INT ,  
                next_run_schedule_id  INT ,  
                requested_to_run      INT ,   
                request_source        INT ,  
                request_source_id     sysname COLLATE database_default NULL,  
                running               int ,  
                current_step          INT ,  
                current_retry_attempt INT ,  
                job_state             INT)  

  INSERT INTO #jobStatus  
  EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner--, @job_id   
   
select j.name, js.command, jss.running
from msdb.dbo.sysjobsteps js
	join msdb.dbo.sysjobs j on js.job_id = j.job_id
	join #jobStatus jss on js.job_id = jss.job_id
where step_id = 2 and subsystem = 'Distribution'
	and command like '%-Continuous'
	and jss.running <> 1 -- Not running

 if @@ROWCOUNT > 0
 BEGIN  
 
  SELECT @msg_header = 'Distributor job(s) FAILING OR STOPPED. Please check replication job(s) ASAP.'  
  SELECT @msg_header = @msg_header + char(10)  
    SELECT @msg_header = @msg_header + 'Here is the list of Job(s) that are failing or stopped'
  SELECT @msg_header = @msg_header + char(10)   
  SELECT @msg_header = @msg_header + '****************************************************************************'   
  
  set @msg = ''
	select @msg = @msg + CHAR(10) + j.name
	from msdb.dbo.sysjobsteps js
		join msdb.dbo.sysjobs j on js.job_id = j.job_id
		join #jobStatus jss on js.job_id = jss.job_id
	where step_id = 2 and subsystem = 'Distribution'
		and command like '%-Continuous'
		and jss.running <> 1 -- Not running
	
    
  SELECT @msg = @msg_header + char(10) + nullif(@msg,'')  
  
  print @msg
     
  if @@version like 'Microsoft SQL Server  2000%'  
     exec master.dbo.xp_sendmail @profile_name = 'SQLAlerts',                   
     @recipients= @pRecipients , --'youremail@yourcompany.com',  
     @subject='Production Replication Distribution Agent Alert',  
     @message = @msg,  
       @width = 100    
  else   
    exec msdb.dbo.sp_send_dbmail @profile_name = 'SQLAlerts',                     
     @recipients= @pRecipients , --'youremail@yourcompany.com',  
     @subject= 'Production Replication Distribution Agent Alert',  
     @body = @msg   
 END  

drop table #jobStatus

end
GO


