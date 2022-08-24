Declare @Trace_id int


SELECT @Trace_id = traceid  FROM sys.fn_trace_getinfo(0) 
	Where property = 5 and value = 1 and Traceid <> 1 -- Property - 5 (Current trace Status), Value - 1 (running) , Trace 1 is system Trace

exec sp_trace_setstatus  @traceid = @Trace_id ,  @status = 0 -- 0 Stop Trace

exec sp_trace_setstatus  @traceid = @Trace_id ,  @status = 2  -- Cloese and deletes its definition from the server

go

SELECT * FROM sys.fn_trace_getinfo(0) 
 