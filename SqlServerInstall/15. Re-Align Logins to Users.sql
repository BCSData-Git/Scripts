 
GO
 
--USE [ReportServer]
--GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--exec sp_change_users_login 'UPDATE_ONE','INFORMATION_SCHEMA','INFORMATION_SCHEMA'
--exec sp_change_users_login 'UPDATE_ONE','sys','sys'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

--GO
 
--USE [ReportServerTempDB]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [ACA_Final]
GO
 
exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
exec sp_change_users_login 'UPDATE_ONE','VividReportsUser','VividReportsUser'
exec sp_change_users_login 'UPDATE_ONE','SQLLink','SQLLink'
exec sp_change_users_login 'UPDATE_ONE','Ish.Fuseini','Ish.Fuseini'
exec sp_change_users_login 'UPDATE_ONE','BoomiUser','BoomiUser'
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','staylor2','staylor2'
exec sp_change_users_login 'UPDATE_ONE','SedonaSupport','SedonaSupport'
exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'
exec sp_change_users_login 'UPDATE_ONE','carlos.colon','carlos.colon'
exec sp_change_users_login 'UPDATE_ONE','VishnuUser','VishnuUser'

GO
 
--USE [C3_Sandbox]
--GO 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
--exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
--exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [Maintenance]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [MasterSetupAstute]
GO
 
exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','BoomiUser','BoomiUser'

GO
 
--USE [Sandbox_20210203]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
--exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
--exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
--exec sp_change_users_login 'UPDATE_ONE','VividReportsUser','VividReportsUser'
--exec sp_change_users_login 'UPDATE_ONE','SQLLink','SQLLink'
--exec sp_change_users_login 'UPDATE_ONE','Ish.Fuseini','Ish.Fuseini'
--exec sp_change_users_login 'UPDATE_ONE','BoomiUser','BoomiUser'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
--exec sp_change_users_login 'UPDATE_ONE','staylor2','staylor2'
--exec sp_change_users_login 'UPDATE_ONE','SedonaSupport','SedonaSupport'
--exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'
--exec sp_change_users_login 'UPDATE_ONE','carlos.colon','carlos.colon'
--exec sp_change_users_login 'UPDATE_ONE','VishnuUser','VishnuUser'

GO
 
--USE [SandboxTest]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
--exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
--exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
--exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'

GO
 
USE [SedonaDocuments]
GO
 
exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [SedonaMaster]
GO
 
exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
--USE [TestDB]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

--GO
 
USE [Sedona_Support]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','SedonaSupport','SedonaSupport'

GO
 
--USE [TaxDemo_Sandbox]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
--exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
--exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
--exec sp_change_users_login 'UPDATE_ONE','VividReportsUser','VividReportsUser'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
--exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'

--GO
 
USE [VIVIDREPORTS-SEDONA]
GO
 
exec sp_change_users_login 'UPDATE_ONE','VividReportsUser','VividReportsUser'
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [AtlasReports]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','GaneshaTest','GaneshaTest'
exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'

GO
 
USE [ACA_Final_Archive]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
USE [ScanConversion]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'

GO
 
--USE [Archive_20210611]
--GO
 
--exec sp_change_users_login 'UPDATE_ONE','SedonaReports','SedonaReports'
--exec sp_change_users_login 'UPDATE_ONE','SedonaUser','SedonaUser'
--exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
--exec sp_change_users_login 'UPDATE_ONE','SedonaServiceUser','SedonaServiceUser'
--exec sp_change_users_login 'UPDATE_ONE','ReadOnly','ReadOnly'
--exec sp_change_users_login 'UPDATE_ONE','VividReportsUser','VividReportsUser'
--exec sp_change_users_login 'UPDATE_ONE','SQLLink','SQLLink'
--exec sp_change_users_login 'UPDATE_ONE','Ish.Fuseini','Ish.Fuseini'
--exec sp_change_users_login 'UPDATE_ONE','BoomiUser','BoomiUser'
--exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
--exec sp_change_users_login 'UPDATE_ONE','staylor2','staylor2'
--exec sp_change_users_login 'UPDATE_ONE','SedonaSupport','SedonaSupport'
--exec sp_change_users_login 'UPDATE_ONE','MGraening','MGraening'
--exec sp_change_users_login 'UPDATE_ONE','carlos.colon','carlos.colon'
--exec sp_change_users_login 'UPDATE_ONE','VishnuUser','VishnuUser'

GO
 
USE [Salesforce]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'
exec sp_change_users_login 'UPDATE_ONE','Readonly','Readonly'
exec sp_change_users_login 'UPDATE_ONE','BoomiUser','BoomiUser'
exec sp_change_users_login 'UPDATE_ONE','ganeshaTest','ganeshaTest'
exec sp_change_users_login 'UPDATE_ONE','DBAmpUser','DBAmpUser'
exec sp_change_users_login 'UPDATE_ONE','carlos.colon','carlos.colon'
exec sp_change_users_login 'UPDATE_ONE','VishnuUser','VishnuUser'

GO
 
USE [DataTransformations]
GO
 
exec sp_change_users_login 'UPDATE_ONE','readonlyall','readonlyall'

GO
 
