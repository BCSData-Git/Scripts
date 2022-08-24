USE pubs
GO
SELECT * INTO trace_table FROM ::fn_trace_gettable('c:\my_trace.trc', default)
