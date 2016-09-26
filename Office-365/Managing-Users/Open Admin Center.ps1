## Authenticate as partner
$PacCreds = Get-Credential

## PAC Login
Connect-MsolService -Credential $PacCreds

## Find the company tenant
$TenantId = (Get-MsolPartnerContract -All | Select-Object -Property DefaultDomainName, Name, TenantId | Sort-Object -Property Name | Out-GridView -Title "Find the customer..." -PassThru).TenantId
$DefaultDomain = (Get-MsolDomain -TenantId $TenantId | ? {$_.Name -match '.onmicrosoft.com'}).name

## Choose Admin Center
## Menu to choose Admin Center

## Open customer O365 Admin Center
Start-Process -FilePath "https://portal.office.com/Partner/BeginClientSession.aspx?CTID=$TenantId&CSDEST=o365admincenter"

## Open customer Azure Portal
Start-Process -FilePath "https://portal.azure.com/$DefaultDomain"