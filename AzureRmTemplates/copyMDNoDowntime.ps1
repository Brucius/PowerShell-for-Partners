# The following script lets you copy a managed disk across 2 subscriptions in the same tenant instantaneously.
### SOURCE DETAILS
$SourceSubId = 'SourceID'
$SourceRGName = 'SourceRG'
$SourceDiskName = 'SourceOSDISK'

### TARGET DETAILS
$TargetSubId = 'SubID'
$TargetTenantId = 'TenantID'
$TargetRGName = 'TargetRG'

### Select Source Context
Select-AzureRmContext -SubscriptionId $TargetSubId -TenantId $TargetTenantId
$managedDisk= Get-AzureRMDisk -ResourceGroupName $SourceRGName -DiskName $SourceDiskName

### Select Target Context
Select-AzureRmSubscription -SubscriptionId $TargetSubId
$diskConfig = New-AzureRmDiskConfig -SourceResourceId $managedDisk.Id -Location $managedDisk.Location -CreateOption Copy
New-AzureRmDisk -Disk $diskConfig -DiskName $SourceDiskName -ResourceGroupName $TargetRGName
