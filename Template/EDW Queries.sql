select dimAccountOwnerId, count(*) from [Accounts].[FactAccounts] with (nolock)
group by dimAccountOwnerId

select * from accounts.dimaccountOwner

select * from aspenprod..accountowner

select AccountStatusPrimary, count(*) from [Accounts].[FactAccounts] a with (nolock)
	join Accounts.DimAccountStatus st with (nolock) on a.DimAccountStatusId = st.DimAccountStatusId
group by AccountStatusPrimary

select AccountStatusName, count(*) from [Accounts].[FactAccounts] a with (nolock)
	join Accounts.DimAccountStatus st with (nolock) on a.DimAccountStatusId = st.DimAccountStatusId
group by AccountStatusName

select * from accounts.DimAccountStatus
 


select * from [Accounts].[FactAccounts] with (nolock)



 select top 1000 * from Accounts.[FactAccounts] a with (nolock)

 use AspenProdEDW
 go
select 1 As AccountCount
, o.OfficeName, sr.SalesRepName, t.TechnicianName, cs.DayTimestamp as ContractStartDate
	, s.DayTimestamp as StartDate, e.DayTimestamp as EndDate, ast.AccountStatusName, ast.AccountStatusPrimary	
	, ast.AccountStatusSecondary, ds.StateCode, ds.StateName, i.DayTimestamp As InstallDate, c.CompanyName
	, c.CompanyName, c.AccountOwnerName, g.City, g.StateOrProvince, g.Country, cr.DayTimestamp as CreatedDate
	, cd.DayTimestamp as CancelDate, ct.ContractTypeName, st.SystemType, b.BeaconScore As CreditScore
	, pt.AccountPaymentTypeName, ISNULL(a.MonthlyAmount, 0) As MonthlyAmount, a.[1Year], a.[2Year], a.[3Year], a.[4Year]
	, a.ActiveAccount, a.NOCCancel, a.NotNOCCancel, a.HasEmail, a.IsTakeover, a.IsSaved, ISNULL(a.ActiveRMR, 0) As ActiveRMR
	, a.AccountsWithEquip, a.HasActivation, ISNULL(a.ActivationAmount, 0) As ActivationAmount, ISNULL(a.GrossCost, 0) As GrossCost
	, ISNULL(a.NetPoint, 0) As NetPoint, ISNULL(a.PerPoint, 0) As PerPoint, a.IsFunded, a.IsRenter, a.IsActivation, a.IsElderly
from Accounts.[FactAccounts] a with (nolock)
	Left Join Corp.DimOffice o with (nolock) on a.DimOfficeId = o.DimOfficeId
	Left Join Accounts.DimSalesRep sr with (nolock) on a.DimSalesRepId = sr.DimSalesRepId
	Left Join Accounts.DimTechnician t with (Nolock) on a.DimTechnicianId = t.DimTechnicianId
	Left Join Corp.DimDate cs with (nolock) on a.DimDateContractStartId = cs.DimDayId
	Left Join Corp.DimDate s with (nolock) on a.DimDateStartId = s.DimDayId
	Left Join Corp.DimDate e with (nolock) on a.DimDateEndId = e.DimDayId 
	Left Join Accounts.DimAccountStatus ast with (nolock) on a.DimAccountStatusId = ast.DimAccountStatusId
	Left Join Accounts.DimState ds with (nolock) On a.DimStateId = ds.DimStateId
	Left Join Corp.DimDate i with (nolock) On a.DimDateInstallId = i.DimDayId
	Left Join Corp.DimCompany c with (nolock) on a.DimCompanyId = c.DimCompanyId
	Left Join Accounts.DimGeography g with (nolock) on a.DimGeographyId = g.DimGeographyId
	Left Join Corp.DimDate cr with (nolock) on a.DimDateCreatedId = cr.DimDayId
	Left Join Corp.DimDate cd with (nolock) on a.DimCancelDateId = cd.DimDayId
	Left Join Accounts.DimContractType ct with (nolock) on a.DimContractTypeId = ct.DimContractTypeId
	Left Join Accounts.DimSystemType st with (nolock) on a.DimSystemTypeId = st.DimSystemTypeId
	Left Join Accounts.DimBeaconScore b with (nolock) on a.DimBeaconScoreId = b.DimBeaconScoreId
	Left Join Accounts.DimAccountPaymentType pt with (Nolock) on a.DimAccountPaymentTypeId = pt.DimAccountPaymentTypeID
	Left Join Accounts.DimPropertyType pr with (nolock) on a.DimPropertyTypeId = pr.DimPropertyTypeId


select * from 