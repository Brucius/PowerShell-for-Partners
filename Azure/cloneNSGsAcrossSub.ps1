#This script is adapted from https://gallery.technet.microsoft.com/scriptcenter/Azure-Clone-an-Network-84ea5fa3
#Repurposed to clone the NSGs with multiple rules across subscription within the same AAD

$sourceSubscriptionId = "sourceSubId"
$sourceTenantId = "sourceTenantId"
$nsgOrigin = "sourceNSG" 
$rgName = "sourceRG" #Resource Group Name of source NSG 

$targetSubscriptionId="targetSubId"
$targetTenantId = "targetTenantId"
$nsgDestination = "targetNSG" #name new NSG. Must create in target subscription first
$rgNameDest = "targetRG" #Resource Group Name when you want the new NSG placed 

#select source subscription and get rules
Set-AzureRmContext -SubscriptionId $sourceSubscriptionId -TenantId $sourceTenantId
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgOrigin -ResourceGroupName $rgName 
$nsgRules = Get-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg 

Set-AzureRmContext -SubscriptionId $targetSubscriptionId -TenantId $targetTenantId


$newNsg = Get-AzureRmNetworkSecurityGroup -name $nsgDestination -ResourceGroupName $rgNameDest
foreach ($nsgRule in $nsgRules) { 
    Add-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $newNsg `
        -Name $nsgRule.Name `
        -Protocol $nsgRule.Protocol `
        -SourcePortRange $nsgRule.SourcePortRange `
        -DestinationPortRange $nsgRule.DestinationPortRange `
        -SourceAddressPrefix $nsgRule.SourceAddressPrefix `
        -DestinationAddressPrefix $nsgRule.DestinationAddressPrefix `
        -Priority $nsgRule.Priority `
        -Direction $nsgRule.Direction `
        -Access $nsgRule.Access 
} 
Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $newNsg
