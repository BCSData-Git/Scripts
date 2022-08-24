 
	  

	DECLARE @tableHTML  NVARCHAR(MAX) ;  
	 SET @tableHTML =  
		N'<H1>SHD Aging Notification</H1>' +  
		N'<table border="1">' +  
		N'<tr><th>CSID</th><th>Customer</th>' +  
		N'<th>SalesRep</th><th>[Current-30]</th>' +  
		N'<th>[31-60]</th><th>[61-90]</th>' + 
		N'<th>[91-120]</th><th>[Over 120]</th>' +  
		N'<th>[Total]</th></tr>' +   
	 cast( ( select   
		td =  (asy.CentralStationNumber), '',  
		td =  (c.FullName), '',  
		td =  (u.FirstLastName), '',  
		td =  (CAST([Bucket1] As Decimal(18,2))), '',   
		td =  (CAST([Bucket2] As Decimal(18,2))), '',     
		td =  (CAST([Bucket3] As Decimal(18,2))), '',    
		td =  (CAST([Bucket4] As Decimal(18,2))), '',  
		td =  (CAST([Bucket5] As Decimal(18,2))), '',   
		td =  (CAST([Total] As Decimal(18,2)))   
	From AccountAgingSummary aas
	  Join Account a with (nolock) On aas.AccountId = a.AccountId
	  Join AccountStatus ast with (nolock) On a.AccountStatusId = ast.AccountStatusId
	  Join #EmailFinal ef On a.AccountId = ef.AccountId 
	  Join AccountSystem asy with (Nolock) On a.AccountId = asy.AccountId 
	  Join [User] u with (nolock) On a.SalesRepId = u.userId 
	  Join Contact c with (Nolock) On a.PrimaryContactId = c.ContactId
	Where a.AccountId not in (100001, 100002, 100003, 100004, 100005, 100006, 100007, 100008, 353733 )
		And ([Bucket2] > 0 Or [Bucket3] > 0 Or [Bucket4] > 0 Or [Bucket5] > 0)
		And u.USerId = @UserId
		And ef.QualifiedDate > DateAdd(Month, -16, Cast(Getdate() As DAte) )
		And ast.PrimaryStatus <> 'Cancelled'
	order by 1
    
          FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  
     
  
	 EXEC msdb..sp_send_dbmail  
	  @profile_name =  'SHDAlerts',   
	  @recipients = @EmailAddress,		
	   --@blind_copy_recipients= 'chrisb92881@gmail.com',
	  @subject = 'SHD Aging Notification',  
	  @body = @tableHTML,  
	  @body_format = 'HTML',  
	  @importance ='HIGH'  
      
 
