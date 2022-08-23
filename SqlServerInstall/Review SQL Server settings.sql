 
 SELECT name, description, is_advanced  ,value_in_use
FROM sys.configurations
Where name in ('max server memory (MB)', 'min server memory (MB)', 'max degree of parallelism'
, 'cost threshold for parallelism', 'backup compression default', 'remote admin connections'
, 'Ad Hoc Distributed Queries')
 