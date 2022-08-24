
 
-- SPACE USED BY TABLE
begin try 

declare @table_name varchar(500) ; 
declare @schema_name varchar(500) ; 
declare @tab1 table(
        tablename varchar (500) collate database_default
,       schemaname varchar(500) collate database_default
); 
declare  @temp_table table (    
        tablename sysname
,       row_count int
,       reserved varchar(50) collate database_default
,       data varchar(50) collate database_default
,       index_size varchar(50) collate database_default
,       unused varchar(50) collate database_default 
); 

insert into @tab1 
select t1.name
,       t2.name 
from sys.tables t1 
inner join sys.schemas t2 on ( t1.schema_id = t2.schema_id )
order by 1;   

declare c1 cursor for 
select t2.name + '.' + t1.name  
from sys.tables t1 
inner join sys.schemas t2 on ( t1.schema_id = t2.schema_id )
order by 1;   

open c1; 
fetch NEXT from c1 into @table_name;
while @@FETCH_STATUS = 0 
begin  
        set @table_name = replace(@table_name, '[',''); 
        set @table_name = replace(@table_name, ']',''); 

        -- make sure the object exists before calling sp_spacedused
        if exists(SELECT object_id FROM sys.objects WHERE object_id = object_id(@table_name))
        begin
                insert into @temp_table exec sp_spaceused @table_name, false ;
        end
        
        fetch NEXT from c1 into @table_name; 
end; 
close c1; 
deallocate c1; 
select (row_number() over(order by t2.schemaname,t2.tablename))%2 as l1
,		t1.tablename
,       t1.row_count
,       round(convert(float,(convert(float,Substring(t1.reserved,1,PatIndex('% KB%',t1.reserved)))/1024)), 3) as reserved
,       round(convert(float,(convert(float,Substring(t1.data,1,PatIndex('% KB%',t1.data)))/1024)), 3) as data
,       round(convert(float,(convert(float,Substring(t1.index_size,1,PatIndex('% KB%',t1.index_size)))/1024)), 3) as index_size
,       round(convert(float,(convert(float,Substring(t1.unused,1,PatIndex('% KB%',t1.unused)))/1024)), 3) as unused
,       t2.schemaname 
from @temp_table t1 
inner join @tab1 t2 on (t1.tablename = t2.tablename )
order by 4 DESC--schemaname, tablename;
end try 
begin catch 
select -100 as l1
,       ERROR_NUMBER() as tablename
,       ERROR_SEVERITY() as row_count
,       ERROR_STATE() as reserved
,       ERROR_MESSAGE() as data
,       1 as index_size, 1 as unused, 1 as schemaname 
end catch
