## Authenticate as partner
$PacCreds = Get-Credential

## PAC Login
Connect-MsolService -Credential $PacCreds

## Find the company tenant
$TenantId = (Get-MsolPartnerContract -All | Select-Object -Property DefaultDomainName, Name, TenantId | Sort-Object -Property Name | Out-GridView -Title "Find the customer..." -PassThru).TenantId

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
$DisplayName =  "{0}{1}{2}" -f $firstname, ' ', $lastname

## Where is the user
## Write selection menu for countries

## Choose the licenses
$Licenses = (Get-MsolAccountSku -TenantId $TenantId | Out-GridView -PassThru).AccountSkuId

## Set country, default uses tenant country
$Country = (Get-MsolCompanyInformation -TenantId $TenantId).CountryLetterCode

## Create new user and set Object ID variable
New-MsolUser  -TenantId $TenantId -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -UserPrincipalName $UPN -UsageLocation $Country -LicenseAssignment $Licenses
$UserId = (Get-MsolUser -TenantId $TenantId -UserPrincipalName $UPN).ObjectId

## Set alternative email address
Set-MsolUser -Tenant $TenantId -ObjectId $UserId -AlternateEmailAddresses "a@A.com" -MobilePhone $Cellphone

## Show user details
Write-Host "`n`tFirst name: " -ForegroundColor Cyan -nonewline; $FirstName
Write-Host "`n`tLast name: " -ForegroundColor Cyan -nonewline; $LastName
Write-Host "`n`tDisplay name: " -ForegroundColor Cyan -nonewline; $DisplayName
Write-Host "`n`tUser location: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tUPN: " -ForegroundColor Cyan -nonewline; $UPN
Write-Host "`n`tAlternate Email: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tCellphone: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tLicenses: " -ForegroundColor Cyan -nonewline; $Licenses
Write-Host "`n`tTemp Password: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tPSTN Pin: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tPSTN ID: " -ForegroundColor Cyan -nonewline; $Country
Write-Host "`n`tPSTN Number: " -ForegroundColor Cyan -NoNewline; $Country