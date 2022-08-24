Exec mon_sp_rptGetSQLActivity
Exec mon_sp_rptGetSQLActivity @sortBy = 0 --Tot_cpu_time / default  
Exec mon_sp_rptGetSQLActivity @sortBy = 1  -- Avg_cpu_time 
Exec mon_sp_rptGetSQLActivity @sortBy = 2 -- Tot_logical_reads  
Exec mon_sp_rptGetSQLActivity @sortBy = 3 -- Avg_logical_reads  
Exec mon_sp_rptGetSQLActivity @sortBy = 4 -- Tot_Writes  
Exec mon_sp_rptGetSQLActivity @sortBy = 5 -- Avg_Writes  
Exec mon_sp_rptGetSQLActivity @sortBy = 6 -- ExecCount
GO

USE Maintenance
GO
 
CREATE PROC mon_sp_rptGetSQLActivity
 	@BegDate datetime = NULL,
	@EndDate datetime = NULL,
	@sortBy tinyint = 0
 AS
  
--if @sortBy = 0 --Tot_cpu_time / default 
--if @sortBy = 1 -- Avg_cpu_time 
--if @sortBy = 2 -- Tot_logical_reads 
--if @sortBy = 3 -- Avg_logical_reads 
--if @sortBy = 4 -- Tot_Writes 
--if @sortBy = 5 -- Avg_Writes 
--if @sortBy = 6 -- ExecCount


If @BegDate Is NULL 
Begin
	Set @BegDate = Cast(GetDate()-1 As Date)
	Set @EndDate = DateAdd(second, -1, cast(Cast(GetDate() As Date) as datetime))
End

--select @BegDate, @EndDate

select 1 As ItemCount
	, Case When object_name is null then (case when query_hash = 0 then SUBSTRING([statement],1,50) else cast(query_hash as nvarchar(500)) end) else [object_name] end As GroupByVal
	, DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), [timestamp]) AS pdtlocaltime
	, *
into #tmp
from montblXE_CPUReadsFilterTrace with (Nolock)
where [timestamp] > dateadd(hour, -32, getutcdate())

SELECT ItemCount
	, Case 
		When GroupByVal = Cast(query_hash As nvarchar(500)) Then SUBSTRING([statement],1,40)  
		Else GroupByVal 
	  End As GroupByVal
	, pdtlocaltime, [timestamp], event_name, cpu_time, duration, physical_reads, logical_reads, writes
	, username, database_name, client_hostname
Into #Final
FROM #tmp
Where pdtlocaltime Between @BegDate and @EndDate
  and Datepart(hour, pdtlocaltime) between 8 and 20

Select Sum(ItemCount) As ExecCount, GroupByVal, event_name
	, Sum(cpu_time) as Tot_cpu_time, Avg(cpu_time) as Avg_cpu_time
	, Sum(logical_reads) As Tot_logical_reads, Avg(logical_reads) As Avg_logical_reads
	, Sum(writes) As Tot_Writes, Avg(writes) As Avg_Writes
Into #Return
From #Final
Group by GroupByVal, event_name
 
 
if @sortBy = 0 --Tot_cpu_time / default
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Tot_cpu_time desc
end

if @sortBy = 1 -- Avg_cpu_time
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Avg_cpu_time desc
end

if @sortBy = 2 -- Tot_logical_reads
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Tot_logical_reads desc
end

if @sortBy = 3 -- Avg_logical_reads
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Avg_logical_reads desc
end

if @sortBy = 4 -- Tot_Writes
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Tot_Writes desc
end

if @sortBy = 5 -- Avg_Writes
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by Avg_Writes desc
end

if @sortBy = 6 -- ExecCount
begin
	Select Top 15 ExecCount, GroupByVal, event_name, Tot_cpu_time, Tot_cpu_time / ExecCount as Avg_cpu_time
		, Tot_logical_reads, Tot_logical_reads / ExecCount as Avg_logical_reads, Tot_Writes, Tot_Writes / ExecCount as Avg_Writes 
	From #Return
	Order by ExecCount desc
end

Drop table #Final
Drop table #tmp
Drop table #Return