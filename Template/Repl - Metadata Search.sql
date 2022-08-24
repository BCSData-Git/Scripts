--Collect SQL Server Replication Metadata

 

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

       ([PublisherName] [varchar](100) NULL, [PublicationName] [varchar](100) NULL, [DatabasePublished] [varchar](100) NULL, [ArticleName] [varchar](100) NULL,

              [SubscriberName] [varchar](100) NULL, [DatabaseSubscribed] [varchar](100) NULL, [ArticleDestinationName] [varchar](100) NULL) ;

 

Create Table #temp_DatabasesinReplication ([fDatabaseID] int identity, [fDatabaseName] varchar(50));

 

Create Table #temp_SQLToProcess ([fID] int identity, [fSQLCommand] varchar(8000));

 

Insert into #temp_DatabasesinReplication (fDatabaseName)

Select name

from sys.databases where is_published = 1 and [state] = 0

order by name;

 

Insert into #temp_SQLToProcess (fSQLCommand)

Select 'Use ' + QUOTENAME(fDatabaseName) + '

Insert into #temp_TablesInReplication (PublisherName, PublicationName, DatabasePublished, ArticleName, SubscriberName, DatabaseSubscribed, ArticleDestinationName)

Select @@ServerName, a.name, db_Name() as DatabasePublished, b.name, c.srvname, c.dest_db, isnull(b.dest_table,'''')

from syspublications a

left join sysarticles b on a.pubid = b.pubid

left join syssubscriptions c on b.artid = c.artid

order by a.pubid;'

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