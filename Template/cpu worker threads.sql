declare @max int
select @max = max_workers_count from sys.dm_os_sys_info

select 
    @max as 'TotalThreads',
    sum(active_Workers_count) as 'CurrentThreads',  --Number of workers that are active.
    @max - sum(active_Workers_count) as 'AvailableThreads',
    sum(runnable_tasks_count) as 'WorkersWaitingForCpu',
    sum(work_queue_count) as 'RequestWaitingForThreads' , --Number of tasks in the pending queue. These tasks are waiting for a worker to pick them up.
    sum(current_workers_count) as 'AssociatedWorkers' --Number of workers that are associated with this scheduler. This count includes workers that are not assigned any task.
from sys.dm_os_Schedulers 
where status='VISIBLE ONLINE'
 
----max worker threads
--select max_workers_count 
--from sys.dm_os_sys_info  

----consumed worker threads
--select count(*) as numworkers 
--from sys.dm_os_workers 
 

--SELECT sum(current_workers_count) as current_workers_count
--	, sum(active_workers_count) as active_workers_count 
--FROM sys.dm_os_schedulers
--WHERE STATUS = 'Visible Online'
