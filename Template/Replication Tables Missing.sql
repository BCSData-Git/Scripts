
 
--Collect Tables Missing in Replication Pub
SET NOCOUNT ON;
 
If OBJECT_ID('tempdb..#temp_DatabasesinReplication') IS NOT NULL 
Begin 
       Drop Table #temp_DatabasesinReplication 
End;
 
If OBJECT_ID('tempdb..#temp_TablesInReplication') IS NOT NULL 
Begin 
       Drop Table #temp_TablesInReplication 
End;
 
If OBJECT_ID('tempdb..#temp_SQLToProcess') IS NOT NULL 
Begin 
       Drop Table #temp_SQLToProcess 
End;
 
Create Table #temp_TablesInReplication 
       (ServerName varchar(100), SchemaName varchar(50), TableName [varchar](100) NULL, [DatabasePublished] [varchar](100) NULL, ArticleName varchar(100) ) ;
			   
Create Table #temp_DatabasesinReplication ([fDatabaseID] int identity, [fDatabaseName] varchar(50)); 
Create Table #temp_SQLToProcess ([fID] int identity, [fSQLCommand] varchar(8000));
 
Insert into #temp_DatabasesinReplication (fDatabaseName) 
Select name 
from sys.databases where is_published = 1 and [state] = 0 
order by name;
 
Insert into #temp_SQLToProcess (fSQLCommand) 
Select 'Use ' + QUOTENAME(fDatabaseName) + ' 
Insert into #temp_TablesInReplication (ServerName, SchemaName, TableName, DatabasePublished, ArticleName )
Select @@ServerName, s.name as schemaname, t.name as tablename, db_Name() as DatabasePublished, a.name As [ArticleName]  
from sys.tables t
	join sys.schemas s on t.schema_id = s.schema_id
	left join sysarticles a on a.name = t.name
	left join syssubscriptions c on a.artid = c.artid 
Where (a.name is null or c.artid is null)
  And t.name not in (''sysarticles'',
''sysarticlecolumns'',
''sysschemaarticles'',
''syspublications'',
''syssubscriptions'',
''sysarticleupdates'',
''MSpub_identity_range'',
''systranschemas'',
''MSpeer_lsns'',
''MSpeer_request'',
''MSpeer_response'',
''MSpeer_topologyrequest'',
''MSpeer_topologyresponse'',
''MSpeer_originatorid_history'',
''MSpeer_conflictdetectionconfigrequest'',
''MSpeer_conflictdetectionconfigresponse'',
''sysreplservers'') ;' 
from #temp_DatabasesinReplication;
 
Declare @I int 
Declare @Rec_Cnt int 
Declare @SQLCommand varchar(8000) 
Set @I = 1; 
Set @Rec_Cnt = (Select count(1) from #temp_SQLToProcess); 
While @I <= @Rec_Cnt 
Begin 
       Select @SQLCommand = fSQLCommand from #temp_SQLToProcess where fID = @I; 
       Execute (@SQLCommand); 
       Set @I = @I + 1; 
End;

select * From #temp_TablesInReplication order by 2, 3
 
  