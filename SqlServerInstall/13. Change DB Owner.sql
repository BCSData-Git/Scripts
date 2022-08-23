
--select 'USE ' + name + '; EXEC sp_changedbowner ''sa'';'   from sysdatabases order by 1

USE ACA_Final; EXEC sp_changedbowner 'sa';
USE AtlasReports; EXEC sp_changedbowner 'sa';
USE Maintenance; EXEC sp_changedbowner 'sa'; 
USE MasterSetupAstute; EXEC sp_changedbowner 'sa'; 
--USE ReportServer; EXEC sp_changedbowner 'sa';
--USE ReportServerTempDB; EXEC sp_changedbowner 'sa';
USE Salesforce; EXEC sp_changedbowner 'sa';
USE ScanConversion; EXEC sp_changedbowner 'sa';
USE Sedona_Support; EXEC sp_changedbowner 'sa';
USE SedonaDocuments; EXEC sp_changedbowner 'sa';
USE SedonaMaster; EXEC sp_changedbowner 'sa'; 
USE [VIVIDREPORTS-SEDONA]; EXEC sp_changedbowner 'sa';

USE DataTransformations; EXEC sp_changedbowner 'sa'; 

