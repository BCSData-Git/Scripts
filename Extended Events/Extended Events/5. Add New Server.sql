USE SSISConfig
GO
--INSERT SERVER 
-- NOte: failing to create for SQL 2008R2 
--INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
--SELECT 10111, 'DEVBEDB1', '\\DEVBEDB1\bks', 'F:\bks', '\\devbedb1\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'
 

--DEVLOGARCH1	F:\bks  SQL 2012 done   \\devlogarch1\bks\Archive
--DEVLOGDB1	F:\bks  SQL 2012  done   \\devlogdb1\bks\Archive
--DEVLOGDB2	F:\bks  SQL 2012  done   \\devlogdb2\bks\Archive

INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
SELECT 10111, 'DEVLOGARCH1', '\\DEVLOGARCH1\bks', 'F:\bks', '\\DEVLOGARCH1\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'

INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
SELECT 10112, 'DEVLOGDB1', '\\DEVLOGDB1\bks', 'F:\bks', '\\DEVLOGDB1\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'

INSERT INTO ssistblXECPUReadsFilterControlTable ( fID, fServerName, fFolderShareName, fFolderFQPN, fArchiveFolderFQPN, fFileName)
SELECT 10113, 'DEVLOGDB2', '\\DEVLOGDB2\bks', 'F:\bks', '\\DEVLOGDB2\bks\Archive', 'XE_CPU_Reads_Filter_Trace.xel'

