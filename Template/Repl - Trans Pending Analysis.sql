 
  
 use Maintenance
 go

select polldatetime, pub_dbname, article_name, trans_pending From mnttblTranReplPending with (nolock)
where polldatetime >= '2017-01-24 22:00:31.347' and polldatetime < '2017-01-25 02:00:31.347'
order by 1

select polldatetime, pub_dbname, article_name, trans_pending From mnttblTranReplPending with (nolock)
where polldatetime >= dateadd(minute, -10, getdate()) 
order by 4 desc

--PowerBI 
select polldatetime, pub_dbname, article_name, trans_pending From Maintenance.dbo.mnttblTranReplPending with (nolock)
where polldatetime >= dateadd(hour, -8, GetDAte())--  and polldatetime < '2018-03-19 17:00:09.150'
order by 1 desc