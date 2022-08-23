select count(*), rtrim(loginame) as loginame, program_name, hostname from sysprocesses
group by loginame, program_name, hostname



ALTER LOGIN SedonaServiceUser DISABLE
GO
ALTER LOGIN SedonaUser DISABLE
GO
ALTER LOGIN VishnuUser DISABLE
GO
ALTER LOGIN MappingUser DISABLE
GO
ALTER LOGIN BoomiUser DISABLE
GO
ALTER LOGIN DBAmpUser DISABLE
GO
ALTER LOGIN ganeshaTest DISABLE
GO
ALTER LOGIN SedonaSupport DISABLE
GO 
ALTER LOGIN VividReportsUser DISABLE
GO
ALTER LOGIN [ReadOnly] DISABLE
GO


select 'Kill ' + cast(spid as varchar(100)) + ';' from sysprocesses
where loginame in ('SedonaServiceUser', 'SedonaUser', 'VishnuUser', 'MappingUser')




----------------------------------------------------------------------------------------------------------
Kill 51;
Kill 53;
Kill 63;
Kill 66;
Kill 68;
Kill 73;
Kill 76;
Kill 77;
Kill 87;
Kill 89;
Kill 91;
Kill 93;
Kill 95;
Kill 98;
Kill 99;
Kill 100;
Kill 106;
Kill 111;
Kill 112;
Kill 115;
Kill 119;
Kill 121;
Kill 125;
 