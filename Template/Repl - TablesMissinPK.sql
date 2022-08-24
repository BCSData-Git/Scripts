-- tables missing primary key
select t.table_name 
into #pk
from information_schema.tables t
  left join information_schema.table_constraints tc on t.table_name = tc.table_name 
		and tc.constraint_type = 'PRIMARY KEY'
where t.table_type = 'BASE TABLE'
  and tc.table_name is null
   