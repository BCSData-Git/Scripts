
USE master
GO

GRANT CONNECT ANY DATABASE TO [dbUser];
GRANT VIEW ANY DEFINITION TO [dbUser];
GRANT VIEW ANY DATABASE TO [dbUser];
GRANT SELECT ALL USER SECURABLES TO [dbUser];
GRANT VIEW SERVER STATE TO [dbUser];
GRANT SHOWPLAN TO [dbUser];
GRANT ALTER TRACE TO [dbUser];
EXECUTE sys.sp_addrolemember [SQLAgentReaderRole], [dbUser];
EXECUTE sys.sp_addrolemember [SQLAgentOperatorRole], [dbUser];
GRANT EXECUTE ON xp_logininfo TO [dbUser];

