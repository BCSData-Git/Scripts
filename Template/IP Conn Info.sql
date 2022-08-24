select distinct local_net_address   FROM sys.dm_exec_connections
where local_net_address like '%117%'

select *   FROM sys.dm_exec_connections
where client_net_address = '10.5.10.117'
--10.5.10.117

select * from master..sysprocesses where spid = 161