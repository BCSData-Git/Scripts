--Set CheckSum value on staging table to compare vs target
update f set DWCheckSum_Val = dt.DWChecksum
from AspenProdEDW.[ETLStg].[FactAccounts] f
  join (select AccountId
			, CheckSum([DimAccountId]
			, [DimOfficeId], [DimSalesRepId], [DimTechnicianId], [DimDateContractStartId]
			, [DimDateStartId], [DimDateEndId], [DimDateSurveyCreatedId], [DimAccountStatusId]
			, [DimStateId], [DimDateInstallId], [DimCompanyId], [DimGeographyId], [DimDateCreatedId]
			, [DimCancelDateId], [DimContractTypeId], [DimOfficeConsolId], [DimSystemTypeId], [DimBeaconScoreId]
			, [DimAccountPaymentTypeId], [DimPropertyTypeId], [DimAccountOwnerId], [DimAddressId]
			, [CentralStationNumber], [MonthlyAmount], [CancelPending], [1Year], [2Year], [3Year], [4Year]
			, [ActiveAccount], [NOCCancel], [NotNOCCancel], [HasEmail], [IsTakeover], [IsSaved], [ActiveRMR]
			, [AccountsWithEquip], [HasActivation], [ActivationAmount], [GrossCost], [NetPoint], [NetCost]
			, [PerPoint], [IsFunded], [IsRenter], [IsActivation], [IsElderly], [DateInstall_Source], [DateCreated_Source]
			, [IsNewInstall], [IsPassWelcomeSurvey], [TechProfit], [RankScore], [IsQualified], [NonQualified]
			, [RadixRevenue], [RadixQualCount], IsPassCredit, IsInstalled, IsOwner, Is60Contract, IsACH, IsCancel) as DWChecksum 
		From AspenProdEDW.[ETLStg].[FactAccounts]) dt 
	On f.AccountId = dt.AccountId

--Delete from staging where same
Delete s
From AspenProdEDW.[ETLStg].[FactAccounts] s
	Join AspenProdEDW.Accounts.FactAccounts a On s.AccountId = a.AccountId
Where s.DWCheckSum_Val = a.DWCheckSum_Val 

--Update where different 
Update a Set [DWModifiedDate] = GetDate()
	 , [DimOfficeId] = s.[DimOfficeId]
	 , [DimSalesRepId] = s.[DimSalesRepId]
	 , [DimTechnicianId] = s.[DimTechnicianId]
	 , [DimDateContractStartId] = s.[DimDateContractStartId]
	, [DimDateStartId] = s.[DimDateStartId]
	, [DimDateEndId] = s.[DimDateEndId]
	, [DimDateSurveyCreatedId] = s.[DimDateSurveyCreatedId]
	, [DimAccountStatusId] = s.[DimAccountStatusId]
	, [DimStateId] = s.[DimStateId]
	, [DimDateInstallId] = s.[DimDateInstallId]
	, [DimCompanyId] = s.[DimCompanyId]
	, [DimGeographyId] = s.[DimGeographyId]
	, [DimDateCreatedId] = s.[DimDateCreatedId]
	, [DimCancelDateId] = s.[DimCancelDateId]
	, [DimContractTypeId] = s.[DimContractTypeId]
	, [DimOfficeConsolId] = s.[DimOfficeConsolId]
	, [DimSystemTypeId] = s.[DimSystemTypeId]
	, [DimBeaconScoreId] = s.[DimBeaconScoreId]
	, [DimAccountPaymentTypeId] = s.[DimAccountPaymentTypeId]
	, [DimPropertyTypeId] = s.[DimPropertyTypeId]
	, [DimAccountOwnerId] = s.[DimAccountOwnerId]
	, [DimAddressId] = s.[DimAddressId]
	, [CentralStationNumber] = s.[CentralStationNumber]
	, [MonthlyAmount] = s.[MonthlyAmount]
	, [CancelPending] = s.[CancelPending]
	, [1Year] = s.[1Year]
	, [2Year] = s.[2Year]
	, [3Year] = s.[3Year]
	, [4Year] = s.[4Year]
	, [ActiveAccount] = s.[ActiveAccount]
	, [NOCCancel] = s.[NOCCancel]
	, [NotNOCCancel] = s.[NotNOCCancel]
	, [HasEmail] = s.[HasEmail]
	, [IsTakeover] = s.[IsTakeover]
	, [IsSaved] = s.[IsSaved]
	, [ActiveRMR] = s.[ActiveRMR]
	, [AccountsWithEquip] = s.[AccountsWithEquip]
	, [HasActivation] = s.[HasActivation]
	, [ActivationAmount] = s.[ActivationAmount]
	, [GrossCost] = s.[GrossCost]
	, [NetPoint] = s.[NetPoint]
	, [NetCost] = s.[NetCost]
	, [PerPoint] = s.[PerPoint]
	, [IsFunded] = s.[IsFunded]
	, [IsRenter] = s.[IsRenter]
	, [IsActivation] = s.[IsActivation]
	, [IsElderly] = s.[IsElderly]
	, [DateInstall_Source] = s.[DateInstall_Source]
	, [DateCreated_Source] = s.[DateCreated_Source]
	, [IsNewInstall] = s.[IsNewInstall]
	, [IsPassWelcomeSurvey] = s.[IsPassWelcomeSurvey]
	, [TechProfit] = s.[TechProfit]
	, [RankScore] = s.[RankScore]
	, [IsQualified] = s.[IsQualified]
	, [NonQualified] = s.[NonQualified]
	, [RadixRevenue] = s.[RadixRevenue]
	, [RadixQualCount] = s.[RadixQualCount]
	, IsOwner = s.IsOwner
	, Is60Contract = s.Is60Contract
	, IsACH = s.IsACH
	, IsCancel = s.IsCancel
	, IsInstalled = s.IsInstalled
	, [DWCheckSum_Val] = s.[DWCheckSum_Val]
