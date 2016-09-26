## Authenticate as partner
$PacCreds = Get-Credential

## PAC Login
Connect-MsolService -Credential $PacCreds

## Find the company tenant
$TenantId = (Get-MsolPartnerContract -All | Out-GridView -Title "Find the customer..." -PassThru).TenantId

## Choose the domain
$DomainCount = (Get-MsolDomain -TenantId $TenantId | ? {$_.Name -notmatch 'onmicrosoft.com'}).count
if($DomainCount -eq '1'){$Domain = (Get-MsolDomain -TenantId $TenantId | ? {$_.Name -notmatch 'onmicrosoft.com'}).Name}
else {
$Domain = ((Get-MsolDomain -TenantId $TenantId | ? {$_.Name -notmatch 'onmicrosoft.com'}) | Out-GridView -PassThru).Name
}

## Users first name
Write-Host "`n`tEnter the users first name: " -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$FirstName = $choice

## Users last name
Write-Host "`n`tEnter the users first name: " -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$LastName = $choice

## Generate UPN and DisplayName
$UPN = "{0}{1}{2}{3}{4}" -f $firstname, '.', $lastname, '@', $domain
$DisplayName =  "{0}{1}" -f $firstname, $lastname

## Where is the user
## Write selection menu for countries

## Choose the licenses
$Licenses = (Get-MsolAccountSku -TenantId $TenantId | Out-GridView -PassThru).AccountSkuId

## Set country
$Country = (Get-MsolCompanyInformation -TenantId $TenantId).CountryLetterCode
$Country

## Create new user
New-MsolUser  -Tenant $TenantId -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -UserPrincipalName $UPN -UsageLocation $Country -LicenseAssignment $Licenses