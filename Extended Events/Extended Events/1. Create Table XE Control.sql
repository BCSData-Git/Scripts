
--Control table on SSIS
USE SSISConfig
GO
 --DROP TABLE ssistblXECPUReadsFilterControlTable 
--GO
CREATE TABLE ssistblXECPUReadsFilterControlTable (fID int not null primary key, fServerName varchar(100)
	, fFolderShareName varchar(1000), fFolderFQPN varchar(1000), fArchiveFolderFQPN varchar(1000), fFileName varchar(100) )

INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
SELECT 10011, 'BPDEVMAINDB', '\\BPDEVMAINDB\bks', 'L:\bks', '\\BPDEVMAINDB\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'

SELECT * FROM ssistblXECPUReadsFilterControlTable

--SELECT Distinct fServerName FROM ssistblXECPUReadsFilterControlTable with (Nolock)

--SELECT  fFolderShareName + '\' + fFileName As FilePathAndName, fArchiveFolderFQPN, fFolderShareName
--FROM ssistblXECPUReadsFilterControlTable WITH (NOLOCK)
--WHERE fServerName = ?

--\\BPDEVMAINDB\bks\Archive
 
 /*
--INSERT SERVER 
INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
SELECT 10111, 'DEVBEDB1', '\\DEVBEDB1\bks', 'F:\bks', '\\devbedb1\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'

*/