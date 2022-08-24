USE DataTransformations
go
select * from sys.tables order by create_date desc

 --LASQLMAINDB_TablesInRepl04102022
select * from DataTransformations.dbo.LASQLMAINDB_TablesInRepl04102022 where PublicationName like '%bidi%' 

--1) get list of subscribers to expclude
select distinct SubscriberName from LASQLMAINDB_TablesInRepl04102022
order by 1
 
   
 
NULL
KCSQLREPDB
KSSQLMAINDB
LASQLBEDB
LASQLFEDB
LASQLMAINDB
MYDBAAG03
SQLIMG_LS01P
SRVACTDB
SRVLOGDB
SRVRHO2
US0SQLRO01P
US0SQLRO02P
US0SQLRO03P
US0SQLRO04P
US0SQLRO05P
US0SQLRO06P
US0SQLRO07P
US0SQLRO08P
US4SQLDW01P
  

Drop Table #PubsSubs

select distinct DatabasePublished, publicationName, SubscriberName, DatabaseSubscribed
Into #PubsSubs
from LASQLMAINDB_TablesInRepl04102022
where SubscriberName not in ('CH1SQL01D', 'KCSQLREPDB', 'SRVLOGDB4', 'KSSQLMAINDB', 'US0SQLRO02P', 'US0SQLRO03P', 'US0SQLRO04P'
, 'US0SQLRO05P', 'US0SQLRO06P', 'US0SQLRO07P', 'US0SQLRO08P',   'MYDBAAG03', 'TR1SQL001X'
, 'NULL', 'MY0RPS001A')
  and PublicationName Not like '%P2P%'
  and SubscriberName is not null
  and DatabaseSubscribed not in ('virtual')

Select * from #PubsSubs

Select Distinct DatabasePublished, publicationName From #PubsSubs
Order by 1, 2


--******************************************************************************************************************
--					CREATE PUBLICATION
--******************************************************************************************************************

