
-- ===============================================================
-- Alter database with modifyingt change tracking options template
-- ===============================================================
USE master
GO

ALTER DATABASE AspenProd SET CHANGE_TRACKING = ON 
(
	CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON
)
GO
 

--==========================================================================
-- Alter Table Enable Change Tracking template
--
-- This template enables the Change Tracking on Table with options
--==========================================================================
USE AspenProd
GO
ALTER TABLE dbo.ArPostingInfo ENABLE CHANGE_TRACKING  
WITH (TRACK_COLUMNS_UPDATED = ON)  

 