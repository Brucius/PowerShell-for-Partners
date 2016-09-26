## Authenticate as partner
$PacCreds = Get-Credential

## PAC Login
Connect-MsolService -Credential $PacCreds

## Find the company tenant
$TenantId = (Get-MsolPartnerContract -All | Select-Object -Property DefaultDomainName, Name, TenantId | Sort-Object -Property Name | Out-GridView -Title "Find the customer..." -PassThru).TenantId

## Azure Login, must be after finding TenantId
Login-AzureRmAccount -Credential $PacCreds -TenantId $TenantId

## Find the Azure SubscriptionId
## Add count and if for SubscriptionId
$SubId = (Get-AzureRmSubscription -TenantId $TenanId| Out-GridView -Title "Select the subscription..." -PassThru).SubscriptionId

## Input domain name, exclude http and www e.g. microsoft.com
Write-Host "`n`tEnter the domain name: " -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$DomainName = $choice

## Check if DNS Resource Group exists. If not, create it in Australia East (Sydney)
## Add check
New-AzureRmResourceGroup -Name "DNS" -location "Australia East"

## Check is DNS Zone Already exists. If not, create it.
## Add check
New-AzureRmDnsZone -Name $DomainName -ResourceGroupName "DNS"

## Output nameservers
$Records = (Get-AzureRmDnsRecordSet -ZoneName $DomainName -ResourceGroupName "DNS" -RecordType NS).Records
$Records

## Add domain in O365
## Set DNS records
## Verify DNS has propegated