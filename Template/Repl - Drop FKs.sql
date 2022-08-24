 
SET NOCOUNT ON 
DECLARE @T NVARCHAR(100), @F VARCHAR(80), @Ft VARCHAR(80)

DECLARE cT CURSOR FOR
select table_name from information_schema.tables where table_type = 'BASE TABLE' 

OPEN cT
FETCH NEXT FROM cT INTO @T
WHILE @@FETCH_STATUS = 0
BEGIN
  
  CREATE TABLE #TRef (PK_Table nvarchar(100), FK_Table nvarchar(100), Constraint_Name nvarchar(100), status nvarchar(100), cKeyCol1 nvarchar(80)
	, cKeycol2 nvarchar(80), cKeyCol3 nvarchar(80), cKeyCol4 nvarchar(80), cKeyCol5 nvarchar(80)
	, cKeyCol6 nvarchar(80), cKeyCol7 nvarchar(80), cKeyCol8 nvarchar(80), cKeyCol9 nvarchar(80), cKeyCol10 nvarchar(80)
	, cKeyCol11 nvarchar(80), cKeyCol12 nvarchar(80), cKeyCol13 nvarchar(80), cKeyCol14 nvarchar(80), cKeyCol15 nvarchar(80), cKeyCol16 nvarchar(80)
	, cRefCol1 nvarchar(80), cRefCol2 nvarchar(80), cRefCol3 nvarchar(80), cRefCol4 nvarchar(80), cRefCol5 nvarchar(80)
	, cRefCol6  nvarchar(80), cRefCol7 nvarchar(80) , cRefCol8 nvarchar(80) , cRefCol9 nvarchar(80) , cRefCol10 nvarchar(80)
	, cRefCol11 nvarchar(80) , cRefCol12 nvarchar(80) , cRefCol13 nvarchar(80) , cRefCol14 nvarchar(80) , cRefCol15 nvarchar(80)
	, cRefCol16 nvarchar(80) , PK_Table_Owner nvarchar(80), FK_Table_Owner nvarchar(80)
	, DeleteCascade int, UpdateCascade int )

  insert into #TRef (PK_Table, FK_Table, Constraint_Name, status, cKeyCol1, cKeycol2, cKeyCol3, cKeyCol4, cKeyCol5
	, cKeyCol6, cKeyCol7, cKeyCol8, cKeyCol9, cKeyCol10, cKeyCol11, cKeyCol12, cKeyCol13, cKeyCol14, cKeyCol15, cKeyCol16
	, cRefCol1, cRefCol2, cRefCol3, cRefCol4, cRefCol5, cRefCol6, cRefCol7, cRefCol8, cRefCol9, cRefCol10
	, cRefCol11, cRefCol12, cRefCol13, cRefCol14, cRefCol15, cRefCol16, PK_Table_Owner, FK_Table_Owner
	, DeleteCascade, UpdateCascade )
  EXEC sp_MStablerefs @T, N'actualtables', N'both', null

  DECLARE cF CURSOR FOR
  SELECT Constraint_Name, FK_Table FROM #TRef

  OPEN cF 
  FETCH NEXT FROM cF INTO @F, @Ft
  WHILE @@FETCH_STATUS = 0 
  BEGIN
      PRINT 'ALTER TABLE ' + @Ft 
      PRINT '   DROP CONSTRAINT [' + @F + ']'
      PRINT 'GO'

      FETCH NEXT FROM cF INTO @F, @Ft
  END
  CLOSE cF
  DEALLOCATE cF

  DROP TABLE #TRef 

  FETCH NEXT FROM cT INTO @T

END

CLOSE cT
DEALLOCATE cT