From AspenProdEDW.Accounts.[FactAccounts] a
  JOin AspenProdEDW.[ETLStg].FactAccounts s On a.AccountId = s.AccountId
Where a.[DWCheckSum_Val] <> s.[DWCheckSum_Val]


--Insert where not exists 
Insert Into AspenProdEDW.Accounts.[FactAccounts] (
	  [DWInsertedDate], [DWModifiedDate], [AccountId], [DimAccountId]
	, [DimOfficeId], [DimSalesRepId], [DimTechnicianId], [DimDateContractStartId]
	, [DimDateStartId], [DimDateEndId], [DimDateSurveyCreatedId], [DimAccountStatusId]
	, [DimStateId], [DimDateInstallId], [DimCompanyId], [DimGeographyId], [DimDateCreatedId]
	, [DimCancelDateId], [DimContractTypeId], [DimOfficeConsolId], [DimSystemTypeId], [DimBeaconScoreId]
	, [DimAccountPaymentTypeId], [DimPropertyTypeId], [DimAccountOwnerId], [DimAddressId]
	, [CentralStationNumber], [MonthlyAmount], [CancelPending], [1Year], [2Year], [3Year], [4Year]
	, [ActiveAccount], [NOCCancel], [NotNOCCancel], [HasEmail], [IsTakeover], [IsSaved], [ActiveRMR]
	, [AccountsWithEquip], [HasActivation], [ActivationAmount], [GrossCost], [NetPoint], [NetCost]
	, [PerPoint], [IsFunded], [IsRenter], [IsActivation], [IsElderly], [DateInstall_Source], [DateCreated_Source]
	, [IsNewInstall], [IsPassWelcomeSurvey], [TechProfit], [RankScore], [IsQualified], [NonQualified]
	, [RadixRevenue], [RadixQualCount]
	, IsOwner, Is60Contract, IsACH, IsCancel, IsInstalled
	, [DWCheckSum_Val]
	)
Select GetDate() As [DWInsertedDate], NULL As [DWModifiedDate], s.[AccountId], [DimAccountId]
	, [DimOfficeId], [DimSalesRepId], [DimTechnicianId], [DimDateContractStartId]
	, [DimDateStartId], [DimDateEndId], [DimDateSurveyCreatedId], [DimAccountStatusId]
	, [DimStateId], [DimDateInstallId], [DimCompanyId], [DimGeographyId], [DimDateCreatedId]
	, [DimCancelDateId], [DimContractTypeId], [DimOfficeConsolId], [DimSystemTypeId], [DimBeaconScoreId]
	, [DimAccountPaymentTypeId], [DimPropertyTypeId], [DimAccountOwnerId], [DimAddressId]
	, [CentralStationNumber], [MonthlyAmount], [CancelPending], [1Year], [2Year], [3Year], [4Year]
	, [ActiveAccount], [NOCCancel], [NotNOCCancel], [HasEmail], [IsTakeover], [IsSaved], [ActiveRMR]
	, [AccountsWithEquip], [HasActivation], [ActivationAmount], [GrossCost], [NetPoint], [NetCost]
	, [PerPoint], [IsFunded], [IsRenter], [IsActivation], [IsElderly], [DateInstall_Source], [DateCreated_Source]
	, [IsNewInstall], [IsPassWelcomeSurvey], [TechProfit], [RankScore], [IsQualified], [NonQualified]
	, [RadixRevenue], [RadixQualCount]
	, IsOwner, Is60Contract, IsACH, IsCancel, IsInstalled
	, [DWCheckSum_Val]
From  AspenProdEDW.[ETLStg].[FactAccounts] s with (nolock)
	Left JOin (Select AccountId From AspenProdEDW.Accounts.[FactAccounts] with (nolock)) a On s.AccountId = a.AccountId
Where a.AccountId Is Null