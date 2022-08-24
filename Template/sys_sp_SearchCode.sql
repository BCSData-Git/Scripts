USE [DBNAME]
GO
/****** Object:  StoredProcedure [dbo].[sys_sp_SearchCode]    Script Date: 10/17/2021 11:11:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sys_sp_SearchCode]
(
@sText 	varchar(100),
@RowsReturned	int = NULL	OUT
)
AS
-- =============================================
-- AUTHOR: Chris Becker             
-- Search the stored proceudre, UDF, trigger code for a given keyword.
-- Last Updated 6/13/2014
-- **** Please edit this from the file in the repo only.  Changes made directly will be over written ****
-- =============================================
BEGIN
	SET NOCOUNT ON

	SELECT	DISTINCT USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) AS 'Object name',
		CASE 
 			WHEN OBJECTPROPERTY(c.id, 'IsReplProc') = 1 
				THEN 'Replication stored procedure'
 			WHEN OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1 
				THEN 'Extended stored procedure'				
			WHEN OBJECTPROPERTY(c.id, 'IsProcedure') = 1 
				THEN 'Stored Procedure' 
			WHEN OBJECTPROPERTY(c.id, 'IsTrigger') = 1 
				THEN 'Trigger' 
			WHEN OBJECTPROPERTY(c.id, 'IsTableFunction') = 1 
				THEN 'Table-valued function' 
			WHEN OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1 
				THEN 'Scalar-valued function'
 			WHEN OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1 
				THEN 'Inline function'	
		END AS 'Object type',
		'EXEC sp_helptext ''' + USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) + '''' AS 'Run this command to see the object text'
	FROM	syscomments c
		INNER JOIN
		sysobjects o
		ON c.id = o.id
	WHERE	c.text LIKE '%' + @sText + '%'	AND
		encrypted = 0				AND
		(
		OBJECTPROPERTY(c.id, 'IsReplProc') = 1		OR
		OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1	OR
		OBJECTPROPERTY(c.id, 'IsProcedure') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTrigger') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTableFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1	
		)

	ORDER BY	'Object type', 'Object name'

	SET @RowsReturned = @@ROWCOUNT
END




