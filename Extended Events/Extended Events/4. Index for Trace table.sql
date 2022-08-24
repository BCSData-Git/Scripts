--Need Index on timestamp and duration!

--  Left Join fxDBMonitoring.dbo.montblXE_CPUReadsFilterTrace m On t.[timestamp] = m.[timestamp] and t.duration = m.duration
--Where m.[timestamp] Is Null
--  and m.duration Is Null --seeing dupes, this will help prevent