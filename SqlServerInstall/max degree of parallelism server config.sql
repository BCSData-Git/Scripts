
-- max degree of parallelism 
--https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-degree-of-parallelism-server-configuration-option?view=sql-server-ver15
 --Starting with SQL Server 2016 (13.x), use the following guidelines when you configure the max degree of parallelism server configuration value:
--Table 1


--Guidelines 
--Starting with SQL Server 2016 (13.x), 

--Server with single NUMA node
--Less than or equal to 8 logical processors
--Keep MAXDOP at or below # of logical processors

--Server with single NUMA node
--Greater than 8 logical processors
--Keep MAXDOP at 8

--Server with multiple NUMA nodes
--Less than or equal to 16 logical processors per NUMA node
--Keep MAXDOP at or below # of logical processors per NUMA node

--Server with multiple NUMA nodes
--Greater than 16 logical processors per NUMA node
--Keep MAXDOP at half the number of logical processors per NUMA node with a MAX value of 16


--USE AdventureWorks2012 ;  --odd in microsoft doc the user db is chosen
--GO   
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO  
EXEC sp_configure 'max degree of parallelism', 4;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO  

SELECT name, description, is_advanced  ,value_in_use
FROM sys.configurations
Where name in (  'max degree of parallelism') ;
--Where name in ('clr enabled', 'cost threshold for parallelism','optimize for ad hoc workloads', 'max text repl size (B)', 'max degree of parallelism') ;
