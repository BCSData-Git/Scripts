/*
	Script name: Purge SSIS Catalog log tables
	Author: Tim Mitchell (www.TimMitchell.net)
	Date: 12/19/2018
	Purpose: This script will remove most of the operational information from the SSIS catalog. The 
				internal.operations and internal.executions tables, as well as their dependencies, 
				will be purged of all data with an operation created_time value older than the number
				of days specified in the RETENTION_WINDOW setting of the SSIS catalog.
				
		Note that this script was created using SQL Server 2017 (14.0.3048.4). Depending on the SQL Server
				version, the table and/or column names may be different.
	3/22/2022 CB Modified to smaller batches, not rollback everything, run in job after-hours every 1 minute

*/
USE SSISDB
GO


	/*
		If purge is disabled or the retention period is not greater than 0, skip the remaining tasks
	  by turning on NOEXEC.
	*/

	--IF NOT (@enable_purge = 1 AND @retention_period_days > 0)
	--  SET NOEXEC ON 


DECLARE @c INT = 100000

DECLARE @enable_purge BIT 
DECLARE @retention_period_days SMALLINT


IF (OBJECT_ID('tempdb..#executions') IS NOT NULL)
	DROP TABLE #executions

CREATE TABLE #executions (execution_id bigint)

/*
	Query the SSIS catalog database for the retention settings
*/

SELECT @enable_purge = CONVERT(bit, property_value) 
FROM [catalog].[catalog_properties]
WHERE property_name = 'OPERATION_CLEANUP_ENABLED'
        
SELECT @retention_period_days = CONVERT(int, property_value)  
FROM [catalog].[catalog_properties]
WHERE property_name = 'RETENTION_WINDOW'

select @enable_purge, @retention_period_days

While @c > 0 
BEGIN
	--print @c
	--SET NOCOUNT ON

	Truncate Table #executions


	/*
		Get the working list of execution IDs. This will be the list of IDs we use for the
		delete operation for each table.
	*/

	INSERT Into #executions (execution_id)
	SELECT TOP 10000 execution_id 
	FROM catalog.executions --view
	WHERE CAST(created_time AS DATETIME) < DATEADD(DAY, 0 - @retention_period_days, GETDATE())


	--SELECT COUNT(*)
	--FROM catalog.executions 
	--WHERE CAST(created_time AS DATETIME) < DATEADD(DAY, 0 - @retention_period_days, GETDATE())

	--[internal].[executions]

	--SELECT COUNT(*)
	--FROM [internal].[executions] e 
	--INNER JOIN [internal].[operations] o  ON e.[execution_id]= o.[operation_id] 
	--WHERE CAST(created_time AS DATETIME) < DATEADD(DAY, 0 - @retention_period_days, GETDATE())

	--SELECT COUNT(*)
	--FROM [internal].[executions] e 
	--	INNER JOIN [internal].[operations] o  ON e.[execution_id]= o.[operation_id] 
	--WHERE CAST(created_time AS DATETIME) < DATEADD(DAY, 0 - @retention_period_days, GETDATE())



	/***************************************************
		internal.executions and its dependencies
	***************************************************/

	DELETE tgt
	FROM internal.event_message_context tgt
		INNER JOIN internal.event_messages em ON em.event_message_id = tgt.event_message_id
		INNER JOIN #executions ee ON ee.execution_id = em.operation_id
		--(1,171,652 rows affected)

	--/*
	--	internal.event_messages
	--*/
	DELETE tgt
	FROM internal.event_messages tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.operation_id
		 --(228686 rows affected)
 
	--/*
	--	internal.executable_statistics
	--*/
	DELETE tgt
	FROM internal.executable_statistics tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
	 --(19992 rows affected)

	/*
		internal.execution_data_statistics is one of the larger tables. Break up the delete to avoid
		log size explosion.
	*/
 
	DELETE tgt
	FROM internal.execution_data_statistics tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
		--(0 rows affected)
 



	/*
		internal.execution_component_phases is one of the larger tables. Break up the delete to avoid
		log size explosion.
	*/ 
	DELETE tgt 
	FROM internal.execution_component_phases tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
			--(0 rows affected)



	/*
		internal.execution_data_taps
	*/
	DELETE tgt
	FROM internal.execution_data_taps tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
		--(0 rows affected)

   
	/*
		internal.execution_parameter_values is one of the larger tables. Break up the delete to avoid
		log size explosion.
	*/ 
	DELETE tgt
	FROM internal.execution_parameter_values tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
	 --(420000 rows affected)


	/*
		internal.execution_property_override_values
	*/
	DELETE tgt
	FROM internal.execution_property_override_values tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
		--(0 rows affected)
 

	--moved to end executions


	/***************************************************
		internal.operations and its dependencies
	***************************************************/ 
	/*
		internal.operation_messages
	*/
	DELETE tgt
	FROM internal.operation_messages tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.operation_id
		--(228686 rows affected)
 

	/*
		internal.extended_operation_info
	*/
	DELETE tgt
	FROM internal.extended_operation_info tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.operation_id
	 --(0 rows affected)


	/*
		internal.operation_os_sys_info
	*/
	DELETE tgt
	FROM internal.operation_os_sys_info tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.operation_id
	 --(10000 rows affected)


	/*
		internal.validations
	*/
	DELETE tgt
	FROM internal.validations tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.validation_id
	 --(0 rows affected)

	/*
		internal.operation_permissions
	*/
	DELETE tgt
	FROM internal.operation_permissions tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.[object_id]
		--(30000 rows affected)
 

	/*
		internal.operations
	*/
	DELETE tgt
	FROM internal.operations tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.operation_id AND tgt.start_time IS NOT NULL
	 --(10000 rows affected)
  

	/*
		internal.executions
	*/
	DELETE tgt
	FROM internal.executions tgt
		INNER JOIN #executions ee ON ee.execution_id = tgt.execution_id
	--(10000 rows affected)
 
  SET @c = @c - 1

END