-- Enabling the replication database
select Distinct 'use master;exec sp_replicationdboption @dbname = N''' + DatabasePublished + ''', @optname = N''publish'', @value = N''true''
GO 
exec [' + DatabasePublished + '].sys.sp_addlogreader_agent @job_login = null, @job_password = null, @publisher_security_mode = 1
GO 
use [' + DatabasePublished + '];
exec sp_addpublication @publication = N''' + publicationName + '''
, @description = N''Transactional publication of database ''''' + DatabasePublished + ''''' from Publisher ''''US4SQLMAIN01S''''.''
, @sync_method = N''concurrent'', @retention = 0, @allow_push = N''true'', @allow_pull = N''true'', @allow_anonymous = N''false'', @enabled_for_internet = N''false''
, @snapshot_in_defaultfolder = N''true'', @compress_snapshot = N''false'', @ftp_port = 21, @ftp_login = N''anonymous'', @allow_subscription_copy = N''false''
, @add_to_active_directory = N''false'', @repl_freq = N''continuous'', @status = N''active'', @independent_agent = N''true'', @immediate_sync = N''false''
, @allow_sync_tran = N''false'', @autogen_sync_procs = N''false'', @allow_queued_tran = N''false'', @allow_dts = N''false'', @replicate_ddl = 1
, @allow_initialize_from_backup = N''true'', @enabled_for_p2p = N''false'', @enabled_for_het_sub = N''false''
GO
exec sp_addpublication_snapshot @publication = N''' + publicationName + ''', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0
, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959
, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''sa''
GO  
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''NT SERVICE\SQLWriter''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''NT SERVICE\Winmgmt''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''NT SERVICE\MSSQLSERVER''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''NT SERVICE\SQLSERVERAGENT''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''RIADEV\administrator''
GO    
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''RIADEV\sqlage''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''RIADEV\sqlsvc''
GO
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''RIADEV\DBA''
GO   
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''RIADEV\DevArchitects''
GO 
exec sp_grant_publication_access @publication = N''' + publicationName + ''', @login = N''distributor_admin''
GO


'
From #PubsSubs
--Order by DatabasePublished, publicationName



--******************************************************************************************************************
--					ADD ARTICLES
--******************************************************************************************************************
  
 --TODO 
 --ADD IDENTITY LOGIC 
 --ADD SCHEMA FOR FXDB6_CONSUMER
Drop table #PubsSubsArticles

select distinct DatabasePublished, PublicationName, ArticleName, SubscriberName, DatabaseSubscribed
Into #PubsSubsArticles
from LASQLMAINDB_TablesInRepl04102022
where  ArticleName not in ('montblReplicationPub_Token', 'montblReplicationPub_BIDI_Token')
and SubscriberName not in ('CH1SQL01D', 'KCSQLREPDB', 'SRVLOGDB4', 'KSSQLMAINDB', 'US0SQLRO02P', 'US0SQLRO03P', 'US0SQLRO04P'
, 'US0SQLRO05P', 'US0SQLRO06P', 'US0SQLRO07P', 'US0SQLRO08P',   'MYDBAAG03', 'TR1SQL001X'
, 'NULL', 'MY0RPS001A')
  and PublicationName Not like '%P2P%'
  and SubscriberName is not null
  and DatabaseSubscribed not in ('virtual')
 
Select Distinct 'USE ' + DatabasePublished + '; exec sp_addarticle @publication = N''' + PublicationName + ''', @article = N''' + ArticleName + ''', @source_owner = N''dbo''
	, @source_object = N''' + ArticleName + ''', @type = N''logbased'', @description = N'''', @creation_script = N''''
	, @pre_creation_cmd = N''drop'', @schema_option = 0x00000000484358DF, @identityrangemanagementoption = N''none''
	, @destination_table = N''' + ArticleName + ''', @destination_owner = N''dbo'', @status = 24
	, @vertical_partition = N''false'', @ins_cmd = N''CALL [sp_MSins_dbo' + ArticleName + ']''
	, @del_cmd = N''CALL [sp_MSdel_dbo' + ArticleName + ']'', @upd_cmd = N''SCALL [sp_MSupd_dbo' + ArticleName + ']''
GO 
'
From #PubsSubsArticles
Order by 1 --, PublicationName, ArticleName





--******************************************************************************************************************
--					ADD SUBSCRIPTIONS
--******************************************************************************************************************

--TODO ADD LOOPBACK DETECTION = TRUE  FOR BIDI
--, @loopback_detection = N'true' 

select distinct subscribername from #PubsSubsArticles
delete from #PubsSubsArticles where subscribername = 'US4SQLBE05P'

 LASQLMAINDB
SRVGAMMA2
SRVLOGDB

--SQLIMG_LS01P
SRVACTDB
--SRVRHO2
--LASQLMAINDB
--US4SQLDW01P
--SRVLOGDB
--LASQLBEDB
--US0SQLRO01P
--LASQLFEDB

Update #PubsSubsArticles Set SubscriberName = 'US4SQLBE01S' Where SubscriberName = 'LASQLBEDB'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLFE01S' Where SubscriberName = 'LASQLFEDB'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLMAIN01S' Where SubscriberName = 'LASQLMAINDB'
Update #PubsSubsArticles Set SubscriberName = 'US4IMG_LS01S' Where SubscriberName = 'SQLIMG_LS01P'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLMAIN01S' Where SubscriberName = 'SRVGAMMA2'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLRO01S' Where SubscriberName = 'US0SQLRO01P'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLDW01S' Where SubscriberName = 'US4SQLDW01P'

Update #PubsSubsArticles Set SubscriberName = 'US4SQLACMAIN01S' Where SubscriberName = 'SRVRHO2'
Update #PubsSubsArticles Set SubscriberName = 'US4SQLLOG01S' Where SubscriberName = 'SRVLOGDB'
 
 
 
  

   
   DELETE FROM #PubsSubsArticles WHERE DatabaseSubscribed = 'virtual'

SELECT distinct SubscriberName, DatabaseSubscribed FROM #PubsSubsArticles order by 1


Select 'USE ' + DatabasePublished + '; exec sp_addsubscription @publication = ''' + PublicationName + ''', @article = ''' + ArticleName + ''', @subscriber = ''' + SubscriberName + '''
, @destination_db = ''' + DatabaseSubscribed + ''', @sync_type = ''replication support only'', @reserved=''internal''  
GO
'
From #PubsSubsArticles  
Where PublicationName NOT like '%BIDI%'
 order by DatabasePublished, PublicationName, ArticleName, DatabaseSubscribed

Select 'USE ' + DatabasePublished + '; exec sp_addsubscription @publication = ''' + PublicationName + ''', @article = ''' + ArticleName + ''', @subscriber = ''' + SubscriberName + '''
, @destination_db = ''' + DatabaseSubscribed + ''', @sync_type = ''replication support only'', @reserved=''internal'' 
, @loopback_detection = N''true''
GO
'
From #PubsSubsArticles  
Where PublicationName like '%BIDI%'
 order by DatabasePublished, PublicationName, ArticleName, DatabaseSubscribed

 