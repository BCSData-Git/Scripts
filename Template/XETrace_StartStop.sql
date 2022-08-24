DROP EVENT SESSION [XE_CPU_Reads_Filter_Trace] ON SERVER 
GO
 

CREATE EVENT SESSION [XE_CPU_Reads_Filter_Trace] ON SERVER 
ADD EVENT sqlserver.rpc_completed(SET collect_data_stream=(0),collect_statement=(1)
    ACTION(sqlserver.client_hostname,sqlserver.database_id
		,sqlserver.database_name --The event action name, "sqlserver.database_name", is invalid, or the object could not be found (SQL 2008R2)
		,sqlserver.nt_username
		,sqlserver.query_hash --The event action name, "sqlserver.query_hash", is invalid, or the object could not be found (SQL 2008R2)
		,sqlserver.session_id,sqlserver.sql_text
		,sqlserver.username)
    WHERE ([package0].[greater_than_equal_uint64]([cpu_time],(1000000)) --1Sec CPU
		OR [package0].[greater_than_equal_uint64]([logical_reads],(100000)))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_hostname,sqlserver.database_id
		,sqlserver.database_name --The event action name, "sqlserver.database_name", is invalid, or the object could not be found (SQL 2008R2)
		,sqlserver.nt_username
		,sqlserver.query_hash --The event action name, "sqlserver.query_hash", is invalid, or the object could not be found (SQL 2008R2)
		,sqlserver.session_id,sqlserver.sql_text
		,sqlserver.username)
    WHERE ([package0].[greater_than_equal_uint64]([cpu_time],(1000000))  --1Sec CPU
		OR [package0].[greater_than_equal_uint64]([logical_reads],(100000)))) 
ADD TARGET package0.event_file(SET filename=N'C:\MSSQL\dbTrace\XE_CPU_Reads_Filter_Trace') --*********** DIFFERENT LOCATION FOR EACH SERVER ******************
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS
	,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF
	,STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION [XE_CPU_Reads_Filter_Trace]
ON SERVER
STATE = START;
GO

-- Stop the session
ALTER EVENT SESSION [XE_CPU_Reads_Filter_Trace]
ON SERVER
STATE = STOP;
GO

--[Execute SQL Task] Error: Executing the query "-- Stop the session
--ALTER EVENT SESSION [XE_CPU_Re..." failed with the following error: "The event session has already been stopped.". Possible failure reasons: 
--Problems with the query, "ResultSet" property not set correctly, parameters not set correctly, or connection not established correctly.
