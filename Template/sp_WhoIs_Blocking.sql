                                                                                                          
/*

Note: 1st recordset is all spids either blocked or blocking.
      2nd recordset is the spid causing blocking.

-- spid details now returning in resultset 

sp_who2 270

-- command to kill blocking spid
kill 54
 
*/

select spid, blocked
into #blocks
from master.dbo.sysprocesses (nolock)
where blocked <> 0
  and blocked <> spid

-- spids blocked  
select 'spids blocked',spid, blocked, waittime, cmd, hostname, program_name, loginame,
		(SELECT text FROM sys.dm_exec_sql_text(sql_handle)) AS SQLSTATEMENT 
from master.dbo.sysprocesses (nolock) 
where blocked <> 0
  and blocked <> spid


-- blocking spid  
select 'blocking spid',s.spid, s.blocked, s.waittime, s.cmd, s.hostname, s.program_name, s.loginame,
    (SELECT text FROM sys.dm_exec_sql_text(s.sql_handle)) AS SQLSTATEMENT 
from master.dbo.sysprocesses s (nolock) 
  inner join (SELECT b.blocked 
		FROM #blocks b
		  LEFT JOIN #blocks s2 ON b.blocked = s2.spid
		WHERE s2.spid IS NULL) t on s.spid = t.blocked

drop table #blocks




