$json = Get-Content 'C:\temp\enable\in\a72f2fca-b2b5-41d8-84f6-2a2dfb00f6f3.json' | Out-String | ConvertFrom-Json
Write-Output $json 