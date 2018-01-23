## Authenticate as partner
$PacCreds = Get-Credential

## PAC Login
Connect-MsolService -Credential $PacCreds

## Find the company tenant
$TenantId = (Get-MsolPartnerContract -All | Out-GridView -Title "Find the customer..." -PassThru).TenantId

## Azure Login, must be after finding TenantId
Add-AzureRmAccount -Credential $PacCreds -TenantId $TenantId

## Find the Azure SubscriptionId
$SubId = (Get-AzureRmSubscription -TenantId $TenantId | Out-GridView -Title "Select the subscription..." -PassThru).SubscriptionId

## Set the Azure SubscriptionId
Select-AzureRmSubscription -TenantId  $TenantId -SubscriptionId $SubId
