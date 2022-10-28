USE [Maintenance]
GO
/****** Object:  StoredProcedure [dbo].[mnt_sp_Purge_mntblSQLExceptionLog_Detail_Consol]    Script Date: 10/11/2022 3:13:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ross Becker
-- Create date: 10/12/2022 
-- Description:	Purge table data for mntblSQLExceptionLog_Detail_Consol
--
-- Sample:  Exec mnt_sp_Purge_mntblSQLExceptionLog_Detail_Consol @retentionDays = 15 --(15 days testing only)
-- =============================================

CREATE PROC [dbo].[mnt_sp_Purge_mntblSQLExceptionLog_Detail_Consol]

	@retentionDays smallint = 90

AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	  
	--select top 100 * from mntblSQLExceptionLog_Detail_Consol
	--SP_HELP mntblSQLExceptionLog_Detail_Consol
	--SP_HELPINDEX mntblSQLExceptionLog_Detail_Consol
	 
	 	--declare @retentionDays smallint = 15

	 -- drop table #ToDel
	CREATE TABLE #ToDelAll (ConsolId bigint)
	CREATE TABLE #ToDelBatch (ConsolId bigint)

	Insert Into #ToDelAll (ConsolId)
	SELECT ConsolId   
	FROM mntblSQLExceptionLog_Detail_Consol with (nolock)
	WHERE [ErrorTime] < GETDATE() -@retentionDays

	--SELECT COUNT(*) FROM #ToDelAll
	--DECLARE @retentionDays smallint = 90
	--SELECT GETUTCDATE()  -@retentionDays

	--SELECT GETDATE()
	--SELECT GETUTCDATE() 
	--2022-09-22 17:09:00.403 --local servertime = CT  (PT, MT(1hr), CT(2hr), ET(3hr))
	--2022-09-22 22:09:00.403 -- 5hrs (CT or 7hrs PT) UTC, GMT-7

	Declare @c Int = 1000
	 
	WHILE @c >= 0
	BEGIN --Loop

		--Reset batch table
		Truncate Table #ToDelBatch

		--Load batch w/ IDs to del
		Insert Into #ToDelBatch (ConsolId)
		Select TOP (5000) a.ConsolId 
		From #ToDelAll a
			--Join mntblSQLExceptionLog_Detail_Consol c with (nolock) on a.ConsolId = c.ConsolId

		--Delete batch from prod table 
		Delete c
		From #ToDelBatch b 
			Join mntblSQLExceptionLog_Detail_Consol c On b.ConsolId = c.ConsolId 
			 
		--@@ROWCOUNT returns rows affected, if 0 deleted then exit
		Select @c = @@ROWCOUNT
		If @c = 0
		BEGIN
			GOTO PROC_EXIT
		END

		/*Delete from All temp table for perf*/
		Delete a
		From #ToDelAll a
		  Join #ToDelBatch b On a.ConsolId = b.ConsolId 

		Set @c = @c -1

		WAITFOR DELAY '00:00:05'

	END --Loop

PROC_EXIT:

	drop table #ToDelAll
	drop table #ToDelBatch

END
GO