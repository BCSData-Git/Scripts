
exec sp_dropsubscription @publication =  'AspenProd_Pub' 
    ,  @article =  'ShipmentTrackingStatus' 
    , @subscriber =  'all'

exec sp_droparticle @publication = 'AspenProd_Pub'
    , @article = 'ShipmentTrackingStatus'


-- make change
--alter table ShipmentTrackingStatus ...

-- add table (drop & recreate table)
exec sp_addarticle @publication = N'AspenProd_Pub', @article = N'ShipmentTrackingStatus', @source_owner = N'dbo'
	, @source_object = N'ShipmentTrackingStatus', @destination_table = N'ShipmentTrackingStatus', @type = N'logbased', @creation_script = null
	, @description = null, @pre_creation_cmd = N'drop', @schema_option = 0x00000000000000F3, @status = 16
	, @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_ShipmentTrackingStatus', @del_cmd = N'CALL sp_MSdel_ShipmentTrackingStatus'
	, @upd_cmd = N'MCALL sp_MSupd_ShipmentTrackingStatus', @filter = null
	, @sync_object = null, @identityrangemanagementoption = N'none'
GO  
sp_addsubscription @publication = 'AspenProd_Pub'
    , @article = 'ShipmentTrackingStatus'
    , @subscriber = 'VSQLSERVER' 
    , @destination_db = 'AspenProd_Reports' 
    , @sync_type = 'automatic' 
	, @reserved = 'internal' 
GO
--Start Snapshot Agent
--Restart Distribution Agent if stopped

/******************************************************************

	AFEX 

******************************************************************/


-- AFEX
-- drop table 
sp_dropsubscription @publication =  'fxDB6_Pub1' 
    ,  @article =  'OFACtblAddresses' 
    , @subscriber =  'all'
 
sp_droparticle @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'


-- make change
alter table OFACtblAddresses
  add PostalCode nvarchar(50) null

-- add table
exec sp_addarticle @publication = N'fxDB6_Pub1', @article = N'OFACtblAddresses', @source_owner = N'dbo'
	, @source_object = N'OFACtblAddresses', @destination_table = N'OFACtblAddresses', @type = N'logbased', @creation_script = null
	, @description = null, @pre_creation_cmd = N'drop', @schema_option = 0x00000000000000F3, @status = 16
	, @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_OFACtblAddresses', @del_cmd = N'CALL sp_MSdel_OFACtblAddresses', @upd_cmd = N'MCALL sp_MSupd_OFACtblAddresses', @filter = null
	, @sync_object = null, @auto_identity_range = N'false'

GO

-- 
-- 
-- exec sp_scriptpublicationcustomprocs @publication = 'fxDB6_Pub2'
-- GO

sp_addsubscription @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'
    , @subscriber = 'XSRVOPSDB3' 
    , @destination_db = 'fxDB6' 
    , @sync_type = 'automatic' 

GO

sp_addsubscription @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'
    , @subscriber = 'XSRVOPSDB4' 
    , @destination_db = 'fxDB6' 
    , @sync_type = 'automatic' 

GO



/******************************************************************

	MEXICO 

******************************************************************/



-- MEXICO
-- drop table 
sp_dropsubscription @publication =  'fxDB6_Pub1' 
    ,  @article =  'OFACtblAddresses' 
    , @subscriber =  'all'
 
sp_droparticle @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'


-- make change
alter table OFACtblAddresses
  add PostalCode nvarchar(50) null

-- add table
exec sp_addarticle @publication = N'fxDB6_Pub1', @article = N'OFACtblAddresses', @source_owner = N'dbo'
	, @source_object = N'OFACtblAddresses', @destination_table = N'OFACtblAddresses', @type = N'logbased', @creation_script = null
	, @description = null, @pre_creation_cmd = N'drop', @schema_option = 0x00000000000000F3, @status = 16
	, @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_OFACtblAddresses', @del_cmd = N'CALL sp_MSdel_OFACtblAddresses', @upd_cmd = N'MCALL sp_MSupd_OFACtblAddresses', @filter = null
	, @sync_object = null, @auto_identity_range = N'false'

GO

-- 
-- 
-- exec sp_scriptpublicationcustomprocs @publication = 'fxDB6_Pub2'
-- GO

sp_addsubscription @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'
    , @subscriber = 'RIAMEX-II' 
    , @destination_db = 'fxDB6' 
    , @sync_type = 'automatic' 

GO

sp_addsubscription @publication = 'fxDB6_Pub1'
    , @article = 'OFACtblAddresses'
    , @subscriber = 'SRVOPEDB5' 
    , @destination_db = 'fxDB6' 
    , @sync_type = 'automatic' 

GO



/******************************************************************

	SUBSCRIBERS 

******************************************************************/

GRANT SELECT ON OFACtblAddresses TO public
GRANT INSERT ON OFACtblAddresses TO public
GRANT DELETE ON OFACtblAddresses TO public
GRANT UPDATE ON OFACtblAddresses TO public
GRANT SELECT ON OFACtblAddresses TO meAdmin
GRANT DELETE ON OFACtblAddresses TO meAdmin
GRANT SELECT ON OFACtblAddresses TO meOLAgent
GRANT DELETE ON OFACtblAddresses TO meOLAgent