use AspenProd
go

--1) Drop subscriptions
exec sp_dropsubscription @publication =  'AspenProd_Pub' 
    ,  @article =  'RetentionAccountStatusReason' 
    , @subscriber =  'all' --Note we have 2 subscribers, VSQLSERVER & VSTAGINGSERVER
 
--2) Drop article (table) from replication
exec sp_droparticle @publication = 'AspenProd_Pub'
    , @article = 'RetentionAccountStatusReason'

--3) Deploy DDL changes, ie Alter Table, Alter Column, Drop table, Truncate Table etc - non-logged commands not supported when table in repl

--4) Add table back to replciation
exec sp_addarticle @publication = N'AspenProd_Pub', @article = N'RetentionAccountStatusReason', @source_owner = N'dbo', @source_object = N'RetentionAccountStatusReason'
, @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000480350DF
, @identityrangemanagementoption = N'manual', @destination_table = N'RetentionAccountStatusReason', @destination_owner = N'dbo', @status = 24
, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboRetentionAccountStatusReason]', @del_cmd = N'CALL [sp_MSdel_dboRetentionAccountStatusReason]'
, @upd_cmd = N'SCALL [sp_MSupd_dboRetentionAccountStatusReason]'
GO  

--5) Add subscriptions individually
exec sp_addsubscription @publication = 'AspenProd_Pub'
    , @article = 'RetentionAccountStatusReason'
    , @subscriber = 'VSQLSERVER' 
    , @destination_db = 'AspenProd_Reports' 
    , @sync_type = 'automatic' 
	, @reserved = 'internal' 
GO
exec sp_addsubscription @publication = 'AspenProd_Pub'
    , @article = 'RetentionAccountStatusReason'
    , @subscriber = 'VSTAGINGSERVER' 
    , @destination_db = 'AspenProd_Reports' 
    , @sync_type = 'automatic' 
	, @reserved = 'internal' 
GO 
 exec sp_addsubscription @publication = 'AspenProd_Pub'
    , @article = 'RetentionAccountStatusReason'
    , @subscriber = 'VREPORTSERVER' 
    , @destination_db = 'AspenProd_Reports' 
    , @sync_type = 'automatic' 
	, @reserved = 'internal' 
GO
  
--6) STart snapshot agent at very end, will reinitialize table to subscriber, ie Drop, Create, BCP data
 exec sp_startpublication_snapshot @publication =  'AspenProd_Pub'   
  


  
use [Residual_2019]
go
--[Residual_2019].[dbo].[CapitalAssignmentBatch]
exec sp_addarticle @publication = N'Residual_2019_Pub', @article = N'CapitalAssignmentBatch', @source_owner = N'dbo', @source_object = N'CapitalAssignmentBatch'
, @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000480350DF
, @identityrangemanagementoption = N'manual', @destination_table = N'CapitalAssignmentBatch', @destination_owner = N'dbo', @status = 24
, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCapitalAssignmentBatch]', @del_cmd = N'CALL [sp_MSdel_dboCapitalAssignmentBatch]'
, @upd_cmd = N'SCALL [sp_MSupd_dboCapitalAssignmentBatch]'
GO   
 exec sp_addsubscription @publication = 'Residual_2019_Pub'
    , @article = 'CapitalAssignmentBatch'
    , @subscriber = 'VREPORTSERVER' 
    , @destination_db = 'Residual_2019_ReadOnly' 
    , @sync_type = 'automatic' 
	, @reserved = 'internal' 
GO


 
 
 exec sp_scriptpublicationcustomprocs @publication = 'AspenProd_Pub'
 GO
  
   