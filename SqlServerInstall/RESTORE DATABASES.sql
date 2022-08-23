 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--USE ASPState
----GO
----ALTER DATABASE ASPState SET RECOVERY FULL WITH NO_WAIT
----GO
----BACKUP DATABASE ASPState TO  DISK = N'\\FILESVR\tempbackup\ASPState.bak' WITH INIT, COMPRESSION, NOUNLOAD, NAME = N'ASPState Full backup',  NOSKIP ,  STATS = 10, NOFORMAT
----GO
--GO
--select ', MOVE N'''+ name + ''' TO N''' + filename + ''''
--from sysfiles

--restore filelistonly from disk =N'\\FILESVR\tempbackup\ASPState.bak'
RESTORE DATABASE ASPState FROM DISK = N'\\US4SQLFE01D\tempbackup\ASPState.bak'
	WITH FILE = 1, NOUNLOAD, STATS = 10, NORECOVERY, REPLACE 
, MOVE N'ASPState' TO N'F:\dbdata\ASPState.mdf'
, MOVE N'ASPState_log' TO N'G:\dblogs\ASPState_log.ldf'

go 