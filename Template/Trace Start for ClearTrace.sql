 exec Maintenance.dbo.[admin_trace_start] @Directory = 'C:\MSSQL\dbTrace'
  , @FileName = 'VSQLSERVER', @TraceMinutes = 5