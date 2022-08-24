Use fxDB6
GO
--Run on the publisher

exec sp_stoppushsubscription_agent
	@publication = 'fxDB6_BE1',
	@subscriber = 'SRVOPEDB8',
	@subscriber_db = 'fxDBRIa_Ops_BE'
GO

exec sp_startpushsubscription_agent
	@publication = 'fxDB6_BE1',
	@subscriber = 'SRVOPEDB8',
	@subscriber_db = 'fxDBRIa_Ops_BE'
GO


--sp_stoppullsubscription_agent
--sp_startpullsubscription_agent