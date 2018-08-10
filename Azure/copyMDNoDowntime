$sourceSubscriptionId='SourceID'
$sourceResourceGroupName='SourceRG'
$managedDiskName='SourceOSDISK'
Select-AzureRmSubscription -SubscriptionId $sourceSubscriptionId
$managedDisk= Get-AzureRMDisk -ResourceGroupName $sourceResourceGroupName -DiskName $managedDiskName
$targetSubscriptionId='TargetID'
$targetResourceGroupName='TargetRG'
Select-AzureRmSubscription -SubscriptionId $targetSubscriptionId
$diskConfig = New-AzureRmDiskConfig -SourceResourceId $managedDisk.Id -Location $managedDisk.Location -CreateOption Copy
New-AzureRmDisk -Disk $diskConfig -DiskName $managedDiskName -ResourceGroupName $targetResourceGroupName
