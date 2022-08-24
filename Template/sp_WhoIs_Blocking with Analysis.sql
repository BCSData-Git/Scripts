--Blocking Analysis 
--1) run query to get fLogID value. Search around timeout window. 
--2) higher the blocked processes count, the more users/spids involved
select fLogedTime, fLogID, count(1) blk_processes_cnt
from Maintenance.dbo.mnttbl_sp_who2_log
where fLogedTime >= '2021-11-30 09:30:00' 
and  fLogedTime <  '2021-11-30 11:30:00' 
group by fLogedTime, fLogID
order by fLogedTime desc


--3) From query above, use fLogID in both below statements
SELECT * FROM Maintenance.dbo.mnttbl_sp_who2_log WHERE fLogID = '4ADFFBD6-45EB-4AB2-B80E-BAE649EDABDA' AND spid_desc = 'spids blocked'
SELECT * FROM Maintenance.dbo.mnttbl_sp_who2_log WHERE fLogID = '4ADFFBD6-45EB-4AB2-B80E-BAE649EDABDA' AND spid_desc = 'blocking spid'

SELECT * FROM Maintenance.dbo.mnttbl_sp_who2_log WHERE fLogID = '7D67FB44-1C08-4542-95E4-8C56EAFD089D' AND spid_desc = 'spids blocked'
SELECT * FROM Maintenance.dbo.mnttbl_sp_who2_log WHERE fLogID = '7D67FB44-1C08-4542-95E4-8C56EAFD089D' AND spid_desc = 'blocking spid'



  