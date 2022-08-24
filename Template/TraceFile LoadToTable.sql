USE DataTransformations
GO
SELECT * INTO #trace_table FROM ::fn_trace_gettable('c:\mssql\dbTrace\VSQLSERVER_D20180905_Z080001.trc', default)