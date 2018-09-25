#This script is adapted from https://gallery.technet.microsoft.com/scriptcenter/Azure-Clone-an-Network-84ea5fa3
#Repurposed to clone the NSGs with multiple rules across subscription within the same AAD

#name of NSG that you want to copy from source subscription
$sourceSubscriptionId = "sourceSubID"
$nsgOrigin = "sourceNSG" 
#select source subscription
Select-AzureRmSubscription -SubscriptionId $sourceSubscriptionId

#name new NSG  
$nsgDestination = "targetNSG" 
#Resource Group Name of source NSG 
$rgName = "nsgsource" 

$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgOrigin -ResourceGroupName $rgName 
$nsgRules = Get-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg 
$targetSubscriptionId="targetSubID"

Select-AzureRmSubscription -SubscriptionId $targetSubscriptionId
#Resource Group Name when you want the new NSG placed 
$rgNameDest = "nsgTarget"

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
